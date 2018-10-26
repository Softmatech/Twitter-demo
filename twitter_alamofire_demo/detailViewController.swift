//
//  detailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Joseph Andy Feidje on 10/23/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class detailViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var textContent: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetedLabel: UIButton!
    @IBOutlet weak var starLabel: UIButton!
    
    var tweet: Tweet!
    var parentView : TimelineViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImage.af_setImage(withURL: URL(string: (tweet.user?.profileImage)!)!)
        nameLabel.text = tweet.user?.name
        usernameLabel.text = tweet.user?.screenName
        textContent.text = tweet.text
        dateLabel.text = tweet.createdAtString
        retweetLabel.text = String(describing: tweet.retweetCount)
        favoritesLabel.text = String(describing: tweet.favoriteCount)
        buttonColor(tweet)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RETWEETED(_ sender: Any) {
        if tweet.retweeted! {
            tweet.retweeted = false
            tweet.retweetCount -= 1
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeted: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                    let whiteTapImage = UIImage(named: "retweet-icon")
                    self.retweetedLabel.setImage(whiteTapImage, for: UIControlState.normal)
                    self.parentView?.fetchTweets()
                }
            }
        }
        else {
            tweet.retweeted = true
            tweet.retweetCount += 1
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeted: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                    let greenTapImage = UIImage(named: "retweet-icon-green")
                    self.retweetedLabel.setImage(greenTapImage, for: UIControlState.normal)
                    self.parentView?.fetchTweets()
                }
            }
        }
        retweetLabel.text = String(describing: tweet.retweetCount)
    }
    
    @IBAction func replybutton(_ sender: Any) {
        self.performSegue(withIdentifier: "ReplySegue", sender: nil)
    }
    
    
    @IBAction func FAVORITED(_ sender: Any) {
        if tweet.favorited! {
            tweet.favorited = false
            tweet.favoriteCount -= 1
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    let whiteTapImage = UIImage(named: "favor-icon")
                    self.starLabel.setImage(whiteTapImage, for: UIControlState.normal)
                    self.parentView?.fetchTweets()
                }
            }
        }
        else {
            tweet.favorited = true
            tweet.favoriteCount += 1
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                    let redTapImage = UIImage(named: "favor-icon-red")
                    self.starLabel.setImage(redTapImage, for: UIControlState.normal)
                    self.parentView?.fetchTweets()
                }
            }
        }
        favoritesLabel.text = String(describing: tweet.favoriteCount)
    }
    
    func buttonColor(_: Tweet!){
        var colImage = UIImage(named: "favor-icon")
        var greenTapImage = UIImage(named: "retweet-icon")
        if tweet.favorited! {
            colImage = UIImage(named: "favor-icon-red")
        }
        if tweet.retweeted! {
            greenTapImage = UIImage(named: "retweet-icon-green")
        }
        self.starLabel.setImage(colImage, for: UIControlState.normal)
        retweetedLabel.setImage(greenTapImage, for: UIControlState.selected)
    }
}
