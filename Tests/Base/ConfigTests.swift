//
//  ConfigTests.swift
//  Tests
//
//  Created by Moritz Lang on 07.08.17.
//  Copyright © 2017 Slashkeys. All rights reserved.
//

import XCTest
@testable import FacebookAuth

final class ConfigTests: XCTestCase {
  
  func test_it_returns_the_correct_oauth_url() {
    let appID = "43145761437"
    let expectedURL = URL(string: "https://www.facebook.com/v2.10/dialog/oauth?client_id=\(appID)&redirect_uri=fb\(appID)://authorize&response_type=token")!
    let config = FacebookAuth.Config(appID: appID)
    
    XCTAssertEqual(config.oAuthDialogURL, expectedURL)
  }
  
}
