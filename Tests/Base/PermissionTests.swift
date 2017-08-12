//
// Created by Moritz Lang on 12.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import XCTest
@testable import FacebookAuth

final class FacebookAuth_PermissionTests: XCTestCase {
  // MARK: - permissions to scope
  func test_it_converts_a_single_permission_to_a_scope() {
    XCTAssertEqual(FacebookAuth.Permission.permissionsToScope([.email]), "email")
  }

  func test_it_converts_multiple_permissions_to_a_comma_separated_scope() {
    XCTAssertEqual(FacebookAuth.Permission.permissionsToScope([.publicProfile,.adsRead]), "public_profile,ads_read")
  }

  // MARK: - scope to permissions
  func test_it_converts_a_scope_to_an_array_of_permissions() {
    let scope = "email,public_profile,user_about_me"
    let expectedPermissions: [FacebookAuth.Permission] = [.email, .publicProfile, .userAboutMe]

    XCTAssertEqual(FacebookAuth.Permission.scopeToPermissions(scope), expectedPermissions)
  }

  func test_it_converts_a_scope_with_an_unknown_permission_to_the_unknown_case() {
    let scope = "something_unknown"

    XCTAssertEqual(FacebookAuth.Permission.scopeToPermissions(scope), [.unknown])
  }
}
