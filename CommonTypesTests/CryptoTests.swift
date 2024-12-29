//
//
//

@testable import CommonTypes
import XCTest

class CryptoTests: XCTestCase {

    func testMD5() {
        let value = "test string 12345"
        XCTAssertEqual(value.MD5(), "6987ca32fd849a6119384e810c0c87ea")
    }

}
