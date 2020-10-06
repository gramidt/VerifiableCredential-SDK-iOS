/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VCJwt

func createTokenTimeConstraints(expiryInSeconds: Int) -> TokenTimeConstraints {
    let iat = (Date().timeIntervalSince1970).rounded(.down)
    let exp = iat + Double(expiryInSeconds)
    return TokenTimeConstraints(issuedAt: iat, expiration: exp)
}

func formatHeaders(usingIdentifier identifier: MockIdentifier) -> Header {
    let keyId = identifier.id + identifier.keyReference
    return Header(type: "JWT", algorithm: identifier.algorithm, keyId: keyId)
}
