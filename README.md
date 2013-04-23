###iTunesSearchiOS
===============

![Main List](https://dl.dropboxusercontent.com/u/6148369/screenshots/itunessearch1.png)
![Search for Music](https://dl.dropboxusercontent.com/u/6148369/screenshots/itunessearch2.png)

The app allows the user to create a list of music (albums/songs) by comepleting real-time search against the blazingly fast iTunes Search API. Find and manage a simple list of music.

Note: the UI has no polish. This was simply a proof of concept to test the speed of the iTunes Search API. Also, I wanted to play with RestKit (see below).

- ACR enabled
- iPhone-only
- iOS 6.1
- no storyboards
- uses [RestKit](restkit.org)

### Setup RestKit (taken from the RestKit readme)

#### NOTE: you do not have to do this after cloning the repo, just added the steps here for posterity.

The recommended approach for installing RestKit is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation. For best results, it is recommended that you install via CocoaPods **>= 0.15.2** using Git **>= 1.8.0** installed via Homebrew.

### via CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory of your Xcode project, and Create and Edit your Podfile and add RestKit:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
platform :ios, '5.0' 
# Or platform :osx, '10.7'
pod 'RestKit', '~> 0.20.0'

# Testing and Search are optional components
pod 'RestKit/Testing', '~> 0.20.0'
pod 'RestKit/Search',  '~> 0.20.0'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git **>= 1.8.0** by executing `git --version`. You can get a full picture of the installation details by executing `pod install --verbose`.

