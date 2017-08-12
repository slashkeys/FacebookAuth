//
// Created by Moritz Lang on 13.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import XCTest
@testable import FacebookAuth

final class AskForPermissionsCompletionTests: XCTestCase {
  var facebookAuth: FacebookAuth!
  var config: FacebookAuth.Config!

  override func setUp() {
    super.setUp()
    config = FacebookAuth.Config(appID: "1234657")
    facebookAuth = FacebookAuth(config: config)
  }

  func test_it_includes_the_granted_permissions() {
    let exp = expectation(description: "result contains granted permissions")
    let expectedPermissions: [FacebookAuth.Permission] = [.publicProfile, .email, .adsManagement]

    facebookAuth.ask(for: expectedPermissions, onTopOf: UIViewController()) { result in
      XCTAssertNil(result.error)
      XCTAssertEqual(result.token, "12")
      XCTAssertEqual(result.granted!, expectedPermissions)
      exp.fulfill()
    }

    let url = URL(string: "fb\(config.appID)://authorize/#access_token=12&expires_in=1&granted_scopes=public_profile,email,ads_management")!
    XCTAssertTrue(facebookAuth.handle(url))

    waitForExpectations(timeout: 0.2)
  }
}
