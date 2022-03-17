//
//  ViewController.swift
//  socketIOProjectTest
//
//  Created by James Lea on 3/16/22.
//

import UIKit

class ViewController: UIViewController {
    
    var mSocket = SocketHandler.sharedInstance.getSocket()
    
    
    
    //Outlets
    @IBOutlet weak var countLabel: UILabel!
    
    //Actions
    @IBAction func counterButtonPressed(_ sender: Any) {
        
        mSocket.emit("counter")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketHandler.sharedInstance.establishConnection()
        mSocket.on("counter") { ( dataArray, ack) -> Void in
            let dataReceived = dataArray[0] as! Int
            
            self.countLabel.text = "\(dataReceived)"
        }
    }


}

