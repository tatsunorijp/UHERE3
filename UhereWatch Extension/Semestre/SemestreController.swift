//
//  InterfaceController.swift
//  UhereWatch Extension
//
//  Created by Wellington Tatsunori Asahide on 09/05/19.
//  Copyright © 2019 tatsu. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class SemestreController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet weak var table: WKInterfaceTable!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var replyValues = Dictionary<String, AnyObject>()
        let loadedData = message["test"]
    }
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        WCSession.default
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
