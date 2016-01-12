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

enum HandlerType:Int {
    case Menu
    case Play
    case MatchChat
}

let PushNotification = "PushNotification"

class DwindleSocketClient {
   
    static let sharedInstance = DwindleSocketClient()
    
    private static let coki = NSHTTPCookie(properties: [NSHTTPCookieDomain:"159.203.245.103",
        NSHTTPCookiePath:"/",
        NSHTTPCookieName:"auth",
        NSHTTPCookieValue:"56cdea636acdf132"])!
    
    private let socket = SocketIOClient(socketURL: "159.203.245.103:3000",
        options: [
            SocketIOClientOption.Log(false),
            SocketIOClientOption.ForcePolling(true),
            SocketIOClientOption.Reconnects(true),
            SocketIOClientOption.VoipEnabled(true),
            SocketIOClientOption.ReconnectAttempts(1000),
            SocketIOClientOption.Cookies([coki])
        ]
    )
    
    private(set) var isMenuControllerHandlerAdded = false
    private(set) var isGamePlayerControllerHandlerAdded = false
    private(set) var isMatchChatControllerHandlerAdded = false
    
    weak private var delegate: DwindleSocketDelegate?
    
    init() {
        self.socket.connect()
        addHandlers()
    }
    
    func addHandlers() {
        // Our socket handlers go here
        self.socket.onAny {
            
            print("Got event: \($0.event), with items: \($0.items)")
            
            if $0.event == "connect" {
                
                let settings = UserSettings.loadUserSettings()
                self.socket.emit("connect with socket", withItems: [settings.fbId])
                
                NSNotificationCenter.defaultCenter().postNotificationName(PushNotification, object: nil)
            }
            if $0.event == "Disconnect" {
                
                if UserSettings.loadUserSettings() != nil {
                    self.socket.connect()
                }
            }
        }
    }
    
    func sendEvent(eventName: String, data: [AnyObject]) {
        
        if self.socket.status == .Connected {
            self.socket.emit(eventName, withItems: data)
        }
        else {
            print("failed to send client event: \(eventName)")
        }
    }
    
    func EventHandler(type: HandlerType, socket:(SocketIOClient)->Void) {
        
        if type == HandlerType.Menu {
            isMenuControllerHandlerAdded = true
        }
        else if type == HandlerType.Play {
            isGamePlayerControllerHandlerAdded = true
        }
        else if type == HandlerType.MatchChat {
            isMatchChatControllerHandlerAdded = true
        }
        socket(self.socket)
    }
    
    func EventHandlerForMatches(socket:(SocketIOClient)->Void) {
        socket(self.socket)
    }
    
    func status()->SocketIOClientStatus {
        return socket.status
    }
    
    func disconnect() {
        self.socket.disconnect()
    }
    
    func reconnect() {
        
        if self.socket.status == .NotConnected || self.socket.status == .Closed {
            self.socket.reconnect()   
        }
    }
}
