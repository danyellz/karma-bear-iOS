//
//  CharityStruct.swift
//  KarmaBear
//
//  Created by TY on 11/16/16.
//  Copyright © 2016 Ty Daniels. All rights reserved.
//

import Foundation

struct CharityStruct {
    
    var id: Int
    var name: String
    var address: NSArray
    var latitude: Double
    var longitude: Double
    var description: String!
    var phone: String!
    var url: String!
    var imageUrl: String!
    
    init(dictionary: [String : AnyObject]) {
        
        self.id = (dictionary["id"] as? Int)!
        self.name = (dictionary["name"] as? String)!
        self.address = (dictionary["address"] as? NSArray)!
        self.latitude = (dictionary["lat"] as? Double)!
        self.longitude = (dictionary["lng"] as? Double)!
        self.description = dictionary["description"]! as? String
        self.phone = dictionary["phone"]! as? String
        self.imageUrl = dictionary["image_url"]! as? String
        self.url = (dictionary["url"]! as? String)!
    }
}

