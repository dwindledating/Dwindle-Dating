//
//  GamePlayController.swift
//  DwindleDating
//
//  Created by Yunas Qazi on 1/27/15.
//  Copyright (c) 2015 infinione. All rights reserved.
//

//TODO:
//Add a boolean isOpponentFound
//Run a timer for 15 secs
//On player found set flag isOpponentFound to true
//Timer will call a method and check the value of flag 
//if its true then ignore else show an alert and call back button pressed 


import UIKit
//import corelocation

//, KDCycleBannerViewDelegate
class GamePlayController: JSQMessagesViewController,
UIActionSheetDelegate,
KDCycleBannerViewDataource,
KDCycleBannerViewDelegate
{

    @IBOutlet var scroller : KDCycleBannerView!
    
    @IBOutlet weak var btn1: RoundButtonView!
    @IBOutlet weak var btn2: RoundButtonView!
    @IBOutlet weak var btn3: RoundButtonView!
    @IBOutlet weak var btn4: RoundButtonView!
    @IBOutlet weak var btn5: RoundButtonView!
    
    var isComingFromOtherScreen = false
    var gameInProgress = false
    
    var playersDict:[String:AnyObject]! = [:]
    
    var playerMain : Player!
    var playerOpponent: Player!
    var playerOther1 : Player!
    var playerOther2 : Player!
    var playerOther3 : Player!
    var playerOther4 : Player!
    var isPlayerFound : Bool?
    
    var randomPlayers:[String]! = []
    
    var pagination_user_count: Int = 0
    
    var dwindleSocket:DwindleSocketClient!
    
    @IBOutlet weak var galleryHeightConstraint : NSLayoutConstraint?
    
    @IBOutlet var imagesViewContainer : UIView!
    
    var galleryOpenerButton : RoundButtonView?
    var demoData: DemoModelData!
    
    func handleLeaveGame() {
        
        if self.viewLoaded == true {
            
            let popup = Popup.init(title: "",
                subTitle: "The other user has left the game. Do you want to connect with other users?",
                cancelTitle: "Main Menu",
                successTitle: "New Game",
                cancelBlock: { () -> Void in // go back to main menu
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.popController()
                    })
                    
                }, successBlock: { () -> Void in // Send play event again
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.resetGameViews()
                        self.initSocketConnection()
                        
                    })
            })
            
            self.view.endEditing(true)
            popup.incomingTransition = PopupIncomingTransitionType.BounceFromCenter
            popup.outgoingTransition = PopupOutgoingTransitionType.BounceFromCenter
            popup.showPopup()
        }
    }
    
    func handleNoMatchFound() {

        self.onlineUserTimer?.invalidate()
        self.onlineUserTimer = nil
        
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            if (self.isPlayerFound == false) {
                
                if self.viewLoaded {
                    
                    let popup = Popup.init(title: "",
                        subTitle: "Hmmm, we couldn’t find any matches right now. You can adjust your preferences or try again.",
                        cancelTitle: "Main Menu",
                        successTitle: "Try Again",
                        cancelBlock: { () -> Void in // go back to main menu
                            
                            self.popController()
                            
                        }, successBlock: { () -> Void in // Send play event again
                            
                            self.resetGameViews()
                            self.initSocketConnection()
                    })
                    
                    self.view.endEditing(true)
                    popup.incomingTransition = PopupIncomingTransitionType.BounceFromCenter
                    popup.outgoingTransition = PopupOutgoingTransitionType.BounceFromCenter
                    popup.showPopup()
                }
            }
        }
    }
    
    func showAlertWithDelay(skip: Bool) {
        
        if self.viewLoaded == true {
            
            var message = "This will end your current game, are you sure?"
            var titleYes = "Yes"
            var titleNo = "No"
            if skip {
                message = "Are you sure you want to bail on this date?"
            }
            else if self.gameInProgress {
                message = "Press Main Menu to keep this date in Play. Press quit to end chat."
                titleNo = "Main Menu"
                titleYes = "Quit"
            }
            else {
                titleYes = "Quit"
            }
            
            let popup = Popup.init(title: "",
                subTitle: message,
                cancelTitle: titleNo,
                successTitle: titleYes,
                cancelBlock: { () -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if self.gameInProgress == true {
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                    
                }, successBlock: { () -> Void in
                    
                    if skip {
                        self.dwindleSocket.sendEvent("skip", data: [])
                    }
                    else {
                        let settings = UserSettings.loadUserSettings()
                        self.dwindleSocket.sendEvent("leaveGame", data: [settings.fbId])
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.popController()
                    })
            })
            
            self.view.endEditing(true)
            popup.incomingTransition = PopupIncomingTransitionType.BounceFromCenter
            popup.outgoingTransition = PopupOutgoingTransitionType.BounceFromCenter
            popup.showPopup()
        }
        
//        let yesAction = UIAlertAction(title: titleYes, style: .Default) { (action) -> Void in
//
//            if skip {
//                self.dwindleSocket.sendEvent("skip", data: [])
//            }
//            else {
//                let settings = UserSettings.loadUserSettings()
//                self.dwindleSocket.sendEvent("leaveGame", data: [settings.fbId])
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.dismissViewControllerAnimated(false, completion: nil)
//                self.popController()
//            })
//        }
//        let noAction = UIAlertAction(title: titleNo, style: .Cancel) { (action) -> Void in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.dismissViewControllerAnimated(false, completion: nil)
//                if self.gameInProgress == true {
//                    self.navigationController?.popViewControllerAnimated(true)
//                }
//            })
//        }
//        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
//        alert.addAction(yesAction)
//        alert.addAction(noAction)
//        self.presentViewController(alert)
    }
    
    func showBackAlertFromSkip(skip: Bool) {
        
        self.hideKeyboard()
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.showAlertWithDelay(skip)
        }
    }
    
    override func navigationShouldPopOnBackButton() -> Bool {
        //ASK AGAIN IF USER WANTS TO QUIT THE GAME
        // IF YES THEN pop it
        self.showBackAlertFromSkip(false)
        return false
    }
    
    func skipPressed(sender: UIBarButtonItem) {
        self.showBackAlertFromSkip(true)
    }
    
    // MARK:- KDCycleBannerView DataSource
    func numberOfKDCycleBannerView(bannerView: KDCycleBannerView!) -> [AnyObject]! {
       
        var imagesList:AnyObject = []
        var selectedPlayer: Player?
        
        if let tmpOpener = galleryOpenerButton {
            selectedPlayer = self.getPlayerAgainstId(tmpOpener.playerId)
        }
        
        if let tmpSelectedPlayer = selectedPlayer {
            imagesList = (tmpSelectedPlayer.galleryImages as NSArray as? [NSURL])!
        }
        else{
            // is nil
            imagesList   = [UIImage(named:"NoImageFound.jpg")!]
        }
        return imagesList as! [AnyObject]
    }
    
    func placeHolderImageOfZeroBannerView() -> UIImage! {
        return UIImage(named:"NoImageFound.jpg")!
    }
    
    func contentModeForImageIndex(index: UInt) -> UIViewContentMode {
        return UIViewContentMode.ScaleAspectFit;
    }

    // MARK: - PlayersManagement - PLAYERS
    func handleDeleteUser(response:[String:AnyObject]) {

        let deleteUserDict:AnyObject = (response["DeletedUser"] as? Dictionary<String,AnyObject>)!
        let deleteUserFbId:String = (deleteUserDict["fb_id"] as? String)!
        print("DeleteUserFbId => \(deleteUserFbId))")
        
        let btn = self.getPlayerButtonAgainstId(deleteUserFbId)
        btn.selected = false
        btn.enabled = false
        btn.setImage(nil, forState: UIControlState.Normal)
    }

    func handleAddUser(response:[String:AnyObject], key:String) {
        
        let userDict:AnyObject = (response[key] as? Dictionary<String,AnyObject>)!
        let userFbId:String = (userDict["fb_id"] as? String)!
        let userImgPath:String = (userDict["pic_path"] as? String)!
        
        let player = self.getPlayerAgainstId(userFbId)
        player?.addImageUrlToGallery(userImgPath)
    }

    func handleFinalDwindleDown () {

        //Close Keyboard
        self.hideKeyboard()
        self.gameInProgress = false
        
        let button: RoundButtonView = self.getPlayerButtonAgainstId(playerOpponent.fbId)
        let dp = button.imageForState(UIControlState.Normal)

        let dialog = FinalDwindleDownDialog.loadWithNib() as? FinalDwindleDownDialog
//        let dp = UIImage(named: "demo_avatar_woz")
        dialog?.showWithImage(dp, successBlock: { (index: Int) -> Void in
            //Open Matches Listing
            dialog?.dismissView(true)
            print("Selected Option: \(index)")
            
            self.resetGameViews()
            
            if (index == 0){
                
                self.performSegueWithIdentifier("pushMatchListing", sender: nil)
            }
            else{
                
                let settings = UserSettings.loadUserSettings()
                let manager = ServiceManager()
                
                manager.getUserLocation({ (location: CLLocation!) -> Void in
                    
                    let data:[AnyObject] = [settings.fbId,location.coordinate.longitude,location.coordinate.latitude]
                    
                    self.dwindleSocket.sendEvent("restartGamePlay", data: data)
                    
                    self.isPlayerFound = false
                    
                    }, failure: { (error:NSError!) -> Void in
                        
                        print("Error Message =>\(error.localizedDescription)")
                        ProgressHUD.showError("Please turn on your location from Privacy Settings in order to play the game.")
                        let delay = 3.5 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            self.popController()
                        }
                })
            }
        })
    }
    
    func handleDwindleDown(respDict:[String:AnyObject]) {
        
        let ddDict:[String:AnyObject] = (respDict["DwindleDown"] as? Dictionary<String,AnyObject>)!

        for (key, _) in ddDict {
            
            if (key == "DeletedUser"){
//        1. Delete User
                self.handleDeleteUser(ddDict as [String : AnyObject])
            }
            else if (key == "DwindleCount") {
                
                let dCount = ddDict["DwindleCount"] as! Int
                print("DwindleCount => \(dCount)")
                
                if (dCount == 4){
                    self.handleFinalDwindleDown()
                }
                else{
                    ProgressHUD.showSuccess("New Pic Unlocked! \nTap above to view\n")
                }
            }
            else{
//        2. Add picture to Remaining Users
                self.handleAddUser(ddDict as [String : AnyObject], key: key)
            }
        }
    }

    func getPlayerButtonAgainstId(fbId:String)-> RoundButtonView {
        
        if(btn1.playerId == fbId) {
            return btn1
        }
        else if (btn2.playerId == fbId) {
            return btn2
        }
        else if (btn3.playerId == fbId) {
            return btn3
        }
        else if (btn4.playerId == fbId) {
            return btn4
        }
        else {
            return btn5
        }
    }
    
    func getPlayerAgainstId(fbId: String) -> Player? {

        var playerRequested : Player? = nil
        
        if let tmpPlayersDict = playersDict {
            for (key, _) in tmpPlayersDict {
                let player  = playersDict[key] as? Player
                if (player?.fbId == fbId){
                    playerRequested = player
                    break
                }
            }
        }
        return playerRequested
    }
    
    // MARK: - HANDLE UI - DwindleDown
    
    func resetGameViews() {
        
        print("resetGameViews")
        
        self.hideKeyboard()
        self.title = "Finding Match"

        self.gameInProgress = false
        self.isComingFromOtherScreen = false
        
        playersDict.removeAll(keepCapacity: false)
        
        btn1.playerId = ""
        btn2.playerId = ""
        btn3.playerId = ""
        btn4.playerId = ""
        btn5.playerId = ""
        
        btn1.enabled = true
        btn2.enabled = true
        btn3.enabled = true
        btn4.enabled = true
        btn5.enabled = true

        btn1.selected = true
        btn2.selected = true
        btn3.selected = true
        btn4.selected = true
        btn5.selected = true
        
        btn1.sd_cancelImageLoadForState(UIControlState.Normal)
        btn2.sd_cancelImageLoadForState(UIControlState.Normal)
        btn3.sd_cancelImageLoadForState(UIControlState.Normal)
        btn4.sd_cancelImageLoadForState(UIControlState.Normal)
        btn5.sd_cancelImageLoadForState(UIControlState.Normal)
        
        btn1.setImage(nil, forState: UIControlState.Normal)
        btn2.setImage(nil, forState: UIControlState.Normal)
        btn3.setImage(nil, forState: UIControlState.Normal)
        btn4.setImage(nil, forState: UIControlState.Normal)
        btn5.setImage(nil, forState: UIControlState.Normal)
        
        self.playerMain = nil
        self.playerOpponent = nil
        self.playerOther1 = nil
        self.playerOther2 = nil
        self.playerOther3 = nil
        self.playerOther4 = nil
        
        self.demoData.clearChat()
        self.collectionView!.reloadData()
        
        if let galleryOpenerButton = galleryOpenerButton {
            self.openImageGallery(galleryOpenerButton)
            self.galleryOpenerButton = nil
        }
        
        galleryHeightConstraint!.constant = 0
        
        self.onlineUserTimer?.invalidate()
        self.onlineUserTimer = nil
        self.offlineUsersEndDate = NSDate()
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func getPlayerIdRandomly() -> String {
        
//        let random = Int(arc4random_uniform(UInt32(randomPlayers.count - i))) + i
        let rIndex = self.randomInt(0, max: randomPlayers.count-1)
        let playerId: String = randomPlayers[rIndex]
        randomPlayers.removeAtIndex(rIndex)
        return playerId
    }
    
    func setPlayerImages() {
        
        playersDict["main"] = self.playerMain
        playersDict["opponent"] = self.playerOpponent
        playersDict["other1"] = self.playerOther1
        playersDict["other2"] = self.playerOther2
        playersDict["other3"] = self.playerOther3
        playersDict["other4"] = self.playerOther4
        
        if self.isViewLoaded() == false || self.view.window == nil {
            print("Play screen is not loaed or not front most")
        }
        
        if self.isViewLoaded() || self.view.window != nil {
            
            // Create method that will have all player's id
            // it will then assign 1 id to 1 user
            // and remove it from list
            
            btn1.playerId = self.getPlayerIdRandomly()
            btn2.playerId = self.getPlayerIdRandomly()
            btn3.playerId = self.getPlayerIdRandomly()
            btn4.playerId = self.getPlayerIdRandomly()
            btn5.playerId = self.getPlayerIdRandomly()
            
            var player = self.getPlayerAgainstId(btn1.playerId)
            btn1.sd_setImageWithURL(player?.imgPath, forState:.Normal)
            
            player = self.getPlayerAgainstId(btn2.playerId)
            btn2.sd_setImageWithURL(player?.imgPath, forState:.Normal)
            
            player = self.getPlayerAgainstId(btn3.playerId)
            btn3.sd_setImageWithURL(player?.imgPath, forState:.Normal)
            
            player = self.getPlayerAgainstId(btn4.playerId)
            btn4.sd_setImageWithURL(player?.imgPath, forState:.Normal)
            
            player = self.getPlayerAgainstId(btn5.playerId)
            btn5.sd_setImageWithURL(player?.imgPath, forState:.Normal)
        }
    }
    
    // MARK: - HANDLE UI - OpenGallery
    func hideKeyboard() {

//        if(self.inputToolbar.contentView.textView.isFirstResponder()){
            self.inputToolbar!.contentView!.textView!.resignFirstResponder()
//        self.hideKeyboardForcefully()
//        }
    }
    
    func shouldOpenGallery(sender:AnyObject) -> Bool{
       
        let button = sender as? RoundButtonView
        
        if let playerId = button?.playerId{
            
            if (playerId == ""){
                return false
            }
        }
        else{
            return false
        }
        return true
    }
    
    @IBAction func openImageGallery(sender: AnyObject) {

        //Close Keyboard
        self.hideKeyboard()

        if(!self.shouldOpenGallery(sender)){
            return
        }
        
        let button = sender as? UIButton
        
        print("tagId\(button?.tag)")
        
        if let prevButton = galleryOpenerButton{
            if (prevButton.isEqual(button)){
                print("Same Button")
            }
            else{
                galleryOpenerButton = button as? RoundButtonView
                galleryOpenerButton?.tag = 0
                print("Different Button")
            }
        }
        else{
            // cacheId is nil
            
            galleryOpenerButton = button as? RoundButtonView
            print("Setting Button")
        }

        if (galleryOpenerButton!.tag == 0){
            galleryOpenerButton!.tag = 1
            galleryHeightConstraint!.constant = 275
        }
        else if (galleryOpenerButton!.tag == 1){
            galleryOpenerButton!.tag = 0
            galleryHeightConstraint!.constant = 0
        }
        
        UIView.animateWithDuration(0.5) {
            self.view.needsUpdateConstraints()
            self.view.layoutIfNeeded()
        }
        
        scroller.reloadDataWithCompleteBlock { () -> Void in
            //code
        }
    }
    
    // MARK: - Utilty Methods
    
    func JSONParseArray(jsonString: String) -> [AnyObject] {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {

            let arrayResp: [AnyObject]!
            do{
                arrayResp = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as! [AnyObject]
                return arrayResp

            }catch let err as NSError {
                print("JSON Error \(err.localizedDescription)")
            }
        }
        return [AnyObject]()
    }

    func JSONParseDictionary(jsonString: String) -> [String: AnyObject] {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            
            let dictionary: [String: AnyObject]!
            do {
                dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))  as! [String: AnyObject]
                return dictionary
            }
            catch let err as NSError {
                print("JSON Error \(err.localizedDescription)")
            }
        }
        return [String: AnyObject]()
    }
    
    // MARK: - SOCKETS

    func startGame() {
        
        self.initSocketConnection();
    }
    
    func sendChat(message:String){

        self.dwindleSocket.sendEvent("sendchat", data: [message])
    }
    
    func sendgamePlayEvent(event:String) {
        
        self.handleHUDProgressView("Starting Game...", delay: 0)
        
        let settings = UserSettings.loadUserSettings()
        let manager = ServiceManager()
        manager.getUserLocation({ (location: CLLocation!) -> Void in

            print("FBID =>\(settings.fbId) and lon => \(location.coordinate.longitude) and lat => \(location.coordinate.latitude) event => \(event)")
            
            let data:[AnyObject] = [settings.fbId,location.coordinate.longitude,location.coordinate.latitude, self.pagination_user_count]
            
            self.dwindleSocket.sendEvent(event, data: data)
            
            self.isPlayerFound = false
            
            self.show90SecTimer()
            
            if event == "Play" {
                self.perform10SecTimer()
            }
            
            }, failure: { (error:NSError!) -> Void in

                print("Error Message =>\(error.localizedDescription)")
                ProgressHUD.showError("Please turn on your location from Privacy Settings in order to play the game.")
                let delay = 3.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.popController()
                }
        })
    }
    
    func gameStartedWithParams(data:String) {
        
        print("self.viewIsLoaded: \(self.viewIsLoaded)")
        print("\(data)")

        self.gameInProgress = true
        self.isPlayerFound = true
        self.offlineUsersEndDate = NSDate()
        
        let dataStr = data
        let roomUserInfoDict =  self.JSONParseDictionary(dataStr)
        
        self.playerMain      =  Player(dict: roomUserInfoDict["MainUser"]! as? Dictionary)
        self.playerOpponent  = Player(dict: roomUserInfoDict["SecondUser"]! as? Dictionary)
        
        let secondUserDict = roomUserInfoDict["SecondUser"] as! [String : String]
        let name = secondUserDict["user_name"]
        self.title = name
        
        let otherData = roomUserInfoDict["OtherUsers"] as! NSArray
                
        self.playerOther1 = Player(dict: otherData[0] as? Dictionary)
        self.playerOther2 = Player(dict: otherData[1] as? Dictionary)
        self.playerOther3 = Player(dict: otherData[2] as? Dictionary)
        self.playerOther4 = Player(dict: otherData[3] as? Dictionary)
        
        self.randomPlayers.append(self.playerOpponent.fbId)
        self.randomPlayers.append(self.playerOther1.fbId)
        self.randomPlayers.append(self.playerOther2.fbId)
        self.randomPlayers.append(self.playerOther3.fbId)
        self.randomPlayers.append(self.playerOther4.fbId)
        self.randomPlayers.shuffled()
        
        ProgressHUD.dismiss()
        
        ProgressHUD.showSuccess("Game Started. Say Hello!")
        
        self.setPlayerImages()
    }
    
    func initSocketConnection() {
        
        // create socket.io client instance
        if isComingFromOtherScreen == false && self.gameInProgress == false {
            self.sendgamePlayEvent("Play")
        }
        
        if dwindleSocket.isGamePlayerControllerHandlerAdded == true {
            print("isGamePlayerControllerHandlerAdded")
            return
        }
        
        dwindleSocket.EventHandler(HandlerType.Play) { (socketClient: SocketIOClient) -> Void in
            
            if socketClient.status == .Connected { // We are save to proceed
                
                socketClient.on("updatechat", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    
                    print("GamePlayController->updatechat: \(data)")
                    
                    let responseArr:[AnyObject] =  data
                    
                    var _senderId:String = ""
                    if let tmpSenderId = responseArr[0]  as? String {
                        _senderId = tmpSenderId
                    }
                    let _message:String = (responseArr[1] as? String)!
                    
                    if let tmpPlayer = self.playerOpponent,
                       let tmpPlayerId = tmpPlayer.fbId where tmpPlayerId == _senderId {
                        self.receivedMessagePressed(_senderId, _displayName: "", _message: _message)
                    }
                })
                
                socketClient.on("dwindledown", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    
                    print("dwindledown: \(data)")
                    
                    let responseArr: [AnyObject] =  data
                    let dataStr: String = responseArr[0] as! String
                    
                    let dwindledownDict: AnyObject =  self.JSONParseDictionary(dataStr)
                    self.handleDwindleDown(dwindledownDict as! [String : AnyObject])
                })
                
                socketClient.on("useradded", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
//                    print("UserAdded: \(data)")
                })
                
                socketClient.on("disconnectResponse", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    
                    print("disconnectResponse: \(data)")
                    self.handleLeaveGame()
                })
                
                socketClient.on("skip", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    print("\n Skip: \(data)")
                })
                
                socketClient.on("skipchat", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    print("skipchat: \(data)")
                    self.handleLeaveGame()
                })
                
                socketClient.on("leaveGameResponse", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    print("leaveGameResponse: \(data)")
                    self.handleLeaveGame()
                })
                
                socketClient.on("message_no_online_user", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    print("message_no_online_user: \(data)")
                    self.handleNoMatchFound()
                })
                
                socketClient.on("message_not_found", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    print("message_not_found: \(data)")
                    self.handleNoMatchFound()
                })
                
                socketClient.on("disconnect", callback: { (data:[AnyObject], ack:SocketAckEmitter) -> Void in
                    
                    print("disconnect \(data)")
                    
                    let state:UIApplicationState  = UIApplication.sharedApplication().applicationState
                    if (state == UIApplicationState.Background) {//UIApplicationStateBackground
                        print("Application is in background and SIO disconnected.");
                    }
//                    if (error.code == 57) {
//                        
                        ProgressHUD.showError("You are disconnected. Please check your internet connection")

                        let delay = 3.5 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            self.popController()
                        }
//                    }
                })
                
                socketClient.on("event_no_against_game_request", callback: { (data:[AnyObject], ack) -> Void in
                    print("event_no_against_game_request=> \(data)")
                    self.perform10SecTimer()
                })
                
                socketClient.on("message_push_notification_send", callback: { (data:[AnyObject], ack) -> Void in
                    self.onlineUserTimer?.invalidate()
                    self.onlineUserTimer = nil
                })
                
                socketClient.onAny({ (SocketAnyEvent) -> Void in
                
                    if SocketAnyEvent.event == "startgame" {
                        self.handleHUDProgressView(nil, delay: 0)
                    }
                    
                    if SocketAnyEvent.event == "event_Error" {
                        self.resetGameViews()
                    }
                    
                    if SocketAnyEvent.event == "error" {
                        
                        print("GAMEPLAY CHAT => socket onError with error \(SocketAnyEvent.description)");
//                        let errorCode = error.code as Int
//                        if (errorCode == -8) { //SocketIOUnauthorized
//                            print("not authorized");
//                        } else {
//                            print("onError()\(error)");
//                        }
                    }
                })
            }
        }
    }
    
    //MARK: Ignore events
    
    private var onlineUserEndDate = NSDate()
    private var onlineUserTimer:NSTimer?
    private let onlineUsersTime:Int = 10
    
    func perform10SecTimer() {
        
        print("perform10SecTimer")
        
        onlineUserTimer? .invalidate()
        onlineUserTimer = nil
        onlineUserTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(GamePlayController.sendIgnoredEvent(_:)), userInfo: nil, repeats: true)
        self.onlineUserEndDate = NSDate(timeIntervalSinceNow: Double(onlineUsersTime))
    }
    
    func sendIgnoredEvent(timer:NSTimer) {
        
        let timeInterval = Int(self.onlineUserEndDate.timeIntervalSinceNow)
        
        if timeInterval == 0 {
            
            onlineUserTimer?.invalidate()
            onlineUserTimer = nil
            
            if self.view.window == nil { //13/02/2016
                return
            }
            
            print("sendIgnoredEvent")
            
            if self.gameInProgress == false {
                
                let manager = ServiceManager()
                manager.getUserLocation({ (location: CLLocation!) -> Void in
                    
                    let settings = UserSettings.loadUserSettings()
                    let data:[AnyObject] = [settings.fbId,location.coordinate.longitude,location.coordinate.latitude]
                    
                    self.dwindleSocket.sendEvent("game_request_ignored", data: data)
                    self.perform10SecTimer()
                    
                    },
                    failure: { (error:NSError!) -> Void in
                        
                        print("Error Message =>\(error.localizedDescription)")
                        ProgressHUD.showError("Please turn on your location from Privacy Settings in order to play the game.")
                        let delay = 3.5 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            self.popController()
                        }
                })
            }
        }
    }
    
    //MARK: Timer func
    
    private var offlineUsersEndDate = NSDate()
    private var offlineUsersTimer:NSTimer!
    private let offlineUsersTime:Int = 90
    private var timerControl:DDHTimerControl?
    private var waitingLabel: UILabel?
    
    private var shown90SecTimer = false {
        
        didSet {
            
            if shown90SecTimer {
                self.view.userInteractionEnabled = false
            }
            else {
                self.view.userInteractionEnabled = true
            }
        }
    }
    
    func show90SecTimer() {
        
        ProgressHUD.dismiss()
        
        if let timerCrl = timerControl where timerCrl.isDescendantOfView(self.view) {
//            self.offlineUsersEndDate = NSDate(timeIntervalSinceNow: Double(offlineUsersTime))
            return
        }
        
        timerControl = DDHTimerControl(type: DDHTimerType.EqualElements)
        timerControl!.translatesAutoresizingMaskIntoConstraints = false
        timerControl!.color = UIColor(red: 0.0, green: 129/255.0, blue: 173/255.0 , alpha: 1.0)
        timerControl!.highlightColor = UIColor.redColor()
        timerControl!.minutesOrSeconds = offlineUsersTime
        timerControl!.maxValue = offlineUsersTime
        timerControl!.titleLabel.text = "Sec"
        timerControl!.userInteractionEnabled = false
        
        self.view.addSubview(timerControl!)
        
        let width = NSLayoutConstraint(item: timerControl!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 0.5, constant: 0)
        let height = NSLayoutConstraint(item: timerControl!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: timerControl!, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        let centerX = NSLayoutConstraint(item: timerControl!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: timerControl!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        self.view.addConstraints([centerX, centerY, width, height])
        
        let msg = "Waiting for match to connect..."
        
        waitingLabel = UILabel()
        waitingLabel!.text = msg
        waitingLabel!.numberOfLines = 1
        waitingLabel!.textAlignment = .Center
        waitingLabel!.textColor = UIColor(red: 0/255.0, green: 129/255.0, blue: 173/255.0 , alpha: 1.0)
        waitingLabel!.font = UIFont.systemFontOfSize(13)
        waitingLabel!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(waitingLabel!)
        
        let widthL = NSLayoutConstraint(item: waitingLabel!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 10)
        
        let heightL = NSLayoutConstraint(item: waitingLabel!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 21)
        
        let centerLX = NSLayoutConstraint(item: waitingLabel!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
                
        let centerLY = NSLayoutConstraint(item: waitingLabel!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: timerControl!, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)
        
        self.view.addConstraints([centerLX, centerLY, heightL, widthL])
        
        offlineUsersTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(GamePlayController.changeTimer(_:)), userInfo: nil, repeats: true)
        
        self.offlineUsersEndDate = NSDate(timeIntervalSinceNow: Double(offlineUsersTime))
        self.shown90SecTimer = true
    }
    
    func changeTimer(timer:NSTimer) {
        
        let timeInterval = Int(self.offlineUsersEndDate.timeIntervalSinceNow)
        
        if (timeInterval) == 0 {
            
            timer.invalidate()
            offlineUsersTimer = nil
            self.timerControl?.removeFromSuperview()
            self.waitingLabel?.removeFromSuperview()
            self.timerControl = nil
            self.waitingLabel = nil
            self.shown90SecTimer = false
            
            if self.gameInProgress == false {
                
                if self.viewLoaded {
                    
                    let message = "Hmmm, we couldn’t find any matches right now. You can adjust your preferences or try again."
                    
                    let popup = Popup.init(title: "",
                        subTitle: message,
                        cancelTitle: "Main Menu",
                        successTitle: "Try Again",
                        cancelBlock: { () -> Void in
                            
                            self.popController()
                            
                        }, successBlock: { () -> Void in
                            
                            self.sendgamePlayEvent("force play")
                    })
                    
                    self.view.endEditing(true)
                    popup.incomingTransition = PopupIncomingTransitionType.BounceFromCenter
                    popup.outgoingTransition = PopupOutgoingTransitionType.BounceFromCenter
                    popup.showPopup()
                }
            }
        }
        self.timerControl?.minutesOrSeconds = (timeInterval)
    }
    
    // MARK: -   VIEW LIFE CYCLE
    
    func initContentView() {
        
        // Scroll Initialization
        scroller.autoPlayTimeInterval = 0;
        scroller.continuous = true;
        
        let settings = UserSettings.loadUserSettings()
        self.senderId = settings.fbId
        self.senderDisplayName = settings.fbName
        
        self.demoData = DemoModelData()
        
        if (!NSUserDefaults.incomingAvatarSetting()){
            self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
        }
        
        if (!NSUserDefaults.outgoingAvatarSetting()) {
            self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        }
        
        self.showLoadEarlierMessagesHeader = false
        self.jsq_configureMessagesViewController();
        self.jsq_registerForNotifications(true);
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        self.handleHUDProgressView(nil, delay: 1.5)
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        dwindleSocket = DwindleSocketClient.sharedInstance
        
        if self.gameInProgress == true {
            let settings = UserSettings.loadUserSettings()
            self.dwindleSocket.sendEvent("event_change_user_status", data: [settings.fbId, "playing"])
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        self.handleHUDProgressView(nil, delay: 0.0)
        isComingFromOtherScreen = false
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.pagination_user_count = 0
        self.collectionView!.collectionViewLayout.springinessEnabled = NSUserDefaults.springinessSetting();
        
        if self.isMovingToParentViewController() {
            self.startGame()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Finding Match"
        self.initContentView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style:UIBarButtonItemStyle.Plain , target: self, action: #selector(GamePlayController.skipPressed(_:)))
    }
    
    func popController() {
        self.resetGameViews()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleHUDProgressView(text:String?, delay:Double) {
        
        guard let txt = text else {
            
            let delay = delay * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                ProgressHUD.dismiss()
                
                if self.shown90SecTimer == false {
                    self.view.userInteractionEnabled = true
                }
            }
            return
        }
        
        self.view.userInteractionEnabled = false
        ProgressHUD.show(txt)
    }
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: -   Actions
    
//    func receivedMessagePressed(sender: UIBarButtonItem) {
    func receivedMessagePressed(_senderId:String, _displayName:String, _message:String) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
        var newMessage : JSQMessage ;

        newMessage = JSQMessage(senderId: _senderId, displayName: " ", text: _message)
        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
        self.demoData.messages.addObject(newMessage)
        self.finishReceivingMessageAnimated(true)
        
    }
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: -   JSQMessagesViewController method overrides
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        /**
        *  Sending a message. Your implementation of this method should do *at least* the following:
        *
        *  1. Play sound (optional)
        *  2. Add new id<JSQMessageData> object to your data source
        *  3. Call `finishSendingMessage`
        */
        JSQSystemSoundPlayer.jsq_playMessageSentSound();
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        
        self.demoData.messages.addObject(message);
        
        self.finishSendingMessageAnimated(true);
        
        self.sendChat(text)
//        self.handleFinalDwindleDown()

    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
        let sheet = UIActionSheet(title: "Quick messages", delegate:self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles:
            "What actor would best play the role of you?",
            "You can live anyplace in the world, where?",
            "Have you had any success with dating apps?",
            "What's the worst job you've ever had?     ",
            "What movie title describes your sex life?",
            "Drink with anyone throughout history, who?",
            "What about you surprises people the most?",
            "  Do you have any nicknames?                      ",
            "What's the worst part about modern dating?",
            "You're cooking me dinner, what's the menu?");
        
        sheet.showFromToolbar(self.inputToolbar!);
    }
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return;
        }
        let sampleMessagesArr = ["What actor would best play the role of you?",
                                "You can live anyplace in the world, where?",
                                "Have you had any success with dating apps?",
                                "What's the worst job you've ever had?",
                                "What movie title describes your sex life?",
                                "Drink with anyone throughout history, who?",
                                "What about you surprises people the most?",
                                "Do you have any nicknames?",
                                "What's the worst part about modern dating?",
                                "You're cooking me dinner, what's the menu?"]
        
        let text = sampleMessagesArr[buttonIndex-1]
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound();
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: NSDate(), text: text)
        
        self.demoData.messages.addObject(message);
        
        self.finishSendingMessageAnimated(true);
        
        self.sendChat(text)
    }
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: -  JSQMessages CollectionView DataSource
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.demoData.messages[indexPath.item] as! JSQMessageData
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        /**
        *  You may return nil here if you do not want bubbles.
        *  In this case, you should set the background color of your collection view cell's textView.
        *
        *  Otherwise, return your previously created bubble image data objects.
        */
        
        let message : JSQMessage = self.demoData.messages [indexPath.item] as! JSQMessage
        if (message.senderId == self.senderId) {
            return self.demoData.outgoingBubbleImageData;
        }
        
        return self.demoData.incomingBubbleImageData;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        /**
        *  Return `nil` here if you do not want avatars.
        *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
        *
        *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
        *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        *
        *  It is possible to have only outgoing avatars or only incoming avatars, too.
        */
        
        /**
        *  Return your previously created avatar image data objects.
        *
        *  Note: these the avatars will be sized according to these values:
        *
        *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
        *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
        *
        *  Override the defaults in `viewDidLoad`
        */
        
        //        var message : JSQMessage = self.demoData.messages [indexPath.item] as! JSQMessage
        //        
        //        if (message.senderId == self.senderId) {
        //            if (!NSUserDefaults.outgoingAvatarSetting()) {
        //                return nil;
        //            }
        //        }
        //        else {
        //            if (!NSUserDefaults.incomingAvatarSetting()) {
        //                return nil;
        //            }
        //        }
        
        return nil;
        //return self.demoData.avatars[message.senderId] as JSQMessageAvatarImageDataSource;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        /**
        *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
        *  The other label text delegate methods should follow a similar pattern.
        *
        *  Show a timestamp for every 3rd message
        */
        if (indexPath.item % 3 == 0) {
            let message : JSQMessage = self.demoData.messages [indexPath.item] as! JSQMessage
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        
        return nil;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let message : JSQMessage = self.demoData.messages [indexPath.item] as! JSQMessage
        
        /**
        *  iOS7-style sender name labels
        */
        if (message.senderId  == self.senderId) {
            return nil;
        }
        
        if (indexPath.item - 1 > 0) {
            let previousMessage: JSQMessage = self.demoData.messages[indexPath.item - 1]as! JSQMessage;
            if (previousMessage.senderId == message.senderId) {
                return nil;
            }
        }
        
        /**
        *  Don't specify attributes to use the defaults.
        */
        return NSAttributedString(string: message.senderDisplayName);
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        return nil;
    }
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: -  UICollectionView DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: NSInteger) -> NSInteger {
        return self.demoData.messages.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        if let textView = cell.textView {
            let message = self.demoData.messages[indexPath.item] as! JSQMessage
            if message.senderId == self.senderId {
                textView.textColor = UIColor.whiteColor()
            } else {
                textView.textColor = UIColor.blackColor()
            }
            
            let attributes = [NSForegroundColorAttributeName:textView.textColor!, NSUnderlineStyleAttributeName: 1]
            textView.linkTextAttributes = attributes
            
            //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
            //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        }
        return cell
    }
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: - JSQMessages collection view flow layout delegate
    // MARK: - Adjusting cell label heights
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        /**
        *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
        */
        
        /**
        *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
        *  The other label height delegate methods should follow similarly
        *
        *  Show a timestamp for every 3rd message
        */
        
        if (indexPath.item % 3 == 0) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault;
        }
        
        return 0.0;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        /**
        *  iOS7-style sender name labels
        */
        
        let currentMessage :JSQMessage = self.demoData.messages[indexPath.item] as! JSQMessage;
        
        if (currentMessage.senderId == self.senderId) {
            return 0.0;
        }
        
        if (indexPath.item - 1 > 0) {
            let previousMessage :JSQMessage = self.demoData.messages[indexPath.item - 1] as! JSQMessage;
            if (previousMessage.senderId == currentMessage.senderId) {
                return 0.0;
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        return 0.0;
    }
    
    
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    //============================================================================================\\
    // MARK: - Responding to collection view tap events
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        print("Load earlier messages!");
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        print("Tapped avatar!");
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        print("Tapped message bubble!");
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        print("Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
    }
}

