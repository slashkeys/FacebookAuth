//
// Created by Moritz Lang on 12.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

extension FacebookAuth.Permission {
  static func permissionsToScope(_ permissions: [FacebookAuth.Permission]) -> String {
    return permissions
      .map { $0.rawValue }
      .joined(separator: ",")
  }

  static func scopeToPermissions(_ scope: String) -> [FacebookAuth.Permission] {
    return scope.characters
      .split(separator: ",")
      .map {
        guard let permission = FacebookAuth.Permission(rawValue: String($0)) else {
          return FacebookAuth.Permission.unknown
        }
        return permission
      }
  }
}
