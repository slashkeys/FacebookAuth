//
// Created by Moritz Lang on 07.08.17.
// Copyright (c) 2017 Slashkeys. All rights reserved.
//

import UIKit
import SafariServices

public final class FacebookAuth: NSObject {
  public struct Config {
    public let appID: String

    public init(appID: String) {
      self.appID = appID
    }
  }

  public enum Error: Swift.Error {
    case cancelled
    case failed
  }

  public struct Result {
    let token: String?
    let error: FacebookAuth.Error?
  }

  public struct URLParser {
  }

  let config: Config
  let urlParser = URLParser()
  var completionHandler: ((Result) -> Void)?
  weak var viewController: UIViewController?
  weak var safariViewController: SFSafariViewController?

  public init(config: Config) {
    self.config = config
  }

  public func authenticate(onTopOf viewController: UIViewController, completion: ((Result) -> Void)?) {
    self.completionHandler = completion
    self.viewController = viewController
    presentSafariViewController(for: config.oAuthURL())
  }

  public func handle(_ url: URL) -> Bool {
    guard url.absoluteString.hasPrefix("fb\(config.appID)") else { return false }
    guard let result = urlParser.result(from: url) else { return false }

    viewController?.presentedViewController?.dismiss(animated: true)

    completionHandler?(result)
    completionHandler = nil

    return true
  }

  private func presentSafariViewController(for url: URL) {
    safariViewController = SFSafariViewController(url: url)
    guard let safariViewController = safariViewController else { return }
    safariViewController.modalPresentationStyle = .overCurrentContext
    safariViewController.delegate = self
    self.viewController?.present(safariViewController, animated: true)
  }
}
