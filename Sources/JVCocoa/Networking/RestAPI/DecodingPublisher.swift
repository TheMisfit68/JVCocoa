//
//  Decoding Publisher.swift
//  
//
//  Created by Jan Verrept on 13/04/2020.
//

//TODO: - Add this Class to JVCocoa

import Foundation
import Combine

@available(OSX 10.15, *)
class DecodingPublisher{
    
    // Publisher to decode received Json-String to a model object (that conforms to decodable)
    class func Publisher<T: Decodable>(from request:URLRequest, using decoder:JSONDecoder = JSONDecoder(), maxRetries:Int = 2, retryDelay:UInt32 = 2) -> AnyPublisher<T, Error> {
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .retry(maxRetries)
            .map { data, _ in data}
            .decode(type: T.self, decoder: decoder)
            .retry(maxRetries)
            .subscribe(on: DispatchQueue.global())
            .eraseToAnyPublisher() // Make more generic
    }
    
}
