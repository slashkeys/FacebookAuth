//
// Created by Moritz Lang on 07.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import SafariServices

extension FacebookAuth: SFSafariViewControllerDelegate {
  public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    completionHandler?(FacebookAuth.Result(token: nil, error: .cancelled, granted: nil))
  }
}
