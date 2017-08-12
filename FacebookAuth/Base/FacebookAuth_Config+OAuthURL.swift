//
// Created by Moritz Lang on 11.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import Foundation

extension FacebookAuth.Config {
  func oAuthURL(permissions: [FacebookAuth.Permission], rerequest: Bool = false) -> URL {
    var queryItems = [
      URLQueryItem(name: "client_id", value: appID),
      URLQueryItem(name: "redirect_uri", value: "fb\(appID)://authorize"),
      URLQueryItem(name: "response_type", value: "token,granted_scopes"),
      URLQueryItem(name: "scope", value: FacebookAuth.Permission.permissionsToScope(permissions))
    ]
    if rerequest {
      queryItems.append(URLQueryItem(name: "auth_type", value: "rerequest"))
    }

    var urlComponents = URLComponents(string: "https://www.facebook.com/v2.10/dialog/oauth")!
    urlComponents.queryItems = queryItems

    return urlComponents.url!
  }
}
