//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Iza Ledzka on 07/01/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    
    var items = [MentionViewModelItem]()

    var tweet: Tweet? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedTweet = tweet {
                items.append(MediaMentionModelViewItem(unwrappedTweet.media))
                items.append(HashtagsMentionModelViewItem(unwrappedTweet.hashtags))
                items.append(UrlsMentionModelViewItem(unwrappedTweet.urls))
                items.append(UsernameMentionModelViewItem(unwrappedTweet.userMentions))
                title = "Mentions"
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = items[section]
        if item.rowCount > 0 {
            return item.sectionTitle
        }
        return nil
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = items[indexPath.section]
        switch item.type {
        case .media:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MentionImage", for: indexPath) as? MentionImageTableViewCell {
                //fetch image (async???)
                cell.item = tweet?.media[indexPath.row]
                return cell
            }
        case .hashtags:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MentionBasicCell", for: indexPath) as? MentionBasicTableViewCell {
                cell.item = tweet?.hashtags[indexPath.row]
                return cell
            }        case .urls:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MentionBasicCell", for: indexPath) as? MentionBasicTableViewCell {
                cell.item = tweet?.urls[indexPath.row]
                return cell
                }
        case .userMentions:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MentionBasicCell", for: indexPath) as? MentionBasicTableViewCell {
                cell.item = tweet?.userMentions[indexPath.row]
                return cell
            }
            
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.section]
        guard item.rowCount != 0 else { return 0 }
        switch item.type {
        case .media:
            let width = UIScreen.main.bounds.width
            let aspectRatio = (item as? MediaMentionModelViewItem)?.mediaItems[indexPath.row].aspectRatio
            return width / CGFloat(aspectRatio ?? 0)
        default:
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        switch item.type {
        case .urls:
            let url = URL(fileURLWithPath: ((item as? UrlsMentionModelViewItem)?.urls[indexPath.row].keyword)!)
            if UIApplication.shared.canOpenURL(url){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { success in print("Success - opened url: \(success)") })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        default:
            break
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

enum MentionViewModelDataType {
    case media
    case hashtags
    case urls
    case userMentions
}

protocol MentionViewModelItem {
    var type: MentionViewModelDataType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
}

class MediaMentionModelViewItem: MentionViewModelItem {
    var type: MentionViewModelDataType {
        return .media
    }
    var sectionTitle: String {
        return "Images"
    }
    var rowCount: Int {
        return mediaItems.count
    }
    var mediaItems: [MediaItem]
    
    init(_ mediaItems: [MediaItem]){
        self.mediaItems = mediaItems
    }
}

class HashtagsMentionModelViewItem: MentionViewModelItem {
    var type: MentionViewModelDataType {
        return .hashtags
    }
    var sectionTitle: String {
        return "Hashtags"
    }
    var rowCount: Int {
        return hashtags.count
    }
    var hashtags: [Mention]
    
    init(_ hashtags: [Mention]){
        self.hashtags = hashtags
    }
}

class UrlsMentionModelViewItem: MentionViewModelItem {
    var type: MentionViewModelDataType {
        return .urls
    }
    var sectionTitle: String {
        return "Links"
    }
    var rowCount: Int {
        return urls.count
    }
    var urls: [Mention]
    
    init(_ urls: [Mention]){
        self.urls = urls
    }
}

class UsernameMentionModelViewItem: MentionViewModelItem {
    var type: MentionViewModelDataType {
        return .userMentions
    }
    var sectionTitle: String {
        return "Mentioned Users"
    }
    var rowCount: Int {
        return userMention.count
    }
    var userMention: [Mention]
    
    init(_ userMention: [Mention]){
        self.userMention = userMention
    }
}
