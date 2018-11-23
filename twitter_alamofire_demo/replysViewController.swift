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
    @IBOutlet weak var replyLabel: UILabel!
    
    var imagePath: String = ""
    var fullName: String = ""
    var userName: String = ""
    var textContent: String = ""
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        replyLabel.text = "Replying to @ " + userName
        postProfileImage.af_setImage(withURL: URL(string: imagePath)!)
        postUsernameLabel.text = fullName
        postScreenNameLabel.text = userName
        postContent.text = textContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUser() {
        APIManager.shared.getCurrentAccount{ (user: User?, error: Error?) in
            if let user = user {
                self.user = user
                self.profileImage.af_setImage(withURL: URL(string: user.profileImage!)!)
                
            }
        }
    }
    @IBAction func close(_ sender: Any) {
        performSegue(withIdentifier: "TimeLineSegue", sender: self)
    }
    
    @IBAction func reply(_ sender: Any) {
        APIManager.shared.replyTweet(with: replyContent.text!) { (tweet, error) in
            if let error = error {
                print("Error on reply \(error.localizedDescription)")
            }
            else{
                print("yay it work!")
                self.performSegue(withIdentifier: "TimeLineSegue", sender: self)
            }
        }
    }
    
    

}
