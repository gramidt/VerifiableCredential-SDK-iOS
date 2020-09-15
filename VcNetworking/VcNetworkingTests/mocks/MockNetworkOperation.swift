/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import Foundation
@testable import VcNetworking

final class MockNetworkOperation: NetworkOperation {
    typealias ResponseBody = MockDecoder.ResponseBody
    typealias Decoder = MockDecoder
    
    let decoder: MockDecoder = MockDecoder()
    let successHandler: SuccessHandler = SimpleSuccessHandler()
    let failureHandler: FailureHandler = SimpleFailureHandler()
    let retryHandler: RetryHandler = NoRetry()
    let urlSession: URLSession
    let urlRequest: URLRequest
    
    let mockUrl = "mockurl.com"
    
    init () {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolMock.self]
        self.urlSession = URLSession.init(configuration: configuration)
        self.urlRequest = URLRequest(url: URL(string: mockUrl)!)
    }
}