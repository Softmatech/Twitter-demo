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
    var personalProfileImage: URL?
    var aboutDescription: String?
    var fallowersCount: Int?
    var fallowingCount: Int?
    var favoriteCount: Int?
    var tweetCount: Int?
    
    
    
    var banerImage:String?
    
    
    
    var dictionary: [String: Any]?
    private static var _current: User?
    
    
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImage = dictionary["profile_image_url_https"] as? String
        aboutDescription = dictionary["description"]as! String
        fallowersCount = dictionary["followers_count"]as! Int
        banerImage = dictionary["profile_banner_url"]as? String
        fallowingCount = dictionary["friends_count"]as? Int
        favoriteCount = dictionary["favorite_count"]as? Int
        tweetCount = dictionary["statuses_count"]as? Int
//        favorite_count
        self.dictionary = dictionary
        print("Dico----------------------------------------------->>>>> ",dictionary)
    }
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }

    
}
