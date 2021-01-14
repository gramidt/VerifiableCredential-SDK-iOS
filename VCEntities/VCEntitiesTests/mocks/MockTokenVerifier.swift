/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt
import VCCrypto

@testable import VCEntities

struct MockTokenVerifier: TokenVerifying {
    
    let isTokenValid: Bool
    
    static var wasVerifyCalled = false
    
    init(isTokenValid: Bool) {
        self.isTokenValid = isTokenValid
    }
    
    func verify<T>(token: JwsToken<T>, usingPublicKey key: ECPublicJwk) throws -> Bool {
        MockTokenVerifier.wasVerifyCalled = true
        return isTokenValid
    }

}
