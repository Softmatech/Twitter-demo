//
//  replysViewController.swift
//  twitter_alamofire_demo
//
//  Created by Joseph Andy Feidje on 11/22/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class replysViewController: UIViewController {
    var tweet: Tweet!
    
    @IBOutlet weak var postProfileImage: UIImageView!
    @IBOutlet weak var postUsernameLabel: UILabel!
    @IBOutlet weak var postScreenNameLabel: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var replyContent: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        postProfileImage.af_setImage(withURL: URL(string: tweet.personalProfileImage!)!)
        postUsernameLabel.text = tweet.user?.name
        postScreenNameLabel.text = tweet.user?.screenName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
