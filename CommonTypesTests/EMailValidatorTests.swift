//
//
//

@testable import CommonTypes
import XCTest

class EMailValidatorTests: XCTestCase {

    func testEmails() {
        let validEmails = [
            "example@gmail.com",
            "@@gmail.com",
            "123@gmail.com",
            "exa@gmail1.com",
            "exa@gmail.com1",
            "exa@mple@gmail.com",
            "exa@mple@gmail.com",
            "exa@mp le@gmail.com",
            "dünn@vögel.cöm",
            "тест@мыло.рф",
            "_м@мыло.рф",
            "_m@mail.com",
            "example@gmail.co",
            "example@gmail.c.c.c.com",
            "Joe.Blow@example.com",
            "\"Abc@def\"@example.com",
            "customer/department=shipping@example.com",
            "$A12345@example.com",
            "$A12345@example.c",
            "!def!xyz%abc@example.com",

            "jsmith@[192.168.2.1]",
            "jsmith@[IPv6:2001:db8::1]",
            "john.smith@(comment)example.com",
            "john.smith@example.com(comment)",

            "simple@example.com",
            "very.common@example.com",
            "disposable.style.email.with+symbol@example.com",
            "other.email-with-hyphen@example.com",
            "fully-qualified-domain@example.com",
            "user.name+tag+sorting@example.com",
            "x@example.com",
            "example-indeed@strange-example.com",
            "test/test@test.com", // slashes are a printable character, and allowed
            "admin@mailserver1", // local domain name with no TLD, although ICANN highly discourages dotless email addresses
            "example@s.example", // see the List of Internet top-level domains
            "\" \"@example.org", // space between the quotes
            "\"john..doe\"@example.org", // quoted double dot
            "mailhost!username@example.org", // bangified host route used for uucp mailers
            "user%example.com@example.org", // % escaped mail route to user@example.com via example.org
            "user-@example.org"
        ]
        let invalidEmails = [
            "$A12345@example.",
            " example@gmail.com",
            "exa@mple@g mail.com",
            "exa@mple@gmail.com "
        ]

        let validEmailsIfTrim = [
            "   example@gmail.com ",
            " @@gmail.com ",
            "  123@gmail.com  ",
            "exa@gmail1.com ",
            "\n  exa@gmail.com1 \n "]

        continueAfterFailure = true

        let validator = EMailValidator()

        // Valid
        let notPassedEmails = validEmails.filter({ !validator.isValid(email: $0) })
        XCTAssert(notPassedEmails.isEmpty, "valid emails not passed validation: \(notPassedEmails)")

        let notPassedTrimmedEmails = validEmailsIfTrim.filter({ validator.validate(email: $0, shouldTrim: true) == nil })
        XCTAssert(notPassedTrimmedEmails.isEmpty, "valid emails not passed validation: \(notPassedTrimmedEmails)")

        // bad
        let passedEmails = invalidEmails.filter({ validator.isValid(email: $0) })
        XCTAssert(passedEmails.isEmpty, "invalid emails passed validation: \(passedEmails)")

        let passedNotTrimmedEmails = validEmailsIfTrim.filter({ validator.validate(email: $0, shouldTrim: false) != nil })
        XCTAssert(passedNotTrimmedEmails.isEmpty, "invalid emails passed validation: \(passedNotTrimmedEmails)")
    }

}
