//
//
//

import CommonCrypto
import CryptoKit
import Foundation

extension Data {

    public func SHA256String() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = self.withUnsafeBytes { (unsafeBytes: UnsafeRawBufferPointer) in
            CC_SHA256(unsafeBytes.baseAddress, CC_LONG(self.count), &digest)
        }
        let output: String = digest.reduce(into: "", { (result: inout String, byte) in
            result += String(format: "%02x", byte)
        })
        return output
    }

    public func SHA256Data() -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = self.withUnsafeBytes { (unsafeBytes: UnsafeRawBufferPointer) in
            CC_SHA256(unsafeBytes.baseAddress, CC_LONG(self.count), &digest)
        }
        let output: Data = Data(digest)
        return output
    }

    public func SHA512() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        _ = self.withUnsafeBytes { (unsafeBytes: UnsafeRawBufferPointer) in
            CC_SHA512(unsafeBytes.baseAddress, CC_LONG(self.count), &digest)
        }
        let output: String = digest.reduce(into: "", { (result: inout String, byte) in
            result += String(format: "%02x", byte)
        })
        return output
    }

    public func MD5() -> String {
        let digestData = Insecure.MD5.hash(data: self)
        return String(digestData.map { String(format: "%02x", $0) }.joined().prefix(32))
    }

}
