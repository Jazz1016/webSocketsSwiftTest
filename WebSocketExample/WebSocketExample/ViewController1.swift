//
//  ViewController1.swift
//  WebSocketExample
//
//  Created by James Lea on 3/16/22.
//

import UIKit
import SocketIO

class ViewController1: UIViewController {
    
    let manager = SocketManager(socketURL: URL(string: "208.67.222.222#53/localhost:3001")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    var name: String?
    var resetAck: SocketAckEmitter?

    override func viewDidLoad() {
        super.viewDidLoad()
        socket = manager.defaultSocket
        
        socket.connect()
    }

    
}
