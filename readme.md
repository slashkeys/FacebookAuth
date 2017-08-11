# FacebookAuth

[![Build Status](https://travis-ci.org/slashkeys/FacebookAuth.svg?branch=master)](https://travis-ci.org/slashkeys/FacebookAuth)
[![Coverage Status](https://coveralls.io/repos/github/slashkeys/FacebookAuth/badge.svg?branch=master)](https://coveralls.io/github/slashkeys/FacebookAuth?branch=master)
![Swift Version](https://img.shields.io/badge/swift-3.1-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Facebook authentication for iOS in pure Swift without any internal dependencies 🚀

## Installation

### Carthage

Add the following to your Cartfile:

```ruby
github "slashkeys/FacebookAuth"
```

### Cocoapods

Add the following to your Podfile:

``` ruby
pod 'FacebookAuth'
```

### Usage

The main goal of **FacebookAuth** is it's simple usage. To get started you have to follow these three steps:

#### 1. Create a new `FacebookAuth` instance

``` swift
let config = FacebookAuth.Config(appID: "facebookAppID")
let facebookAuth = FacebookAuth(config: config)
```

#### 2. Configure the instance to handle Facebook responses

In your `AppDelegate`, add the following method:

``` swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
    return facebookAuth.handle(url)
}
```

#### 3. Configure your URL schemes

Open your Info.plist as "Source Code" and add the following snippet:

``` xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fb<YourFacebookAppID></string>
        </array>
    </dict>
</array>
```

> Make sure to replace `<YourFacebookAppID>` with your Faceboook application ID.

#### 4. Call the authenticate method

Now the only thing left to do is to call `authenticate` on the `FacebookAuth` instance and the library should do the rest.

``` swift
// self is the current `UIViewController`.
facebookAuth.authenticate(onTopOf: self) { result in
    guard let token = result.token else {
        guard let error = result.error else { return }
        switch error {
        case .cancelled:
            print("The authentication was cancelled by the user.")
        case .failed:
            print("Something else went wrong.")
        }
        return
    }
    print(token)
}
```
