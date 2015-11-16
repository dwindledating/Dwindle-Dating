//
//  DwindleSocketClient.swift
//  DwindleDating
//
//  Created by Muhammad Rashid on 15/11/2015.
//  Copyright © 2015 infinione. All rights reserved.
//

import UIKit


/*
Main functions of this class will be

1. Universal Class For Game Play controller and MatchChat controller
2. Single Sign in
3. Separate in house methods for GamePlay and MatchChat controller.
4. Two different Delegates
5.

*/

public protocol DwindleSocketDelegate : NSObjectProtocol {
    func socketDidConnet(socket: SocketIOClient)
    func socketDidDisConnect()
}

class DwindleSocketClient {
   
    private static let coki = NSHTTPCookie(properties: [NSHTTPCookieDomain:"159.203.245.103",
        NSHTTPCookiePath:"/",
        NSHTTPCookieName:"auth",
        NSHTTPCookieValue:"56cdea636acdf132"])!
    
    private let socket = SocketIOClient(socketURL: "159.203.245.103:3000",
        options: [
            SocketIOClientOption.Log(true),
            SocketIOClientOption.ForcePolling(true),
            SocketIOClientOption.Reconnects(true),
            SocketIOClientOption.VoipEnabled(true),
            SocketIOClientOption.ReconnectAttempts(1000),
            SocketIOClientOption.Cookies([coki])
        ]
    )
    
    private var isGamePlayerController = false
    
    weak private var delegate: DwindleSocketDelegate?

    
    init() {
        
        addHandlers()
        self.socket.connect()
    }
 
    func addHandlers() {
        // Our socket handlers go here
        
        self.socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
    }
    
    func sendEvent(eventName: String, data: AnyObject) {
        let ack:OnAckCallback = self.socket.emitWithAck(eventName, data)
        print(ack)
        
        if (delegate != nil) {
            
        }
    }
    
    func EventHandler(isGamePlay: Bool) -> SocketIOClient {
        
        isGamePlayerController = isGamePlay
        
        return self.socket
    }
    
    
}
