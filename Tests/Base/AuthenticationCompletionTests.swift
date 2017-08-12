//
// Created by Moritz Lang on 12.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import XCTest
@testable import FacebookAuth

final class FacebookAuth_AuthenticationCompletionTests: XCTestCase {
  var facebookAuth: FacebookAuth!
  var config: FacebookAuth.Config!

  override func setUp() {
    super.setUp()
    config = FacebookAuth.Config(appID: "1234657")
    facebookAuth = FacebookAuth(config: config)
  }

  func test_it_is_not_nil_if_a_closure_is_passed_to_authenticate() {
    facebookAuth.authenticate(onTopOf: UIViewController()) { _ in }

    XCTAssertNotNil(facebookAuth.completionHandler)
  }

  func test_it_is_called_once_the_token_was_parsed() {
    let exp = expectation(description: "token equals expectedToken")
    let expectedToken = "131453736476243746"

    facebookAuth.authenticate(onTopOf: UIViewController()) { result in
      XCTAssertNil(result.error)
      XCTAssertEqual(result.token, expectedToken)
      XCTAssertEqual(result.granted!, [.publicProfile])
      exp.fulfill()
    }

    let url = URL(string: "fb\(config.appID)://authorize/#access_token=\(expectedToken)&expires_in=1&granted_scopes=public_profile")!
    XCTAssertTrue(facebookAuth.handle(url))

    waitForExpectations(timeout: 0.2)
  }

  func test_it_is_called_once_an_error_was_parsed() {
    let exp = expectation(description: "error equals .failed")

    facebookAuth.authenticate(onTopOf: UIViewController()) { result in
      XCTAssertNil(result.token)
      XCTAssertNil(result.granted)
      XCTAssertEqual(result.error, .failed)
      exp.fulfill()
    }

    let url = URL(string: "fb\(config.appID)://authorize?error_reason=failed&error=unknown")!
    XCTAssertTrue(facebookAuth.handle(url))

    waitForExpectations(timeout: 0.2)
  }

  func test_it_is_called_once_the_user_dismissed_the_webView() {
    let exp = expectation(description: "error equals .cancelled")

    facebookAuth.authenticate(onTopOf: UIViewController()) { result in
      XCTAssertNil(result.token)
      XCTAssertNil(result.granted)
      XCTAssertEqual(result.error, .cancelled)
      exp.fulfill()
    }

    XCTAssertNotNil(facebookAuth.safariViewController)

    facebookAuth.safariViewControllerDidFinish(facebookAuth.safariViewController!)

    waitForExpectations(timeout: 0.2)
  }
}
