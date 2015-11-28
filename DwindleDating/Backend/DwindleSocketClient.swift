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

//Older server address
//52.89.24.195

public protocol DwindleSocketDelegate : NSObjectProtocol {
    func socketDidConnet(socket: SocketIOClient)
    func socketDidDisConnect()
}

class DwindleSocketClient {
   
    static let sharedInstance = DwindleSocketClient()
    
    private static let coki = NSHTTPCookie(properties: [NSHTTPCookieDomain:"52.89.24.195",
        NSHTTPCookiePath:"/",
        NSHTTPCookieName:"auth",
        NSHTTPCookieValue:"56cdea636acdf132"])!
    
    private let socket = SocketIOClient(socketURL: "52.89.24.195:3000",
        options: [
            SocketIOClientOption.Log(false),
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
        self.socket.connect()
        addHandlers()
    }
    
    func addHandlers() {
        // Our socket handlers go here
        self.socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
    }
    
    func sendEvent(eventName: String, data: [AnyObject], var ack:OnAckCallback) {
        
        let k=self.socket.emitWithAck(eventName, withItems: data)
        ack = k
        print(ack)
        
        
        if (delegate != nil) {
            // We will decide later what to do here.
        }
    }
    
    func EventHandler(isGamePlay: Bool, socket:(SocketIOClient)->Void) {
        
        isGamePlayerController = isGamePlay
        socket(self.socket)
    }
    
    
}
