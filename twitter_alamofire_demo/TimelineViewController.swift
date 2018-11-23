//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-08-11.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lougoutButton: UIBarButtonItem!
    var tweets: [Tweet] = []
    var users: [User] = []
    var user: User?
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 550
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
    
    func fetchTweets() {
        APIManager.shared.getHomeTimeLine { (tweets: [Tweet]?, error: Error?) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func fetchUser() {
        APIManager.shared.getCurrentAccount{ (user: User?, error: Error?) in
            if let user = user {
               self.user = user
            }
        }
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchTweets()
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
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        // Copy this line once you've made the outlet
        APIManager.shared.logout()
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

    @IBAction func reply(_ sender: Any) {
        print("replyyyyyyy")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
        let detailController = segue.destination as! detailViewController
        let cell = sender as! TweetCell?
        let indexPath = tableView.indexPath(for: cell!)
        detailController.tweet = tweets[(indexPath?.row)!]
        }
        else if segue.identifier == "composeSegue" {
            let composeController = segue.destination as! composeViewController
                composeController.imagePath = (user?.profileImage)!
                composeController.fullName = (user?.name)!
                composeController.userName = (user?.screenName)!
            }
        else if segue.identifier == "replySegue" {
            let replyController = segue.destination as! replysViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            replyController.tweet = tweets[(indexPath?.row)!]
        }
    }
    
    @IBAction func newButton(_ sender: Any) {
        performSegue(withIdentifier: "composeSegue", sender: nil)
    }
    
    
}
