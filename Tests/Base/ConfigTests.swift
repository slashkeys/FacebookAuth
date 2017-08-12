//
// Created by Moritz Lang on 07.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import XCTest
@testable import FacebookAuth

final class ConfigTests: XCTestCase {
  func test_it_returns_the_correct_oauth_url_without_permissions() {
    let appID = "43145761437"
    let queryItems = [
      URLQueryItem(name: "client_id", value: appID),
      URLQueryItem(name: "redirect_uri", value: "fb\(appID)://authorize"),
      URLQueryItem(name: "response_type", value: "token,granted_scopes"),
      URLQueryItem(name: "scope", value: "")
    ]
    var urlComponents = URLComponents(string: "https://www.facebook.com/v2.10/dialog/oauth")!
    urlComponents.queryItems = queryItems
    let expectedURL = urlComponents.url!

    let config = FacebookAuth.Config(appID: appID)
    XCTAssertEqual(config.oAuthURL(permissions: []), expectedURL)
  }

  func test_it_returns_the_correct_oauth_url_with_permissions() {
    let appID = "43145761437"
    let queryItems = [
      URLQueryItem(name: "client_id", value: appID),
      URLQueryItem(name: "redirect_uri", value: "fb\(appID)://authorize"),
      URLQueryItem(name: "response_type", value: "token,granted_scopes"),
      URLQueryItem(name: "scope", value: "public_profile,ads_read,user_about_me")
    ]
    var urlComponents = URLComponents(string: "https://www.facebook.com/v2.10/dialog/oauth")!
    urlComponents.queryItems = queryItems
    let expectedURL = urlComponents.url!

    let config = FacebookAuth.Config(appID: appID)
    XCTAssertEqual(config.oAuthURL(permissions: [.publicProfile,.adsRead,.userAboutMe]), expectedURL)
  }

  func test_it_returns_the_correct_oauth_url_to_ask_for_permissions() {
    let appID = "43145761437"
    let queryItems = [
      URLQueryItem(name: "client_id", value: appID),
      URLQueryItem(name: "redirect_uri", value: "fb\(appID)://authorize"),
      URLQueryItem(name: "response_type", value: "token,granted_scopes"),
      URLQueryItem(name: "scope", value: "public_profile,ads_read,user_about_me"),
      URLQueryItem(name: "auth_type", value: "rerequest")
    ]
    var urlComponents = URLComponents(string: "https://www.facebook.com/v2.10/dialog/oauth")!
    urlComponents.queryItems = queryItems
    let expectedURL = urlComponents.url!

    let config = FacebookAuth.Config(appID: appID)
    XCTAssertEqual(config.oAuthURL(permissions: [.publicProfile,.adsRead,.userAboutMe], rerequest: true), expectedURL)
  }
}
