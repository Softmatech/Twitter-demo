//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Joseph Andy Feidje on 10/16/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import DateToolsSwift

class TweetCell: UITableViewCell {

    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var replyLabel: UIButton!
    @IBOutlet weak var retweetedLabel: UIButton!
    @IBOutlet weak var likeLabel: UIButton!
    @IBOutlet weak var messageLabel: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userRetweetedLabel: UILabel!
    
    
    var parentView : TimelineViewController?
    
    var tweet: Tweet! {
        didSet {
            
            let imageURL = URL(string: (tweet.user?.profileImage)!)
        imageAvatar.af_setImage(withURL: imageURL!)
        nameLabel.text = tweet.user?.name
        username.text = tweet.user?.screenName
        tweetContent.text = tweet.text
        retweetedLabel.setTitle(String(describing: tweet.retweetCount), for: UIControlState.normal)
        likeLabel.setTitle(String(describing: tweet.favoriteCount), for: UIControlState.normal)
        dateLabel.text = tweet.createdAtString

            funcbuttonColor(tweet)
        }
    }
    
    func funcbuttonColor(_: Tweet!){
        var colImage = UIImage(named: "favor-icon")
        var greenTapImage = UIImage(named: "retweet-icon")
        if tweet.favorited! {
            colImage = UIImage(named: "favor-icon-red")
        }
        if tweet.retweeted! {
            greenTapImage = UIImage(named: "retweet-icon-green")
        }
        self.likeLabel.setImage(colImage, for: UIControlState.normal)
        retweetedLabel.setImage(greenTapImage, for: UIControlState.selected)
    }
    
    @IBAction func didtapToretweet(_ sender: UIButton) {
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
        retweetedLabel.setTitle(String(describing: tweet.retweetCount), for: UIControlState.normal)
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        print("yessss")
        if tweet.favorited! {
            tweet.favorited = false
            tweet.favoriteCount -= 1
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    let whiteTapImage = UIImage(named: "favor-icon")
                    self.likeLabel.setImage(whiteTapImage, for: UIControlState.normal)
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
                    self.likeLabel.setImage(redTapImage, for: UIControlState.normal)
                    self.parentView?.fetchTweets()
                }
            }
        }
        likeLabel.setTitle(String(describing: tweet.favoriteCount), for: UIControlState.normal)
    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.imageview.frame.size.width/3
        imageAvatar.layer.cornerRadius = self.imageAvatar.frame.size.width/2
        imageAvatar.layer.masksToBounds = true
//        self.imageAvatar.contentMode = UIViewContentMode.scaleAspectFit
        imageAvatar.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
