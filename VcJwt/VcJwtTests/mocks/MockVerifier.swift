/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

@testable import VcJwt
import VcCrypto

class MockVerifier: TokenVerifying {
    
    func verify<T>(token: JwsToken<T>, usingPublicKey key: Secp256k1PublicKey) throws -> Bool {
        return true
    }
}