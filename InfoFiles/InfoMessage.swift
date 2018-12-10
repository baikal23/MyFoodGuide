//
//  InfoMessage.swift
//  MyLife
//
//  Created by Susan Kohler on 4/8/16.
//  Copyright © 2016 Susan Kohler. All rights reserved.
//

import UIKit

class InfoMessage {
    var messageName:String
    var messageContent:String
    var rank:Int
    
    init(aDictionary: Dictionary<String,AnyObject>) {
        self.messageName = aDictionary["name"] as! String
        self.messageContent = aDictionary["message"] as! String
        self.rank = aDictionary["rank"] as! Int
        return
    }
}

