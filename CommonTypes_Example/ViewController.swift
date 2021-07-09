//
//  Copyright (c) 2018 Shakuro (https://shakuro.com/)
//

import UIKit
import CommonTypes

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let test = [1,2,3,4,5,6]
        print(test.chunked(chunkSize: 2).debugDescription)
    }

}
