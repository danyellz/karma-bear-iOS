//
//  CharityModel.swift
//  KarmaBear
//
//  Created by TY on 11/16/16.
//  Copyright © 2016 Ty Daniels. All rights reserved.
//

import Foundation

class CharityModel {
    
    static var charityData = [CharityStruct]()
    static var userData = [UserStruct]()
    static var userEvents = [EventStruct]()
    static var userNeeds = [NeedStruct]()
    
    class func sharedInstance() -> CharityModel{
        struct Singleton{
            static var sharedInstance = CharityModel()
        }
        return Singleton.sharedInstance
    }
}

