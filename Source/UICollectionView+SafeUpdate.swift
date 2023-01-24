//
//
//

import Foundation
import UIKit

extension UICollectionView {

    public func safePerformBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        if window != nil {
            performBatchUpdates(updates, completion: completion)
        } else {
            // collection view will crash on performBatchUpdates when window == nil
            reloadData()
        }
    }

}
