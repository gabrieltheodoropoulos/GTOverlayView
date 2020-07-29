import UIKit

public class GTOverlayView: UIView {
    
    // MARK: - Properties
    
    var parentView: UIView?
    
    var removeOnTap = true
    
    var onRemoveHandler: (() -> Void)?
    
    var onTapHandler: (() -> Void)?
    
    var removeAnimationDuration: TimeInterval = 0.25
    
    var removeOnTapDelay: TimeInterval = 0.0
    
    deinit {
        print("Deinit in GTOverlayView!")
    }
    
    // MARK: - Public Class Methods
    
    /**
     Create a new `GTOverlayView` instance and add it as a subview to the given view.
     
     The overlay view is initialized using the following color:
     
     ```
     UIColor(white: 0.5, alpha: 0.5)
     ```
     
     To change it, call the `updateOverlayColor(with:)` method before presenting the overlay view.
     
     This method is marked with the `discardableResult` attribute, so assigning the
     returned object to a variable is optional.
     
     - Parameter view: The view that the overlay view will be added as a subview to.
     - Returns: A `GTOverlayView` instance.
     */
    @discardableResult
    public class func addOverlay(to view: UIView) -> GTOverlayView {
        let overlayView = GTOverlayView(frame: view.bounds)
        overlayView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.addSubview(overlayView)
        overlayView.alpha = 0.0
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        overlayView.parentView = view
        return overlayView
    }
    
    
    /**
     Remove the overlay view from the given view animated.
     
     If an action handler has been set using the `onRemove(handler:)` method, then
     it's called once the overlay view has been disappeared from its super view.
     
     - Parameter view: The view that contains the overlay view.
     - Parameter duration: The dismissal animation duration. Default value is 0.25 seconds.
     To avoid animation, set duration to 0.
     */
    public class func removeOverlayView(from view: UIView, duration: TimeInterval = 0.25) {
        guard let overlayView = view.subviews.filter({ $0.isKind(of: GTOverlayView.self) }).first as? GTOverlayView else { return }
        
        UIView.animate(withDuration: duration, animations: {
            overlayView.alpha = 0.0
        }) { (_) in
            overlayView.onRemoveHandler?()
            overlayView.removeFromSuperview()
            overlayView.cleanUp()
        }
    }
    
    
    
    // MARK: - Instance Methods
    
    /**
     Update the overlay view color.
     
     - Parameter color: The new color to apply to the overlay view.
     - Returns: The `GTOverlayView` instance.
     */
    @discardableResult
    public func updateOverlayColor(with color: UIColor) -> GTOverlayView {
        self.backgroundColor = color
        return self
    }
    
    
    /**
     Update the default animation duration when tapping to dismiss the overlay view.
     
     Default animation duration is 0.25 seconds.
     
     - Parameter duration: The new animation duration to use when tapping to dismiss the overlay view.
     - Returns: The `GTOverlayView` instance.
     */
    @discardableResult
    public func updateRemoveAnimationDuration(with duration: TimeInterval) -> GTOverlayView {
        removeAnimationDuration = duration
        return self
    }
    
    
    /**
     Set a delay between the time the overlay view is tapped to be removed and the
     time it gets removed.
     
     - Parameter delay: The desired delay to use. Default value is 0 seconds.
     - Returns: The `GTOverlayView` instance.
     */
    @discardableResult
    public func setDelayWhenRemovingOnTap(_ delay: TimeInterval) -> GTOverlayView {
        removeOnTapDelay = delay
        return self
    }
    
    
    /**
     Show the overlay view animated.
     
     - Parameter duration: The appearance animation duration. Default value is 0.4 seconds.
     - Parameter completion: An optional completion handler that gets called once the appearance
     animation is over.
     - Returns: The `GTOverlayView` instance.
     */
    @discardableResult
    public func showAnimated(duration: TimeInterval = 0.4, completion: (() -> Void)? = nil) -> GTOverlayView {
        // Add the tap gesture recognizer before presenting the overlay view.
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:))))
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }) { (_) in
            completion?()
        }
        return self
    }
    
    
    /**
     Disable the capability to dismiss the overlay view when tapping on it.
     
     - Returns: The `GTOverlayView` instance.
     */
    @discardableResult
    public func disableRemoveOnTap() -> GTOverlayView {
        removeOnTap = false
        return self
    }
    
    
    /**
     Provide a closure with custom actions that should be called right when the overlay view
     has disappeared from its super view.
     
     - Parameter handler: The closure to call once the overlay view has been disappeared
     and right before it's removed from its super view.
     - Returns: The `GTOverlayView` instance.
     */
    @discardableResult
    public func onRemove(handler: @escaping () -> Void) -> GTOverlayView {
        onRemoveHandler = handler
        return self
    }
    
    
    /**
     Provide a closure with custom actions that should be called when the overlay
     view is tapped.
     
     Note that the closure given to this method will be called regardless of
     whether the overlay view is allowed to be removed on tap or not.
     
     In case of dismissing on tap, the closure is called before
     the overlay view gets removed from its super view.
     
     - Parameter handler: The closure to call on tap.
     - Returns: The `GTOverlayView` instance.
     */
    @discardableResult
    public func onTap(handler: @escaping () -> Void) -> GTOverlayView {
        onTapHandler = handler
        return self
    }
    
    
    // MARK: - Internal Methods
    
    @objc
    func handleTap(gesture: UITapGestureRecognizer) {
        onTapHandler?()
        if removeOnTap {
            DispatchQueue.main.asyncAfter(deadline: .now() + removeOnTapDelay) {
                guard let view = self.parentView else { return }
                GTOverlayView.removeOverlayView(from: view, duration: self.removeAnimationDuration)
            }
        }
    }
    
    
    func cleanUp() {
        parentView = nil
        onRemoveHandler = nil
        onTapHandler = nil
    }
}
