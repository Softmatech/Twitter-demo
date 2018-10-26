//
//  composeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Joseph Andy Feidje on 10/24/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class composeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var textWrite: UITextView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    
    
    var imagePath: String = ""
    var fullName: String = ""
    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageAvatar.af_setImage(withURL: URL(string: imagePath)!)
        nameLabel.text = fullName
        screenName.text = userName
        textWrite.delegate = self
//        setPostButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Set the max character limit
        let characterLimit = 140
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        // TODO: Update Character Count Label
        let charCount = textWrite.text.count + 1
        let charLeft = characterLimit - charCount
        charCountLabel.text = String(describing: charLeft)
        setPostButton()
        // The new text should be allowed? True/False
        return newText.characters.count < characterLimit
    }

    
    func setPostButton() {
        if textWrite.text.count == 0 {
//            textWrite.text = "Write a post..."
//            textWrite.textColor = UIColor.lightGray
            postButton.isEnabled = false
        }
        else if textWrite.text.count > 0{
//            textWrite.text = ""
//            textWrite.textColor = UIColor.black
            postButton.isEnabled = true
        }
    }

    
    @IBAction func tweetButton(_ sender: Any) {
        APIManager.shared.composeTweet(with: textWrite.text!) { (tweet, error) in
            if let error = error {
                print("Error on Twitting \(error.localizedDescription)")
            }
            else{
                print("Excellent, you do it")
                self.performSegue(withIdentifier: "BackToTweetSegue", sender: nil)
            }
        }
    }
    
    @IBAction func BackButton(_ sender: Any) {
        performSegue(withIdentifier: "BackToTweetSegue", sender: nil)
    }
    
    
}
