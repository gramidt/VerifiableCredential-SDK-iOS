/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcJwt
import VcNetworking
import PromiseKit
import VCRepository

@testable import VCUseCase

enum TestError: Error {
    case doNotWantToResolveRealObject
}

class MockIssuanceResponseFormatter: IssuanceResponseFormatter {
    
    static var wasFormatCalled = false
    
    init() {
        print("hello")
    }
    
    override func format(response: MockIssuanceResponse, usingIdentifier identifier: MockIdentifier) -> JwsToken<IssuanceResponseClaims> {
            Self.wasFormatCalled = true
            return JwsToken<IssuanceResponseClaims>(headers: Header(), content: IssuanceResponseClaims(), signature: Data(count: 64))
    }
    
}
