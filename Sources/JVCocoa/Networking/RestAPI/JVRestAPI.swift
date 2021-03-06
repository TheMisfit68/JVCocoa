//
//  JVRestAPI.swift
//
//
//  Created by Jan Verrept on 18/04/2020.
//

import Foundation
import Combine

@available(OSX 10.15, *)
public class RestAPI<E:StringRepresentableEnum, P:StringRepresentableEnum>{
    
    public enum RESTmethod:String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    public var baseURL:String
    public var endpointParameters:[E:[P]]
    public var baseParameters:[P:String]
    
    
    public init(baseURL:String, endpointParameters:[E:[P]], baseParameters:[P:String] = [:]){
        
        self.baseURL = baseURL
        self.endpointParameters = endpointParameters
        self.baseParameters = baseParameters
        
    }
    
    public func publish<T:Decodable>(method:RESTmethod = .GET,command:E, parameters:[P:String], maxRetries:Int = 2, retryDelay:Int = 2)->AnyPublisher<T?, Error>{
        
        var url:URL?
        var request:URLRequest! = nil
        let parameters = baseParameters.merging(parameters) {$1}
        let form = HTTPForm(parametersToInclude: endpointParameters[command] ?? [], currentParameters: parameters)
        
        print()
        print("🔃 Publishing \(baseURL)\(command.rawValue) [\(method.rawValue)]")
        print(form.description)
        print()
        
        switch method {
        case .GET:
            var urlComps = URLComponents(string: baseURL+command.stringValue)
            urlComps?.queryItems = form.urlQueryItems
            url = urlComps?.url
            request = URLRequest(url: url!)
        case .POST:
            url = URL(string:baseURL+command.stringValue)
            request = URLRequest(url: url!)
            request.allHTTPHeaderFields = ["Content-Type" : "application/x-www-form-urlencoded"]
            request.httpBody = form.composeBody(type: .FormEncoded)
            break
        default:
            print("⚠️ JVRestAPI: Unhandled REST-method")
        }
        request.httpMethod = method.rawValue
        request.timeoutInterval = 10
        return DecodingPublisher.Publisher(from: request, retryDelay:retryDelay, maxRetries: maxRetries)
        
    }
    
}

public struct HTTPForm<P:StringRepresentableEnum>{
      
    private var stringRepresentations:[(String, String)]
    private var parametersAndValues:[String]
    public var urlQueryItems:[URLQueryItem]
    
    public var description:String{
        parametersAndValues.joined(separator: "\n")
    }
    
    public enum HTTPbodyType{
        case Json
        case FormEncoded
    }
    
    public init(parametersToInclude:[P], currentParameters:[P:String]){
        
        let filteredParameters = currentParameters.filter   {(parameterName, parameterValue) in parametersToInclude.contains(parameterName)}
        
        self.stringRepresentations = filteredParameters.map  {(parameterName, parameterValue) in (parameterName.stringValue, Self.Encode(parameterValue))}
        self.parametersAndValues = stringRepresentations.map {parameterName, parameterValue in  "\(parameterName)=\(parameterValue)" }
        
        self.urlQueryItems = filteredParameters.map{ (parameterName, parameterValue) in URLQueryItem(name: parameterName.stringValue, value: parameterValue)}
    }
    
    public static func Encode(_ parameter:String)->String{

        var encodedParameter = parameter
        encodedParameter = encodedParameter.replacingOccurrences(of: ",", with: "%2C")
        encodedParameter = encodedParameter.replacingOccurrences(of: " ", with: "%20")
        encodedParameter = encodedParameter.replacingOccurrences(of: "/", with: "%2F")
        encodedParameter = encodedParameter.replacingOccurrences(of: "+", with: "%2B")
        encodedParameter = encodedParameter.replacingOccurrences(of: "=", with: "%3D")

        return encodedParameter
    }
    
    
    public func composeBody(type:HTTPbodyType = .Json)->Data?{
        
        switch type {
        case .Json:
            return try? JSONSerialization.data(withJSONObject: stringRepresentations, options: .prettyPrinted)
        case .FormEncoded:
            return parametersAndValues.joined(separator: "&").data(using: .utf8)
        }
        
    }
    
}



