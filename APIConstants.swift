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
}

struct GlobalAssets {
    static let VIDEO_LINK = "charity-1.mp4"
    static let BEAR_ANNOTATION = "KarmaBear"
    static let DEFAULT_BEAR = "Launch"
}
