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
    class func Publisher<T: Decodable>(from request:URLRequest, using decoder:JSONDecoder = newJSONDecoder(), retryDelay:UInt32 = 2, maxRetries:Int = 2) -> AnyPublisher<T, Error> {
        
        let intitialPublisher =  URLSession.shared.dataTaskPublisher(for: request).share()
        return intitialPublisher
            .catch {_ in intitialPublisher.delay(for: 3, scheduler: DispatchQueue.main)}
            .retry(maxRetries)
            .tryMap{ data, response in print(data.description); print(response);return data}
            .decode(type: T.self, decoder: decoder)
            .subscribe(on: DispatchQueue.global())
            .eraseToAnyPublisher() // Make the publisher more generic, for use downstream
    }
}

