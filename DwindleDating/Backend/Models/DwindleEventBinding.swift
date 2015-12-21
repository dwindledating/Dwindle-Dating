//
//  DwindleEventBinding.swift
//  DwindleDating
//
//  Created by Muhammad Rashid on 14/12/2015.
//  Copyright © 2015 infinione. All rights reserved.
//

import UIKit

enum DwindleEvent:Int {
    case Play = 1
    case message_from_play_screen = 2
    case message_from_matches_screen = 3
    case message_game_started = 4
    case APNS_Response = 5
}

enum DwindleScreens:Int {
    case SignUp
    case GenederSelection
    case AgeSelelction
    case DistanceSelection
    case PictureSeoection
    case Login
    case Menu
    case GamePlay
    case MatchList
    case MatchChat
    case Settings
    case ChangePreference
    case EditPicture
    case EditGender
    case EditAge
    case EditDistance
    case Privacy
    case Terms
}