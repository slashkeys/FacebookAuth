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
    config = FacebookAuth.Config(appID: "1234657")
    facebookAuth = FacebookAuth(config: config)
  }
  
  // MARK: - openURL method
  
  func test_the_openURL_method_returns_true_if_it_can_parse_the_token() {
    let url = URL(string: "fb\(config.appID)://authorize/#access_token=124&expires_in=144315")!
    
    XCTAssertTrue(facebookAuth.application(UIApplication.shared, open: url))
  }
  
  func test_the_openURL_method_returns_true_if_it_can_parse_an_error() {
    let url = URL(string: "fb\(config.appID)://authorize?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request")!
    
    XCTAssertTrue(facebookAuth.application(UIApplication.shared, open: url))
  }
  
  func test_the_openURL_method_returns_false_if_it_cannot_parse_a_token_or_an_error() {
    let url = URL(string: "fb\(config.appID)://authorize")!
    
    XCTAssertFalse(facebookAuth.application(UIApplication.shared, open: url))
  }
  
  // MARK: - completionHandler
  
  func test_the_completionHandler_is_not_nil_if_a_handler_is_passed_to_the_authenticate_method() {
    
    facebookAuth.authenticate(onTopOf: UIViewController()) { _, _ in }
    
    XCTAssertNotNil(facebookAuth.completionHandler)
  }
  
  func test_the_completionHandler_gets_called_once_the_token_was_parsed() {
    let exp = expectation(description: "token equals exampleToken")
    let expectedToken = "exampleToken"
    
    facebookAuth.authenticate(onTopOf: UIViewController()) { token, error in
      XCTAssertNil(error)
      XCTAssertEqual(token, expectedToken)
      exp.fulfill()
    }
    
    let callbackURL = URL(string: "fb\(config.appID)://authorize/#access_token=\(expectedToken)&expires_in=5179120")!
    XCTAssertTrue(facebookAuth.application(UIApplication.shared, open: callbackURL))
    
    waitForExpectations(timeout: 0.2)
  }
  
  func test_the_completionHandler_gets_called_once_an_error_was_parsed() {
    let exp = expectation(description: "error equals cancelled")
    
    facebookAuth.authenticate(onTopOf: UIViewController()) { token, error in
      XCTAssertNil(token)
      XCTAssertEqual(error, .cancelled)
      exp.fulfill()
    }
    
    let callbackURL = URL(string: "fb\(config.appID)://authorize?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request")!
    XCTAssertTrue(facebookAuth.application(UIApplication.shared, open: callbackURL))
    
    waitForExpectations(timeout: 0.2)
  }
  
  func test_the_completionHandler_gets_called_once_the_user_dismisses_the_webview() {
    let exp = expectation(description: "Error equals .cancelled")
    
    let safariViewController = SFSafariViewController(url: URL(string: "https://test.com")!)
    let viewController = UIViewController()
    safariViewController.delegate = facebookAuth
    
    facebookAuth.authenticate(onTopOf: viewController) { _, error in
      XCTAssertEqual(error, .cancelled)
      exp.fulfill()
    }
    
    facebookAuth.safariViewControllerDidFinish(safariViewController)
    
    waitForExpectations(timeout: 0.2)
  }
  
}
