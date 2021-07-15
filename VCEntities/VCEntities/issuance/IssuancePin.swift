/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCCrypto

enum IssuancePinError: Error {
    case unableToEncodeHashInput
}

public struct IssuancePin {
    
    let pin: String
    let salt: String?
    
    public init(from pin: String, withSalt salt: String? = nil) {
        self.pin = pin
        self.salt = salt
    }
    
    func hash() throws -> String {
        
        var hashInput: String
        if let nonnilSalt = salt {
            hashInput = pin + nonnilSalt
        } else {
            hashInput = pin
        }
        
        guard let encodedHashInput = hashInput.data(using: .utf8) else {
            throw IssuancePinError.unableToEncodeHashInput
        }
        
        return Sha256().hash(data: encodedHashInput).base64EncodedString()
    }
}

