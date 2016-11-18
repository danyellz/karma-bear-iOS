//
//  APIConstants.swift
//  KarmaBear
//
//  Created by TY on 11/18/16.
//  Copyright © 2016 Ty Daniels. All rights reserved.
//

import Foundation
//Stores all basic assets reused through the application.

struct FBConstants {
    static let BASE_URL = "http://karmabear.herokuapp.com/api"
    static let USER_KEY = UserDefaults.standard.string(forKey: "FBToken")
}

struct RequestRoutes {
    static let VERIFY_USER = "auth/verify"
    static let GET_USER = "auth/giver"
    static let CHARITIES_SEARCH = "search"
    static let MAKE_DONATION = "auth/donate"
    static let REGISTER_EVENT = "auth/register"
    static let CHARITY_DETAILS = "auth/charity"
    static let FOLLOW_CHARITY = "auth/follow"
}

struct GlobalAssets {
    static let VIDEO_LINK = "charity-1.mp4"
    static let BEAR_ANNOTATION = "KarmaBear"
    static let DEFAULT_BEAR = "Launch"
    static let BEAR_FROM_URL = "https://s-media-cache-ak0.pinimg.com/originals/37/30/41/37304117db4d017b4ef48d309b046b62.png"
    
}
