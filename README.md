# SFCardStackViewController
A way for presenting view controller inside neat little cards.  

##How it works

Below there is a demo of `SFCardStackViewController` in action. It still needs some polish but for now it gets the job done.

![image](http://i.imgur.com/hE6nD5s.gif)

##Installation

Currently `SFCardStackViewController` is only available via direct download and inclusion of the source code into your project. There are no fancy build settings to tweak, just make sure you link against `QuartzCore` framework.

If you want to use it with Swift there is already a bridging header waiting for you in the demo project provided.

I plan to add Carthage and CocoaPods support as soon as possible. Stay tuned.

##Usage

Usage is really simple. Here's a few lines on how to present the card stack view controller:

ObjC:

```objc
UIViewController *viewController = [YourFancyContentViewController new];
SFCardStackViewController *cardStackViewController = [[SFCardStackViewController alloc] initWithRootViewController:viewController];
    
[cardStackViewController present];
```

Or the Swift counterpart:

```swift
let viewController = YourFancyContentViewController()
let cardStackViewController = SFCardStackViewController(rootViewController: viewController)

cardStackViewController.present()
```

Adding a new card is equally simple:

```objc
UIViewController *viewController = [YourFancyContentViewController new];

[self.cardStackViewController pushViewController:viewController animated:YES];
```

```swift
let viewController = CardViewController()

self.cardStackViewController.pushViewController(viewController, animated: true)
```

The view controller will take care of dismissing itself once all view controllers have dissappeared from the stack. Or if you want to pop a view controller manually you can use:

```objc
[self.cardStackViewController popViewController];
```

```swift
self.cardStackViewController.popViewController()
```

##Contribution

You are more than welcome to drop me a pull request or an issue if you find anything missing and/or would like to see added in the future.

##Licence

SFCardStackViewController is available under the MIT license.

Copyright © 2015 Jan HALOZAN

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
