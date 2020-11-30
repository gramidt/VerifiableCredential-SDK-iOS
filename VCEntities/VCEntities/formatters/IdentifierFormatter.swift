/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import VCJwt

protocol IdentifierFormatting {
    func createIonLongFormDid(recoveryKey: ECPublicJwk,
                           updateKey: ECPublicJwk,
                           didDocumentKeys: [ECPublicJwk],
                           serviceEndpoints: [IdentifierDocumentServiceEndpoint]) throws -> String
}

struct IdentifierFormatter: IdentifierFormatting {
    
    private let multihash: Multihash = Multihash()
    private let encoder: JSONEncoder = JSONEncoder()
    
    private static let ionPrefix = "did:ion:"
    private static let ionQueryValue = "?-ion-initial-state="
    private static let replaceAction = "replace"
    
    func createIonLongFormDid(recoveryKey: ECPublicJwk,
                           updateKey: ECPublicJwk,
                           didDocumentKeys: [ECPublicJwk],
                           serviceEndpoints: [IdentifierDocumentServiceEndpoint]) throws -> String {
        
        let document = IdentifierDocument(fromJwks: didDocumentKeys, andServiceEndpoints: serviceEndpoints)
        
        let patches = [IdentifierDocumentPatch(action: IdentifierFormatter.replaceAction, document: document)]
        
        let commitmentHash = try self.createCommitmentHash(usingJwk: updateKey)
        let delta = IdentifierDocumentDeltaDescriptor(updateCommitment: commitmentHash, patches: patches)
        
        let suffixData = try self.createSuffixData(usingDelta: delta, recoveryKey: recoveryKey)

        return try self.createLongFormIdentifier(usingDelta: delta, andSuffixData: suffixData)
    }
    
    private func createLongFormIdentifier(usingDelta delta: IdentifierDocumentDeltaDescriptor, andSuffixData suffixData: SuffixDescriptor) throws -> String {
        
        let encodedDelta = try encoder.encode(delta).base64URLEncodedString()
        let encodedSuffixData = try encoder.encode(suffixData).base64URLEncodedString()
        let encodedPayload = encodedSuffixData + "." + encodedDelta
        
        let shortForm = try self.createShortFormIdentifier(usingSuffixData: suffixData)
        
        return shortForm + IdentifierFormatter.ionQueryValue + encodedPayload
    }
    
    private func createShortFormIdentifier(usingSuffixData data: SuffixDescriptor) throws -> String {
        
        let encodedData = try encoder.encode(data)
        let hashedSuffixData = multihash.compute(from: encodedData).base64URLEncodedString()
        
        return IdentifierFormatter.ionPrefix + hashedSuffixData
    }
    
    private func createSuffixData(usingDelta delta: IdentifierDocumentDeltaDescriptor, recoveryKey: ECPublicJwk) throws -> SuffixDescriptor {
        let encodedDelta = try encoder.encode(delta)
        let patchDescriptorHash = multihash.compute(from: encodedDelta).base64URLEncodedString()
        let recoveryCommitmentHash = try self.createCommitmentHash(usingJwk: recoveryKey)
        return SuffixDescriptor(patchDescriptorHash: patchDescriptorHash, recoveryCommitmentHash: recoveryCommitmentHash)
    }
    
    private func createCommitmentHash(usingJwk jwk: ECPublicJwk) throws  -> String {
        let canonicalizedPublicKey = try encoder.encode(jwk)
        return multihash.compute(from: canonicalizedPublicKey).base64URLEncodedString()
    }
}