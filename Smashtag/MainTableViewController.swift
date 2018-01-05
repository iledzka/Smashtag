//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Iza Ledzka on 19/10/2017.
//  Copyright © 2017 Iza Ledzka. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UITextFieldDelegate {
    
    private var tweets = [Array<Tweet>]() {
        didSet {
            print(tweets)
        }
    }
    
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    private func twitterRequest() -> Request? {
        if let query = searchText, !query.isEmpty {
            return Request(search: query, count: 100)
        }
        return nil
    }
    private var lastTwitterRequest: Request?
    
    private func searchForTweets() {
        if let request = twitterRequest(){
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText = "#stanford"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //TwitterKit: Log In
        let store = TWTRTwitter.sharedInstance().sessionStore
        if (!store.hasLoggedInUsers()) {
            print("SESSION STORE: " + String(describing: store.session()))
            let logInButton = TWTRLogInButton(logInCompletion: { session, error in
                if (session != nil) {
                    print("signed in as \(String(describing: session?.userName))");
                } else {
                    print("error: \(String(describing: error?.localizedDescription))");
                }
            })
            logInButton.center = self.view.center
            self.view.addSubview(logInButton)
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
     
     let tweet = tweets[indexPath.section][indexPath.row]
     
     if let tweetCell = cell as? TweetTableViewCell {
        tweetCell.tweet = tweet
     }
     return cell
     }
    
    
    
    
    
}

