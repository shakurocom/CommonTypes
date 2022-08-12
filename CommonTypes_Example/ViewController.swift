//
//  Copyright (c) 2018 Shakuro (https://shakuro.com/)
//

import UIKit
import CommonTypes

class ViewController: UIViewController {

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var validationResultLabel: UILabel!

    private let emailValidator = EMailValidator()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let test = [1, 2, 3, 4, 5, 6] // TODO: do something usefull
        print(test.chunked(chunkSize: 2).debugDescription)

        validationResultLabel.text = ""
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    // MARK: - Interface callbacks

    @IBAction private func checkButtonTapped() {
        guard let email = emailTextField.text else {
            validationResultLabel.text = ""
            return
        }
        if let validEmail = emailValidator.validate(email: email, shouldTrim: true) {
            validationResultLabel.textColor = UIColor.green
            validationResultLabel.text = "\(validEmail) - valid"
        } else {
            validationResultLabel.textColor = UIColor.red
            validationResultLabel.text = "\(email) - invalid"
        }
    }
}
