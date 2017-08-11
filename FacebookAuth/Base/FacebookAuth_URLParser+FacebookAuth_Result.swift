//
// Created by Moritz Lang on 11.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import Foundation

extension FacebookAuth.URLParser {
  public func result(from url: URL) -> FacebookAuth.Result? {
    var token: String? = nil
    var error: FacebookAuth.Error? = nil

    if url.absoluteString.contains("access_token") {
      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
      guard let fragment = urlComponents?.fragment else { return nil }
      urlComponents?.query = fragment
      guard let queryItems = urlComponents?.queryItems else { return nil }
      for queryItem in queryItems {
        if queryItem.name == "access_token" {
          token = queryItem.value
        }
      }
    } else if url.absoluteString.contains("error_reason") {
      let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
      guard let queryItems = urlComponents?.queryItems else { return nil }
      for queryItem in queryItems {
        if queryItem.name == "error_reason" {
          error = queryItem.value == "user_denied" ? .cancelled : .failed
        }
      }
    }

    guard token != nil || error != nil else { return nil }

    return FacebookAuth.Result(token: token, error: error)
  }
}
