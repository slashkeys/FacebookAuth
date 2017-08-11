//
// Created by Moritz Lang on 11.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import XCTest
@testable import FacebookAuth

final class FacebookAuth_URLParserTests: XCTestCase {
  func test_it_parses_the_token_if_one_exists() {
    let expectedToken = "124586413854243"
    let url = URL(string: "fb1237://authorize/#access_token=\(expectedToken)&expires_in=1443")!

    XCTAssertEqual(FacebookAuth.URLParser().result(from: url)?.token, expectedToken)
  }

  func test_it_returns_an_cancelled_error_if_the_user_denied() {
    let url = URL(string: "fb1237://authorize?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request")!

    XCTAssertEqual(FacebookAuth.URLParser().result(from: url)?.error, .cancelled)
  }
}
