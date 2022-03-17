//
//  ViewController.swift
//  WebSocketExample
//
//  Created by James Lea on 3/14/22.
//

import UIKit

class ViewController: UIViewController, URLSessionWebSocketDelegate {
    
    private var webSocket: URLSessionWebSocketTask?
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: OperationQueue())
        let url = URL(string: "localhost:3000")
        let webSocket = session.webSocketTask(with: url!)
        webSocket.resume()
        closeButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.center = view.center
    }

    func ping() {
        webSocket?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("Ping error: \(error)")
            }
        })
    }
    @objc func close() {
        webSocket?.cancel(with: .goingAway, reason: "data".data(using: .utf8))
    }
    func send() {
        
        DispatchQueue.global().asyncAfter(deadline: .now()+1) {
            self.send()
            self.webSocket?.send(.string("Send new message \(Int.random(in: 0...1000))"), completionHandler: { error in
                print("hit send")
                if let error = error {
                    print("send error: \(error)")
                }
            })
        }
    }
    func receive() {
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("got data: \(data)")
                case .string(let string):
                    print("got string \(string)")
                @unknown default:
                    break
                }
            
            case .failure(let error):
                print("Receive error \(error)")
            }
            self?.receive()
        })
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("did connect to socket")
        ping()
        receive()
        send()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("did close connect with reason")
    }
}

