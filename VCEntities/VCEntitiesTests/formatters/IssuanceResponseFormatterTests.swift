/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import XCTest

@testable import VCEntities

class IssuanceResponseFormatterTests: XCTestCase {
    
    var formatter: IssuanceResponseFormatter!
    var contract: Contract!
    var mockResponse: IssuanceResponseContainer!
    var mockIdentifier: MockIdentifier!
    let expectedContractUrl = "https://portableidentitycards.azure-api.net/v1.0/9c59be8b-bd18-45d9-b9d9-082bc07c094f/portableIdentities/contracts/AIEngineerCert"
    
    override func setUpWithError() throws {
        let signer = MockTokenSigner(x: "x", y: "y")
        self.formatter = IssuanceResponseFormatter(signer: signer)
        
        let encodedContract = TestData.aiContract.rawValue.data(using: .utf8)!
        self.contract = try JSONDecoder().decode(Contract.self, from: encodedContract)
        
        try self.mockResponse = IssuanceResponseContainer(from: self.contract, contractUri: self.expectedContractUrl)
        
        self.mockIdentifier = MockIdentifier()
    }
    
    func testFormatToken() throws {
        let formattedToken = try formatter.format(response: self.mockResponse, usingIdentifier: self.mockIdentifier)
        XCTAssertEqual(formattedToken.content.did, self.mockIdentifier.id)
        XCTAssertEqual(formattedToken.content.contract, self.mockResponse.contractUri)
        XCTAssertEqual(formattedToken.content.audience, self.mockResponse.audience)
        XCTAssert(MockTokenSigner.wasSignCalled)
        XCTAssert(MockTokenSigner.wasGetPublicJwkCalled)
    }
    
}