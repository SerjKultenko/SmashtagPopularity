//
//  PopularityViewController.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 13/11/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import UIKit
import CoreData

class PopularityViewController: UITableViewController {

    var viewModel: TweetPopularityViewModel? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        viewModel?.reloadData()
        tableView.reloadData()
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
     }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false;
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetPopularityTableViewCell", for: indexPath)
        
        if let tweetMention = viewModel?.fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = tweetMention.keyword
            //let tweetCount = tweetCountWithMentionBy(twitterUser)
            cell.detailTextLabel?.text = "\(tweetMention.popularity)" //"\(tweetCount) tweet\((tweetCount == 1) ? "" : "s")"
        }
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
