//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor on 2/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    // outlets to the UI components in our Custom UITableViewCell
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    // public API of this UITableViewCell subclass
    // each row in the table has its own instance of this class
    // and each instance will have its own tweet to show
    // as set by this var
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    // whenever our public API tweet is set
    // we just update our outlets using this method
    private func updateUI() {
        if let currentTweet = tweet {
            tweetTextLabel?.attributedText = attributedTweetText(from: currentTweet)
        }
        tweetUserLabel?.text = tweet?.user.description
        
        tweetProfileImageView?.image = nil
        if let profileImageURL = tweet?.user.profileImageURL {
            let queue = DispatchQueue.global(qos: .utility)
            queue.async{
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    DispatchQueue.main.async { [weak self] in
                        if let newUrl = self?.tweet?.user.profileImageURL,
                            profileImageURL == newUrl
                        {
                            self?.tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
    
    func attributedTweetText(from tweet: Twitter.Tweet) -> NSAttributedString {
        let attributedTweetText = NSMutableAttributedString(string: tweet.text)
        for hashtag in tweet.hashtags {
            attributedTweetText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: hashtag.nsrange)
        }
        for url in tweet.urls {
            attributedTweetText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.purple, range: url.nsrange)
        }

        for userMention in tweet.userMentions {
            attributedTweetText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.green, range: userMention.nsrange)
        }

        return attributedTweetText
    }
}
