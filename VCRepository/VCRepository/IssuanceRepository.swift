/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcNetworking

public struct IssuanceRepository: RepositoryProtocol {
    public typealias FetchOperation = FetchContractOperation
    public typealias PostOperation = PostIssuanceResponseOperation
    
    public let networkOperationFactory: NetworkOperationFactoryProtocol = NetworkOperationFactory()
    
    public init() {}
}
