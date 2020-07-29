# GTOverlayView

![Language](https://img.shields.io/badge/Language-Swift-orange)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey)
![License](https://img.shields.io/badge/License-MIT-brightgreen)
![Version](https://img.shields.io/badge/Version-1.0.0-blue)

#### Show a customizable overlay view on top of any other view in iOS based projects. 

## About

GTOverlayView is a Swift library that allows to add a semi-transparent or colored overlay view to another view just in a few quick moves. It provides a simple and modern public API through which configuration can be done and the overlay to be shown and removed. 

Suitable for UIKit based projects on iOS.

## Integrating GTOverlayView

To integrate `GTOverlayView` into your projects follow the next steps:

1. Copy the repository's URL to GitHub.
2. Open your project in Xcode.
3. Go to menu **File > Swift Packages > Add Package Dependency...**.
4. Paste the URL, select the package when it appears and click Next.
5. In the *Rules* leave the default option selected (*Up to Next Major*) and click Next.
6. Select the *GTOverlayView* package and select the *Target* to add to; click Finish.
7. In Xcode, select your project in the Project navigator and go to *General* tab.
8. Add GTOverlayView framework under *Frameworks, Libraries, and Embedded Content* section.

Don't forget to import `GTOverlayView` module anywhere you are about to use it:

```swift
import GTOverlayView
```

## Public API

```swift

// -- Class Methods

// Create a new `GTOverlayView` instance and add it as a subview to the given view.
addOverlay(to:)

// Remove the overlay view from the given view animated.
removeOverlayView(from:duration:)



// -- Instance Methods

// Update the overlay view color.
updateOverlayColor(with:)

// Update the default animation duration when tapping to dismiss the overlay view.
updateRemoveAnimationDuration(with:)

// Set a delay between the time the overlay view is tapped to be removed
// and the time it gets removed.
setDelayWhenRemovingOnTap(_:)

// Show the overlay view animated.
showAnimated(duration:completion:)

// Disable the capability to dismiss the overlay view when tapping on it.
disableRemoveOnTap()

// Provide a closure with custom actions that should be called right when
// the overlay view has disappeared from its super view.
onRemove(handler:)

// Provide a closure with custom actions that should be called when
// the overlay view is tapped.
onTap(handler:)
```

## Usage Example

The simplest way to present the overlay view to another view is the following:

```swift
GTOverlayView.addOverlay(to: self.view).showAnimated()
```

![GTOverlayView Sample](https://gtiapps.com/custom_media/gtoverlayview/gtoverlayview_sample.gif)

The overlay view will be presented animated using a default duration. `showAnimated()` can accept a duration and a completion handler argument optionally:

```swift
GTOverlayView.addOverlay(to: self.view)
    .showAnimated(duration: 0.75) {
        // Do something when the overlay has been presented...
}
```

You can modify various parameters of the overlay view. For example, the following updates the overlay color and changes the default animation duration when tapping on the overlay to dismiss it: 

```swift
GTOverlayView.addOverlay(to: self.view)
    GTOverlayView.addOverlay(to: self.view)
    .updateOverlayColor(with: UIColor(red: 0, green: 0.25, blue: 0.75, alpha: 0.75))
    .updateRemoveAnimationDuration(with: 0.1)
    .showAnimated()
```

`GTOverlayView` allows to perform custom actions when the overlay view is tapped. Just provide a closure to the `onTap(handler:)` method as shown next:

```swift
GTOverlayView.addOverlay(to: self.view)
    .onTap {
        print("Overlay view was tapped!")
        // Do something when the overlay view is tapped...
    }
    .showAnimated()
```

Besides the `onTap(handler:)` method, it's possible to be notified when the overlay view has been disappeared and therefore perform any necessary additional actions upon removal by passing another closure to the `onRemove(handler:)` method:

```swift
GTOverlayView.addOverlay(to: self.view)
    .onRemove {
        print("Overlay view has been removed!")
        // Do something when the overlay view has been removed...
    }
    .showAnimated()
```

It's possible to disable overlay removal when tapping on it with the `disableRemoveOnTap()` method:

```swift
GTOverlayView.addOverlay(to: self.view)
    .disableRemoveOnTap()
    .showAnimated()
```

To manually remove the overlay view call the `removeOverlayView(from:duration:)` class method:

```swift
GTOverlayView.removeOverlayView(from: self.view)

// or, overriding the default duration:
GTOverlayView.removeOverlayView(from: self.view, duration: 0.4)
```


## Remarks

* See Xcode's Quick Help for further details on each available method.

* Default overlay color is a semi-transparent gray (`UIColor(white: 0.5, alpha: 0.5)`). Use the `updateOverlayColor(with:)` method to change it. 

* All methods above return a `GTOverlayView` instance except for the `removeOverlayView(from:duration:)` class method which is a `void` method.

* Assigning the initialized `GTOverlayView` instance to a variable or property is optional, as all methods that return it have been marked with the `discardableResult` attribute.

* It's recommended to call the `showAnimated(duration:completion:)` method as the last one.


## Version

Current version is 1.0.0.

## License

GTOverlayView is licensed under the MIT license.
