/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
import VcNetworking
import VcJwt
import PromiseKit

enum RepositoryError: Error {
    case unsupportedNetworkOperation
}

protocol RepositoryProtocol {
    associatedtype FetchOperation: NetworkOperation
    associatedtype PostOperation: PostNetworkOperation
    
    var networkOperationFactory: NetworkOperationFactoryProtocol { get }
    
    func getRequest(withUrl url: String)-> Promise<FetchOperation.ResponseBody>
    
    func sendResponse(withUrl url: String, withBody body: PostOperation.RequestBody) -> Promise<PostOperation.ResponseBody>
}

extension RepositoryProtocol {
    
    func getRequest(withUrl url: String) -> Promise<FetchOperation.ResponseBody> {
        return networkOperationFactory.createFetchOperation(FetchOperation.self, withUrl: url).then { operation in
            operation.fire()
        }
    }
    
    func sendResponse(withUrl url: String, withBody body: PostOperation.RequestBody) -> Promise<PostOperation.ResponseBody> {
        return networkOperationFactory.createPostOperation(PostOperation.self, withUrl: url, withRequestBody: body).then { operation in
            operation.fire()
        }
    }
}
