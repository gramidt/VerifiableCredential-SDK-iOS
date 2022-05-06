/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCToken

public protocol IssuanceRequestValidating {
    func validate(request: SignedContract, usingKeys publicKeys: [IdentifierDocumentPublicKey]) throws
}

public struct IssuanceRequestValidator: IssuanceRequestValidating {
    
    private let verifier: TokenVerifying
    
    public init(verifier: TokenVerifying = Secp256k1Verifier()) {
        self.verifier = verifier
    }
    
    public func validate(request: SignedContract, usingKeys publicKeys: [IdentifierDocumentPublicKey]) throws {
        
        guard let kid = request.headers.keyId else
        {
            throw PresentationRequestValidatorError.noKeyIdInTokenHeader
        }
        
        let keyIdComponents = kid.split(separator: "#").map { String($0) }
        let publicKeyId = "#\(keyIdComponents[1])"
        
        /// check if key id is equal to keyId fragment in token header, and if so, validate signature. Else, continue loop.
        for key in publicKeys {
            if key.id == publicKeyId,
               try request.verify(using: verifier, withPublicKey: key.publicKeyJwk) {
                return
            }
        }
        
        throw PresentationRequestValidatorError.invalidSignature
    }
    
}
