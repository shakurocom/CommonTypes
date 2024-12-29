//
//
//

@testable import CommonTypes
import XCTest

class ColorTests: XCTestCase {

    func testHEX() {
        let color = UIColor(hex: "#FFBC67")
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssertEqual(red, 1)
        XCTAssertEqual(Int(green * 1000), 737)
        XCTAssertEqual(Int(blue * 1000), 403)
        XCTAssertEqual(alpha, 1)
    }

}
