//
//  URL+AuthResultTests.swift
//  Tests
//
//  Created by Moritz Lang on 07.08.17.
//  Copyright © 2017 Slashkeys. All rights reserved.
//

import XCTest
@testable import FacebookAuth

final class URL_AuthResultTests: XCTestCase {
  
  func test_it_returns_nil_if_the_url_neither_contains_a_token_nor_an_error() {
    let url = URL(string: "fb123://authorize")!
    
    XCTAssertNil(url.authResult())
  }
  
  func test_it_returns_cancelled_if_the_url_contains_user_denied() {
    let url = URL(string: "fb123://authorize?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request")!
    
    let (token, error) = url.authResult()!
    
    XCTAssertNil(token)
    XCTAssertEqual(error, .cancelled)
  }
  
  func test_it_returns_failed_if_the_url_contains_an_error() {
    let url = URL(string: "fb123://authorize?error_reason=unknown&error=unknown&error_description=Unknown+error")!
    
    let (token, error) = url.authResult()!
    
    XCTAssertNil(token)
    XCTAssertEqual(error, .failed)
  }
  
  func test_it_returns_the_token_if_the_url_contains_one() {
    let expectedToken = "432143413413467724246376"
    let url = URL(string: "fb123://authorize/#access_token=\(expectedToken)&expires_in=144315")!
    
    let (token, error) = url.authResult()!
    
    XCTAssertNil(error)
    XCTAssertEqual(token, expectedToken)
  }
  
//  func test_it_can_parse_a_token_from_an_url() {
//    let expectedToken = "1234431473914524637"
//    let url = URL(string: "fb123://authorize/#access_token=\(expectedToken)&expires_in=144315")!
//
//    XCTAssertEqual(url.facebookAccessToken, expectedToken)
//  }
//
//  func test_it_returns_nil_if_the_url_does_not_contain_a_token() {
//    let url = URL(string: "fb123://authorize")!
//
//    XCTAssertNil(url.facebookAccessToken)
//  }
//
//  func test_it_can_parse_a_cancelled_error_from_an_url() {
//    let url = URL(string: "fb123://authorize?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request")!
//
//    XCTAssertEqual(url.facebookError, .cancelled)
//  }
//
//  func test_it_can_parse_a_failed_error_from_an_url() {
//    let url = URL(string: "fb123://authorize?error_reason=unknown&error=unknown&error_description=Unknown+error")!
//
//    XCTAssertEqual(url.facebookError, .failed)
//  }
//
//  func test_it_returns_nil_if_the_url_does_not_contain_an_error() {
//    let url = URL(string: "fb123://authorize")!
//
//    XCTAssertNil(url.facebookError)
//  }
  
}
