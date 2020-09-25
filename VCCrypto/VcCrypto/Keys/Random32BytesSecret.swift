/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation

public class Random32BytesSecret: Secret {
    static var itemTypeCode: String = "r32B"
    public var id: UUID
    private let store: SecretStoring
    
    public init?(withStore store: SecretStoring) {
        self.store = store
        
        var value = Data(count: 32)
        defer {
            let secretSize = value.count
            value.withUnsafeMutableBytes { (secretPtr) in
                memset_s(secretPtr.baseAddress, secretSize, 0, secretSize)
                return
            }
        }
        
        let result = value.withUnsafeMutableBytes { (secretPtr) in
            SecRandomCopyBytes(kSecRandomDefault, secretPtr.count, secretPtr.baseAddress!)
        }
        
        guard result == errSecSuccess else { return nil }
        id = UUID()
        
        // Hard coded until Identifier creation is implemented (security bug 1152963)
        let secretStr = "rbe1f0bbMoDXB6YXwxxAA_nSPpv6LbBJIuKtr4Bjq_c"
        var secret = Data(base64URLEncoded: secretStr)!
        
        do {
            try self.store.saveSecret(id: id, itemTypeCode: Random32BytesSecret.itemTypeCode, value: &secret)
            // try self.store.saveSecret(id: id, itemTypeCode: Random32BytesSecret.itemTypeCode, value: &secret)
        } catch {
            return nil
        }
    }
    
    func withUnsafeBytes(_ body: (UnsafeRawBufferPointer) throws -> Void) throws {
        var value = try self.store.getSecret(id: id, itemTypeCode: Random32BytesSecret.itemTypeCode)
        defer {
            let secretSize = value.count
            value.withUnsafeMutableBytes { (secretPtr) in
                memset_s(secretPtr.baseAddress, secretSize, 0, secretSize)
                return
            }
        }
        
        try value.withUnsafeBytes { (valuePtr) in
            try body(valuePtr)
        }
    }
}
