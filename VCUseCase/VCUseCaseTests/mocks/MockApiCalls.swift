/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking
import PromiseKit
import VCRepository

@testable import VCUseCase

enum MockIssuanceRepoError: Error {
    case doNotWantToResolveRealObject
}

class MockApiCalls: ApiCalling {
    let networkOperationFactory: NetworkOperationCreating
    
    init(factory: NetworkOperationCreating = NetworkOperationFactory()) {
        self.networkOperationFactory = factory
    }
    
    
    static var wasGetCalled: Bool = false
    static var wasPostCalled: Bool = false
    
    func get<FetchOp>(_ type: FetchOp.Type, usingUrl url: String) -> Promise<FetchOp.ResponseBody> where FetchOp : NetworkOperation {
        Self.wasGetCalled = true
        return Promise { seal in
            seal.reject(MockIssuanceRepoError.doNotWantToResolveRealObject)
        }
    }
    
    func post<PostOp: PostNetworkOperation>(_ type: PostOp.Type, usingUrl url: String, withBody body: PostOp.RequestBody) -> Promise<PostOp.ResponseBody> {
        Self.wasPostCalled = true
        return Promise { seal in
            seal.reject(MockIssuanceRepoError.doNotWantToResolveRealObject)
        }
    }
}
