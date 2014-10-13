THProgressHUD
===

[![Pod Version](http://img.shields.io/cocoapods/v/THProgressHUD.svg?style=flat)](http://cocoadocs.org/docsets/THProgressHUD/)
[![Pod Platform](http://img.shields.io/cocoapods/p/THProgressHUD.svg?style=flat)](http://cocoadocs.org/docsets/THProgressHUD/)
[![Pod License](http://img.shields.io/cocoapods/l/THProgressHUD.svg?style=flat)](http://opensource.org/licenses/MIT)

THProgressHUD is a lightweight and easy-to-use HUD for iOS 7/8. (Objective-C)

### Credits

Actually this project is a copy of the great [ProgressHUD](https://github.com/relatedcode/ProgressHUD) control.
Why? So actually the author of the original control [decided to remove it from CocoaPods](https://github.com/relatedcode/ProgressHUD/issues/30), however I want it to be there so I decided to bring it back

# Installation

### CocoaPods

Install with [CocoaPods](http://cocoapods.org) by adding the following to your Podfile:

``` ruby
platform :ios, '7.0'
pod 'THProgressHUD', '~> 1.0.3'
```

**Note**: We follow http://semver.org for versioning the public API.

### Manually

Or copy the `THProgressHUD/` directory from this repo into your project.

## USAGE

1., Add the following import to the top of the file:

```objective-c
#import "ProgressHUD.h"
```

2., Use the following to display the HUD:

```objective-c
[ProgressHUD show:@"Please wait..."];
```

3., Simply dismiss after complete your task:

```objective-c
[ProgressHUD dismiss];
```

#Contributions

...are really welcome. If you have an idea just fork the library change it and if its useful for others and not affecting the functionality of the library for other users I'll insert it

# License

Source code of this project is available under the standard MIT license. Please see [the license file](LICENSE.md).


