//
// Created by Moritz Lang on 12.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import XCTest
@testable import FacebookAuth

final class FacebookAuth_HandleURLTests: XCTestCase {
  var facebookAuth: FacebookAuth!
  var config: FacebookAuth.Config!

  override func setUp() {
    super.setUp()
    config = FacebookAuth.Config(appID: "1234657")
    facebookAuth = FacebookAuth(config: config)
  }

  func test_it_returns_false_if_the_url_does_not_contain_fb() {
    let url = URL(string: "xy://example")!

    XCTAssertFalse(facebookAuth.handle(url))
  }

  func test_it_returns_false_if_no_result_can_be_parsed() {
    let url = URL(string: "fb\(config.appID)://authorize")!

    XCTAssertFalse(facebookAuth.handle(url))
  }

  func test_it_returns_true_if_the_token_can_be_parsed() {
    let url = URL(string: "fb\(config.appID)://authorize/#access_token=12&expires_in=14&granted_scopes=public_profile")!

    XCTAssertTrue(facebookAuth.handle(url))
  }

  func test_it_returns_true_if_an_error_can_be_parsed() {
    var urlComponents = URLComponents(string: "fb\(config.appID)://authorize")!
    urlComponents.queryItems = [
      URLQueryItem(name: "error_reason", value: "user_denied"),
      URLQueryItem(name: "error", value: "user_denied"),
      URLQueryItem(name: "error_description", value: "The+user+denied+your+request")
    ]

    XCTAssertTrue(facebookAuth.handle(urlComponents.url!))
  }
}
