//
//  URL+AuthResult.swift
//  FacebookAuth
//
//  Created by Moritz Lang on 07.08.17.
//  Copyright © 2017 Slashkeys. All rights reserved.
//

import Foundation

extension URL {
  
  func authResult() -> (String?, FacebookAuth.Error?)? {
    guard absoluteString.contains("access_token") else {
      guard absoluteString.contains("error") else { return nil }
      if absoluteString.contains("user_denied") {
        return (nil, .cancelled)
      } else {
        return (nil, .failed)
      }
    }
    let parameters = absoluteString.characters.split(separator: "#")[1]
    let tokenParameter = parameters.split(separator: "&")[0]
    let token = String(tokenParameter.split(separator: "=")[1])
    return (token, nil)
  }
  
}
