//
//  TweetTabBarController.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 13/11/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import UIKit

class TweetTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tweetersAction(_ sender: UIBarButtonItem) {
        guard let searchVC = selectedViewController as? SmashTweetTableViewController else { return }
        searchVC.performSegue(withIdentifier: "Tweeters Mentioning Search Term", sender: sender)
    }
    
    @IBAction func tweetsPicturesAction(_ sender: UIBarButtonItem) {
        guard let searchVC = selectedViewController as? SmashTweetTableViewController else { return }
        searchVC.performSegue(withIdentifier: "TweetPicturesSegueID", sender: sender)
    }
}
