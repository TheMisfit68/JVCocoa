//
//  JVWebSocket.swift
//
//
//  Created by Jan Verrept on 28/02/2020.
//
import Foundation

@available(OSX 10.15, *)
public protocol WebSocketDelegate{
    func connected()
    func disconnected(error: Error?)
    func received(text: String)
    func received(data: Data)
    func received(error: Error)
}

@available(OSX 10.15, *)
public class WebSocket:NSObject, URLSessionWebSocketDelegate {
    
    var urlSession:URLSession!
    var webSocketTask:URLSessionWebSocketTask!
    var delegate:WebSocketDelegate?
    
    public init(urlRequest:URLRequest, delegate:WebSocketDelegate?){
        super.init()
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = urlSession.webSocketTask(with:urlRequest)
        self.delegate = delegate
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.delegate?.connected()
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.delegate?.disconnected(error:nil)
    }
    
    public func connect() {
        webSocketTask.resume()
        listen()
    }
    
    public func disconnect() {
        webSocketTask.cancel(with: .normalClosure, reason: nil)
    }
    
    
    public func send(text: String) {
        let message:URLSessionWebSocketTask.Message = .string(text)
        webSocketTask.send(message) { error in
            if let error = error {
                self.delegate?.received(error: error)
            }
        }
    }
    
    public func send(data: Data) {
        let message:URLSessionWebSocketTask.Message = .data(data)
        webSocketTask.send(message) { error in
            if let error = error {
                self.delegate?.received(error: error)
            }
        }
    }
    
    //TODO: - Implement Ping and Pong methods
    
    private func listen()  {
        
        webSocketTask.receive { result in
            switch result {
                
            case .success(let message):
                
                switch message {
                case .string(let text):
                    self.delegate?.received(text: text)
                case .data(let data):
                    self.delegate?.received(data: data)
                @unknown default:
                    break
                }
                
            case .failure(let error):
                self.delegate?.received(error: error)
                
            }
        }
    }
    
}
