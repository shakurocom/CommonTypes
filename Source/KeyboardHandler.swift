//
// Copyright (c) 2017-2019 Shakuro (https://shakuro.com/)
// Sergey Laschuk
//

import UIKit

/**
 Utility to handle keyboard appearing & disappearing "in one line".
 */
@MainActor
public class KeyboardHandler {

    /**
     if `false` notifications about keyboard changes will be skipped.
     Default value is `false`.
     */
    public var isActive: Bool = false

    private let heightDidChangeHandler: (KeyboardChange) -> Void
    private var observerTokens: [NSObjectProtocol]
    private let isCurveHackEnabled: Bool

    // MARK: - Initialization

    /**
     - parameter enableCurveHack: enables hack to obtain animation curve of the keyboard.
     - parameter heightDidChange: main handler of keyboard change, will be called on main thread.
     */
    public init(enableCurveHack: Bool, heightDidChange handler: @escaping (_ change: KeyboardChange) -> Void) {
        heightDidChangeHandler = handler
        observerTokens = []
        isCurveHackEnabled = enableCurveHack

        let center: NotificationCenter = NotificationCenter.default
        let willShowKeyboardObserverToken = center.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: { (notification) in
                let userInfo = notification.userInfo
                let keyboardFrame: CGRect? = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                let duration: Float? = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue
                let curveValue: Int? = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
                Task(operation: { @MainActor in
                    guard self.isActive else {
                        return
                    }
                    self.heightDidChangeHandler(KeyboardChange(keyboardFrame: keyboardFrame,
                                                               duration: duration,
                                                               curveValue: curveValue,
                                                               enableCurveHack: self.isCurveHackEnabled))
                })
            })
        observerTokens.append(willShowKeyboardObserverToken)
        let willHideKeyboardObserverToken = center.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil,
            using: { (notification) in
                let userInfo = notification.userInfo
                let keyboardFrame: CGRect? = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                let duration: Float? = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue
                let curveValue: Int? = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
                Task(operation: { @MainActor in
                    guard self.isActive else {
                        return
                    }
                    self.heightDidChangeHandler(KeyboardChange(keyboardFrame: keyboardFrame,
                                                               duration: duration,
                                                               curveValue: curveValue,
                                                               enableCurveHack: self.isCurveHackEnabled))
                })
            })
        observerTokens.append(willHideKeyboardObserverToken)
    }

    deinit {
        MainActor.assumeIsolated({
            let center: NotificationCenter = NotificationCenter.default
            for token in observerTokens {
                center.removeObserver(token)
            }
        })
    }

}

extension KeyboardHandler {

    private enum Constant {
        static let defaultAnimationDuration: TimeInterval = 0.25
        static let defaultAnimationCurve: UIView.AnimationCurve = .easeIn
    }

    @MainActor
    public struct KeyboardChange {

        public let newHeight: CGFloat
        public let animationDuration: TimeInterval
        public let animationCurve: UIView.AnimationCurve

        internal init(keyboardFrame: CGRect?, duration: Float?, curveValue: Int?, enableCurveHack: Bool) {
            if let keyboardFrameActual = keyboardFrame,
               keyboardFrameActual.height > 0 { // if Accessibility -> Motion -> Reduce Motion and Prefer Cross-Fade Transitions
                let screenSize: CGRect = UIScreen.main.bounds
                newHeight = screenSize.height - keyboardFrameActual.origin.y
            } else {
                newHeight = 0.0
            }
            if let durationActual = duration, durationActual > 0 {
                animationDuration = TimeInterval(durationActual)
            } else {
                animationDuration = Constant.defaultAnimationDuration
            }
            if enableCurveHack {
                // HACK: UIViewAnimationCurve doesn't expose the keyboard animation used (curveValue = 7),
                // so UIViewAnimationCurve(rawValue: curveValue) returns nil. As a workaround, get a
                // reference to an EaseIn curve, then change the underlying pointer data with that ref.
                var curve = Constant.defaultAnimationCurve
                if let curveValueActual = curveValue {
                    NSNumber(value: curveValueActual).getValue(&curve)
                }
                animationCurve = curve
            } else {
                animationCurve = Constant.defaultAnimationCurve
            }
        }

    }

}
