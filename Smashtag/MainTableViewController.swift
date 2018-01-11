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
    
    var logInButton: TWTRLogInButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
     
        //TwitterKit: Log In
        let store = TWTRTwitter.sharedInstance().sessionStore
        if (!store.hasLoggedInUsers()) {
            showTwitterLogInButton()
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowMentions", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMentions", let destination = segue.destination as? MentionsTableViewController {
            if let _ = sender as? MainTableViewController, let indexPath = tableView.indexPathForSelectedRow {
                let tweet = tweets[indexPath.section][indexPath.row]
                destination.tweet = tweet
            }
        }
    }
    
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBAction func logOut(_ sender: UIButton) {
        logOutFRomTwitter()
    }
    private func logOutFRomTwitter() {
        let store = TWTRTwitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
            tweets.removeAll()
            tableView.reloadData()
            searchText = ""
            showTwitterLogInButton()
        }
    }
    private func showTwitterLogInButton(){
        logOutButton.isHidden = true
        logInButton = TWTRLogInButton(logInCompletion: { [weak self] session, error in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
                DispatchQueue.main.async {
                    self?.logInButton?.removeFromSuperview()
                    self?.logOutButton.isHidden = false
                }
                self?.searchText = "#Polska"
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
        logInButton?.center = self.view.center
        self.view.addSubview(logInButton!)
    }
}



