//
//  profileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Joseph Andy Feidje on 10/25/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit


class profileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backDropImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var follwing: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var tweet: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var tweets: [Tweet] = []
    var users: [User] = []
    var user: User?
    var refreshControl: UIRefreshControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorSet()
        emptyLabel()
        tableView.delegate = self
        tableView.dataSource = self
        fetchTweets()
        fetchUser()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchTweets()
    }
    
    func emptyLabel() {
        NameLabel.text = ""
        userLabel.text = ""
        aboutLabel.text = ""
        followers.text = ""
        follwing.text = ""
        tweet.text = ""
    }
    
    func indicatorSet(){
        if indicatorView.isAnimating == true {
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
        }
        else{
            indicatorView.isHidden = true
            indicatorView.startAnimating()
        }
    }
    
    func fetchTweets() {
        APIManager.shared.getHomeTimeLine { (tweets: [Tweet]?, error: Error?) in
            self.indicatorView.startAnimating()
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.indicatorView.stopAnimating()
            }
        }
    }
    
    func fetchUser() {
        APIManager.shared.getCurrentAccount{ (user: User?, error: Error?) in
            self.indicatorView.startAnimating()
            if let user = user {
                self.user = user
                self.NameLabel.text = user.name
                self.profileImage.af_setImage(withURL: URL(string: user.profileImage!)!)
                self.backDropImage.af_setImage(withURL: URL(string: user.banerImage!)!)
                self.userLabel.text = user.screenName
                self.aboutLabel.text = user.aboutDescription
                self.follwing.text = String(describing: user.fallowingCount!) + " Following"
                self.followers.text = String(describing: user.fallowersCount!) + " Followers"
                self.tweet.text = String(describing: user.tweetCount!) + " Tweets"
                self.indicatorView.stopAnimating()
            }
        }
    }
    
    func favoriteTweet(tweet: Tweet) {
        APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully favorited the following Tweet: \n\(tweet.text)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        if indexPath.row == 0 {
            //            lougoutButton.image = UIImage(contentsOfFile: (user?.profileImage)!)
        }
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let detailController = segue.destination as! detailViewController
            let cell = sender as! TweetCell?
            let indexPath = tableView.indexPath(for: cell!)
            detailController.tweet = tweets[(indexPath?.row)!]
    }
    
    
    

}
