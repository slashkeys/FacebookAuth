//
//  FacebookAuth+SFSafariViewControllerDelegate.swift
//  FacebookAuth
//
//  Created by Moritz Lang on 07.08.17.
//  Copyright © 2017 Slashkeys. All rights reserved.
//

import SafariServices

extension FacebookAuth: SFSafariViewControllerDelegate {
  
  public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    completionHandler?(nil, .cancelled)
  }
  
}
