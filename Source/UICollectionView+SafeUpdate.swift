//
//
//

import Foundation
import UIKit

extension UICollectionView {

    public func safePerformBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        if window != nil {
            performBatchUpdates(updates, completion: completion)
        } else {
            // collection view will crash on performBatchUpdates when window == nil
            reloadData()
            completion?(true)
        }
    }

}
