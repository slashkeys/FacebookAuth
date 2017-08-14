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

  public enum Permission: String {
    case publicProfile = "public_profile"
    case userFriends = "user_friends"
    case email
    case userAboutMe = "user_about_me"
    case userActionsBooks = "user_actions_books"
    case userActionsFitness = "user_actions_fitness"
    case userActionsMusic = "user_actions_music"
    case userActionsNews = "user_actions_news"
    case userActionsVideo = "user_actions_video"
    case userBirthday = "user_birthday"
    case userEducationHistory = "user_education_history"
    case userEvents = "user_events"
    case userGamesActivity = "user_games_activity"
    case userHometown = "user_hometown"
    case userLikes = "user_likes"
    case userLocation = "user_location"
    case userManagedGroups = "user_managed_groups"
    case userPhotos = "user_photos"
    case userPosts = "user_posts"
    case userRelationships = "user_relationships"
    case userRelationshipDetails = "user_relationship_details"
    case userReligionAndPolitics = "user_religion_politics"
    case userTaggedPlaces = "user_tagged_places"
    case userVideos = "user_videos"
    case userWebsite = "user_website"
    case userWorkHistory = "user_work_history"
    case readCustomFriendlists = "read_custom_friendlists"
    case readInsights = "read_insights"
    case readPageMailboxes = "read_page_mailboxes"
    case managePages = "manage_pages"
    case publishPages = "publish_pages"
    case publishActions = "publish_actions"
    case rsvpEvent = "rsvp_event"
    case pagesShowList = "pages_show_list"
    case pagesManageCTA = "pages_manage_cta"
    case pagesManageInstantArticles = "pages_manage_instant_articles"
    case adsRead = "ads_read"
    case adsManagement = "ads_management"
    case businessManagement = "business_management"
    case pagesMessaging = "pages_messaging"
    case pagesMessagingSubscriptions = "pages_messaging_subscriptions"
    case pagesMessagingPayments = "pages_messaging_payments"
    case pagesMessagingPhoneNumber = "pages_messaging_phone_number"
    case manageNotifications = "manage_notifications"
    case readStream = "read_stream"
    case readMailbox = "read_mailbox"
    case userGroups = "user_groups"
    case userStatus = "user_status"

    /// Any other permission retrieved from Facebook will be transformed to unknown.
    ///
    /// - Important: This is only for transformation. Don't use this *pseudo* permission in a permission request.
    case unknown
  }

  public struct Result {
    public let token: String?
    public let error: FacebookAuth.Error?
    public let granted: [FacebookAuth.Permission]?
    
    public init(token: String?, error: FacebookAuth.Error?, granted: [FacebookAuth.Permission]?) {
      self.token = token
      self.error = error
      self.granted = granted
    }
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

  public func authenticate(onTopOf viewController: UIViewController, permissions: [Permission] = [.publicProfile], completion: ((Result) -> Void)?) {
    self.completionHandler = completion
    self.viewController = viewController
    presentSafariViewController(for: config.oAuthURL(permissions: permissions))
  }

  public func ask(for permissions: [Permission], onTopOf viewController: UIViewController, completion: ((Result) -> Void)?) {
    self.completionHandler = completion
    self.viewController = viewController
    presentSafariViewController(for: config.oAuthURL(permissions: permissions, rerequest: true))
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
