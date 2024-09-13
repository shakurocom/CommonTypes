//
//
//

import Foundation
import UIKit

public struct DecelerationHelper {

    /// - parameter initialVelocity: in points/millisecond
    /// - parameter decelerationRate: (0; 1)
    public static func project(value: CGFloat, initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
        guard decelerationRate < 1.0 else {
            assert(false)
            return value
        }
        return value + initialVelocity * decelerationRate / (1.0 - decelerationRate)
    }

    /// - parameter initialVelocity: in points/millisecond
    public static func project(value: CGPoint, initialVelocity: CGPoint, decelerationRate: CGPoint) -> CGPoint {
        let xProjection = project(value: value.x, initialVelocity: initialVelocity.x, decelerationRate: decelerationRate.x)
        let yProjection = project(value: value.y, initialVelocity: initialVelocity.y, decelerationRate: decelerationRate.y)
        return CGPoint(x: xProjection, y: yProjection)
    }

    /// - parameter initialVelocity: in points/millisecond
    public static func project(value: CGPoint, initialVelocity: CGPoint, decelerationRate: CGFloat) -> CGPoint {
        return project(value: value, initialVelocity: initialVelocity, decelerationRate: CGPoint(x: decelerationRate, y: decelerationRate))
    }

    /// - parameter initialVelocity: in points/millisecond
    /// - parameter decelerationRate: rate of velocity dropping. See `UIScrollView.DecelerationRate`. Usually [0.99 - 0.998].
    /// - parameter precisionThreshold: Precision of projected value. Because mathematically deceleration will never stop.
    ///
    /// https://medium.com/@esskeetit/scrolling-mechanics-of-uiscrollview-142adee1142c
    public static func duration(initialVelocity: CGFloat, decelerationRate: CGFloat, precisionThreshold: CGFloat) -> TimeInterval {
        assert(decelerationRate < 1 && decelerationRate > 0)
        guard abs(initialVelocity) > 0 else {
            return 0
        }
        let dCoeff = 1000 * log(decelerationRate)
        return TimeInterval(log(-dCoeff * precisionThreshold / abs(initialVelocity)) / dCoeff)
    }

}
