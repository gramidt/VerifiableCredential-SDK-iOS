/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

/// Error buckets for what went wrong with issuance.
public enum IssuanceCompletionErrorDetails: String {
    case userCanceled = "user_canceled"
    case fetchContractError = "fetch_contract_error"
    case linkedDomainError = "linked_domain_error"
    case picsError = "pics_error"
    case issuanceError = "issuance_error"
}

/// The data object that the Client will send back after a successful issuance.
public struct IssuanceCompletionResponse: Codable, Equatable {
    
    struct IssuanceCompletionMessage {
        static let IssuanceSuccessful = "issuance_successful"
        static let IssuanceFailed = "issuance_failed"
    }
    
    /// If the issuance  succeeded or failed.
    public let message: String
    
    /// The state from the original request
    public let state: String
    
    /// Any details to be included in the response.
    public let details: String?
    
    public init(wasSuccessful: Bool,
                withState state: String,
                andDetails details: IssuanceCompletionErrorDetails? = nil) {
        
        if wasSuccessful {
            self.message = IssuanceCompletionMessage.IssuanceSuccessful
        } else {
            self.message = IssuanceCompletionMessage.IssuanceFailed
        }
        
        self.state = state
        self.details = details?.rawValue
    }
    
}
