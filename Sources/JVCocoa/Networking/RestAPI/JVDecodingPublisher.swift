//
//  Decoding Publisher.swift
//
//
//  Created by Jan Verrept on 13/04/2020.
//

import Foundation
import Combine

@available(OSX 10.15, *)
class DecodingPublisher{
    
    // Publisher to decode received Json-String to a model object (that conforms to decodable)
    class func Publisher<T: Decodable>(from request:URLRequest, using decoder:JSONDecoder = newJSONDecoder(), retryDelay:Int = 2, maxRetries:Int = 1) -> AnyPublisher<T, Error> {
        
        var retryCount = 0
        var decodingPublisher =  URLSession.shared.dataTaskPublisher(for: request).share()
            
        return decodingPublisher
            .catch { _ in
                return decodingPublisher.delay(for: .seconds(retryDelay), scheduler: DispatchQueue.main)
            } // Only in case of an error attach a delay to the publisher
            .retry(maxRetries)
            .tryMap{ data, response in print(response); return data}
            .decode(type: T.self, decoder: decoder)
            .subscribe(on: DispatchQueue.global())
            .eraseToAnyPublisher() // Make the publisher more generic, for use downstream
    }
}
