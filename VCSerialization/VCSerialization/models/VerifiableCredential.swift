/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation


struct VerifiableCredential {
    let raw: Data
    let claims: VcClaims
    let token: JwsToken
}