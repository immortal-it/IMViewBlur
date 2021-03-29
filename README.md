# IMViewBlur

![Pod Version](https://img.shields.io/cocoapods/v/IMViewBlur.svg?style=flat)
![Pod Platform](https://img.shields.io/cocoapods/p/IMViewBlur.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/IMViewBlur.svg?style=flat)
[![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-green.svg?style=flat)](https://cocoapods.org)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

You can easily use `IMViewBlur` for efficient view blurring on iOS. 

<img src="https://github.com/immortal-it/IMViewBlur/main/Images/demon001.gif">

## Requirements

- iOS 10.0+
- Xcode 11+
- Swift 5.0+

## Installation

### From CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects, which automates and simplifies the process of using 3rd-party libraries like `IMViewBlur` in your projects. First, add the following line to your [Podfile](http://guides.cocoapods.org/using/using-cocoapods.html):

```ruby
pod 'IMViewBlur'
```

If you want to use the latest features of `IMViewBlur` use normal external source dependencies.

```ruby
pod 'IMViewBlur', :git => 'https://github.com/immortal-it/IMViewBlur.git'
```

This pulls from the `main` branch directly.

Second, install `IMViewBlur` into your project:

```ruby
pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate IMViewBlur into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "immortal-it/IMViewBlur" ~> 0.0.1
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but IMViewBlur does support its use on supported platforms.

Once you have your Swift package set up, adding IMViewBlur as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/immortal-it/IMViewBlur", .upToNextMajor(from: "0.0.1"))
]
```

### Manually

* Drag the `immortal-it/IMViewBlur` folder into your project.

## Usage

(see sample Xcode project in `Demo`)

Using `IMViewBlur` in your app will usually look as simple as this:

```
if IMViewBlur.isBlurred(for: view) {
    IMViewBlur.unBlur(from: view, duration: 0.5)
} else {
    IMViewBlur.blur(in: view, radius: 6.0, duration: 0.5)
}
```

## License

`IMViewBlur` is distributed under the terms and conditions of the [MIT license](https://github.com/immortal-it/IMViewBlur/LICENSE).
