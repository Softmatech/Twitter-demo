//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-10-05.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class User: NSObject {
    // MARK: Properties
    var name: String?
    var screenName: String?
    var profileImage: String?
    
    static var current: User?
    //...
    // Add any additional properties here
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImage = dictionary["profile_image_url_https"] as? String
        print("image User---------->> ",profileImage)
        // Initialize any other properties
    }
}
