//
// Created by Moritz Lang on 11.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import Foundation

extension FacebookAuth.Config {
  func oAuthURL() -> URL {
    let queryItems = [
      URLQueryItem(name: "client_id", value: appID),
      URLQueryItem(name: "redirect_uri", value: "fb\(appID)://authorize&response_type=token")
    ]
    var urlComponents = URLComponents(string: "https://www.facebook.com/v2.10/dialog/oauth")!
    urlComponents.queryItems = queryItems

    return urlComponents.url!
  }
}
