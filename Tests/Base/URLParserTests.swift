//
// Created by Moritz Lang on 11.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import XCTest
@testable import FacebookAuth

final class FacebookAuth_URLParserTests: XCTestCase {
  func test_it_parses_the_token() {
    let expectedToken = "124586413854243"
    let url = URL(string: "fb1237://authorize/#access_token=\(expectedToken)&expires_in=1443&granted_scopes")!

    XCTAssertEqual(FacebookAuth.URLParser().result(from: url)?.token, expectedToken)
  }

  func test_it_parses_the_scope() {
    let expectedPermissions: [FacebookAuth.Permission] = [.publicProfile, .adsRead]
    let url = URL(string: "fb1237://authorize/#access_token=12&expires_in=1443&granted_scopes=public_profile,ads_read")!

    XCTAssertEqual(FacebookAuth.URLParser().result(from: url)!.granted!, expectedPermissions)
  }

  func test_it_parses_a_cancelled_error_if_the_user_cancelled() {
    let url = URL(string: "fb1237://authorize?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request")!

    XCTAssertEqual(FacebookAuth.URLParser().result(from: url)?.error, .cancelled)
  }

  func test_it_parses_a_failed_error_if_there_was_an_unknown_error() {
    let url = URL(string: "fb1237://authorize?error_reason=unknown&error=unknown&error_description=Unknown+error.")!

    XCTAssertEqual(FacebookAuth.URLParser().result(from: url)?.error, .failed)
  }
}
