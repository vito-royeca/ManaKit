# ManaKit

[![CI Status](http://img.shields.io/travis/jovito-royeca/ManaKit.svg?style=flat)](https://travis-ci.org/jovito-royeca/ManaKit)
[![Version](https://img.shields.io/cocoapods/v/ManaKit.svg?style=flat)](http://cocoapods.org/pods/ManaKit)
[![License](https://img.shields.io/cocoapods/l/ManaKit.svg?style=flat)](http://cocoapods.org/pods/ManaKit)
[![Platform](https://img.shields.io/cocoapods/p/ManaKit.svg?style=flat)](http://cocoapods.org/pods/ManaKit)

A Core Data implementation of [Scryfall](http://scryfall.com/).

## Usage

The singleton `ManaKit` class provides API methods for setting up theRealmdatabase, getting images embedded in the framework, and a lot more.

Set up ManaKit in your app delegate class:

````
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // Override point for customization after application launch.
    ManaKit.sharedInstance.setupResources()
    ManaKit.sharedInstance.configureTcgPlayer(partnerKey: "Your_Partner_Key", publicKey: nil, privateKey: nil)
        
    return true
}
````

To access the Realm database, you may use the `realm` of `ManaKit`:

`ManaKit` also provides methods to get MTG images.

Specific images:

```
open func imageFromFramework(imageName: ImageName) -> UIImage?
```

Casting Cost images:

```
open func manaImages(manaCost: String) -> [[String:UIImage]]
```

Card image:

```
open func downloadCardImage(_ card: CMCard, cropImage: Bool, completion: @escaping (_ card: CMCard, _ image: UIImage?, _ croppedImage: UIImage?, _ error: NSError?) -> Void)
```

`TCG Player` Hi-Mid-Low Pricing API.

```
open func fetchTCGPlayerPricing(card: CMCard, completion: @escaping (_ cardPricing: CMCardPricing?, _ error: Error?) -> Void)
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

ManaKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ManaKit"
```

## Author

Vito Royeca
vito.royeca@gmail.com

## License

ManaKit is available under the MIT license. See the LICENSE file for more info.
