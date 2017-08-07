//
//  FacebookAuth.swift
//  FacebookAuth
//
//  Created by Moritz Lang on 07.08.17.
//  Copyright © 2017 Slashkeys. All rights reserved.
//

import SafariServices

public final class FacebookAuth: NSObject {
  
  /// Configuration for the FacebookAuth class.
  public struct Config {
    
    /// The Facebook application ID you got from creating a new Facebook app.
    public let appID: String
    
    /// Pass in the application ID of the Facebook app you want to use.
    ///
    /// - Parameter appID: The Facebook application id you got from the developer dashboard.
    public init(appID: String) {
      self.appID = appID
    }
    
    var oAuthDialogURL: URL {
      return URL(string: "https://www.facebook.com/v2.10/dialog/oauth?client_id=\(appID)&redirect_uri=fb\(appID)://authorize&response_type=token")!
    }
    
  }
  
  /// Possible errors used that could happen while autenticating with Facebook.
  ///
  /// - cancelled: The **user cancelled** the auth flow.
  /// - failed: The authentication failed because Facebook threw an error.
  public enum Error: Swift.Error {
    case cancelled
    case failed
  }
  
  let config: Config
  
  weak var viewController: UIViewController?
  
  var completionHandler: ((String?, FacebookAuth.Error?) -> Void)? = nil
  
  public init(config: Config) {
    self.config = config
  }
  
  /// This method is responsible for handling the URL redirected from the Facebook authentication flow.
  /// You should call this method inside your AppDelegates application(:open) method.
  ///
  /// - Parameters:
  ///   - app: The UIApplication which is about to be opened.
  ///   - url: The URL which wants to be opened.
  /// - Returns: Whether FacebookAuth can handle the given URL.
  public func application(_ app: UIApplication, open url: URL) -> Bool {
    guard let (token, error) = url.authResult() else { return false }
    if let token = token {
      completionHandler?(token, nil)
    } else if let error = error {
      completionHandler?(nil, error)
    } else {
      return false
    }
    
    completionHandler = nil
    
    viewController?.presentedViewController?.dismiss(animated: true)
    
    return true
  }
  
  /// This method starts the Facebook authentication flow. It opens a SFSafariViewController on top of the given UIViewController
  /// for the user to enter its Facebook credentials. The SFSafariViewController will be automatically dismissed once Facebook
  /// reacted to the authentication challenge.
  ///
  /// - Parameters:
  ///   - viewController: The UIViewController which the webview should be openend on top of.
  ///   - completion: A closure holding the optional token and an optional FacebookAuthError.
  public func authenticate(onTopOf viewController: UIViewController, completion: ((String?, FacebookAuth.Error?) -> Void)?) {
    if let handler = completion {
      completionHandler = handler
    }
    
    self.viewController = viewController
    
    let safariViewController = SFSafariViewController(url: config.oAuthDialogURL)
    safariViewController.modalPresentationStyle = .overCurrentContext
    safariViewController.delegate = self
    self.viewController?.present(safariViewController, animated: true)
  }

}
