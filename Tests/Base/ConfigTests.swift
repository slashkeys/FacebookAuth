//
// Created by Moritz Lang on 07.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import XCTest
@testable import FacebookAuth

final class ConfigTests: XCTestCase {
  func test_it_returns_the_correct_oauth_url() {
    let appID = "43145761437"
    let queryItems = [
      URLQueryItem(name: "client_id", value: appID),
      URLQueryItem(name: "redirect_uri", value: "fb\(appID)://authorize&response_type=token")
    ]
    var urlComponents = URLComponents(string: "https://www.facebook.com/v2.10/dialog/oauth")!
    urlComponents.queryItems = queryItems
    let expectedURL = urlComponents.url!

    let config = FacebookAuth.Config(appID: appID)
    XCTAssertEqual(config.oAuthURL(), expectedURL)
  }
}
