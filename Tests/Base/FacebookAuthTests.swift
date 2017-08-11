//
//  FacebookAuthTests.swift
//  Tests
//
//  Created by Moritz Lang on 07.08.17.
//  Copyright © 2017 Slashkeys. All rights reserved.
//

import XCTest
import SafariServices
@testable import FacebookAuth

final class FacebookAuthTests: XCTestCase {
  var facebookAuth: FacebookAuth!
  var config: FacebookAuth.Config!

  override func setUp() {
    super.setUp()
    config = FacebookAuth.Config(appID: "1234657")
    facebookAuth = FacebookAuth(config: config)
  }

  func test_handle_url_returns_false_if_the_url_does_not_contain_fb() {
    let url = URL(string: "xy://example")!

    XCTAssertFalse(facebookAuth.handle(url))
  }

  func test_handle_url_returns_false_if_no_result_can_be_parsed() {
    let url = URL(string: "fb\(config.appID)://authorize")!

    XCTAssertFalse(facebookAuth.handle(url))
  }

  func test_handle_url_returns_true_if_the_token_can_be_parsed() {
    let url = URL(string: "fb\(config.appID)://authorize/#access_token=1245376&expires_in=144315")!

    XCTAssertTrue(facebookAuth.handle(url))
  }

  func test_handle_url_returns_true_if_an_error_can_be_parsed() {
    var urlComponents = URLComponents(string: "fb\(config.appID)://authorize")!
    urlComponents.queryItems = [
      URLQueryItem(name: "error_reason", value: "user_denied"),
      URLQueryItem(name: "error", value: "user_denied"),
      URLQueryItem(name: "error_description", value: "The+user+denied+your+request")
    ]

    XCTAssertTrue(facebookAuth.handle(urlComponents.url!))
  }

  func test_completionHandler_is_not_nil_if_a_handler_is_passed_to_authenticate() {
    facebookAuth.authenticate(onTopOf: UIViewController()) { _ in }

    XCTAssertNotNil(facebookAuth.completionHandler)
  }

  func test_completionHandler_is_called_once_the_token_was_parsed() {
    let exp = expectation(description: "token equals expectedToken")
    let expectedToken = "131453736476243746"

    facebookAuth.authenticate(onTopOf: UIViewController()) { result in
      XCTAssertNil(result.error)
      XCTAssertEqual(result.token, expectedToken)
      exp.fulfill()
    }

    let url = URL(string: "fb\(config.appID)://authorize/#access_token=\(expectedToken)&expires_in=5179")!
    XCTAssertTrue(facebookAuth.handle(url))

    waitForExpectations(timeout: 0.2)
  }

  func test_completionHandler_is_called_once_an_error_was_parsed() {
    let exp = expectation(description: "error equals .failed")

    facebookAuth.authenticate(onTopOf: UIViewController()) { result in
      XCTAssertNil(result.token)
      XCTAssertEqual(result.error, .failed)
      exp.fulfill()
    }

    let url = URL(string: "fb\(config.appID)://authorize?error_reason=failed&error=failed")!
    XCTAssertTrue(facebookAuth.handle(url))

    waitForExpectations(timeout: 0.2)
  }

  func test_completionHandler_is_called_once_the_user_dismisses_the_webview() {
    let exp = expectation(description: "error equals .cancelled")

    facebookAuth.authenticate(onTopOf: UIViewController()) { result in
      XCTAssertNil(result.token)
      XCTAssertEqual(result.error, .cancelled)
      exp.fulfill()
    }

    XCTAssertNotNil(facebookAuth.safariViewController)

    facebookAuth.safariViewControllerDidFinish(facebookAuth.safariViewController!)

    waitForExpectations(timeout: 0.2)
  }
}

//final class FacebookAuthTests: XCTestCase {
//
//  var facebookAuth: FacebookAuth!
//  var config: FacebookAuth.Config!
//
//  override func setUp() {
//    config = FacebookAuth.Config(appID: "1234657")
//    facebookAuth = FacebookAuth(config: config)
//  }
//
//  // MARK: - openURL method
//
//  func test_the_openURL_method_returns_true_if_it_can_parse_the_token() {
//    let url = URL(string: "fb\(config.appID)://authorize/#access_token=124&expires_in=144315")!
//
//    XCTAssertTrue(facebookAuth.application(UIApplication.shared, open: url))
//  }
//
//  func test_the_openURL_method_returns_true_if_it_can_parse_an_error() {
//    let url = URL(string: "fb\(config.appID)://authorize?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request")!
//
//    XCTAssertTrue(facebookAuth.application(UIApplication.shared, open: url))
//  }
//
//  func test_the_openURL_method_returns_false_if_it_cannot_parse_a_token_or_an_error() {
//    let url = URL(string: "fb\(config.appID)://authorize")!
//
//    XCTAssertFalse(facebookAuth.application(UIApplication.shared, open: url))
//  }
//
//  // MARK: - completionHandler
//
//  func test_the_completionHandler_is_not_nil_if_a_handler_is_passed_to_the_authenticate_method() {
//
//    facebookAuth.authenticate(onTopOf: UIViewController()) { _, _ in }
//
//    XCTAssertNotNil(facebookAuth.completionHandler)
//  }
//
//  func test_the_completionHandler_gets_called_once_the_token_was_parsed() {
//    let exp = expectation(description: "token equals exampleToken")
//    let expectedToken = "exampleToken"
//
//    facebookAuth.authenticate(onTopOf: UIViewController()) { token, error in
//      XCTAssertNil(error)
//      XCTAssertEqual(token, expectedToken)
//      exp.fulfill()
//    }
//
//    let callbackURL = URL(string: "fb\(config.appID)://authorize/#access_token=\(expectedToken)&expires_in=5179120")!
//    XCTAssertTrue(facebookAuth.application(UIApplication.shared, open: callbackURL))
//
//    waitForExpectations(timeout: 0.2)
//  }
//
//  func test_the_completionHandler_gets_called_once_an_error_was_parsed() {
//    let exp = expectation(description: "error equals cancelled")
//
//    facebookAuth.authenticate(onTopOf: UIViewController()) { token, error in
//      XCTAssertNil(token)
//      XCTAssertEqual(error, .cancelled)
//      exp.fulfill()
//    }
//
//    let callbackURL = URL(string: "fb\(config.appID)://authorize?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request")!
//    XCTAssertTrue(facebookAuth.application(UIApplication.shared, open: callbackURL))
//
//    waitForExpectations(timeout: 0.2)
//  }
//
//  func test_the_completionHandler_gets_called_once_the_user_dismisses_the_webview() {
//    let exp = expectation(description: "Error equals .cancelled")
//
//    let safariViewController = SFSafariViewController(url: URL(string: "https://test.com")!)
//    let viewController = UIViewController()
//    safariViewController.delegate = facebookAuth
//
//    facebookAuth.authenticate(onTopOf: viewController) { _, error in
//      XCTAssertEqual(error, .cancelled)
//      exp.fulfill()
//    }
//
//    facebookAuth.safariViewControllerDidFinish(safariViewController)
//
//    waitForExpectations(timeout: 0.2)
//  }
//
//}
