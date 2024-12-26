//
// Copyright (c) 2018 Shakuro (https://shakuro.com/)
// Sergey Laschuk
//

import UIKit

@MainActor
internal protocol ExampleViewControllerProtocol {

    static func instantiate(example: Example) -> UIViewController

}
