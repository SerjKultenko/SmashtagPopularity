//
//  SearchHistoryTableViewController.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 03/10/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController, TweetSearchHistoryUse, DependencyInjectorUse, TweetSearchHistoryDelegate
{
    // MARK: - Vars
    var tweetSearchHistory: TweetSearchHistory? {
        didSet {
            tweetSearchHistory?.delegate = self
        }
    }
    
    var dependencyInjector: DependencyInjector?

    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tweetSearchHistory != nil else {
            return 0
        }
        return tweetSearchHistory!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchesHistoryCellID", for: indexPath)

        if tweetSearchHistory != nil, tweetSearchHistory!.count > indexPath.row  {
            cell.textLabel?.text = tweetSearchHistory![indexPath.row]
        }
        return cell
    }
    
    // MARK: - Table Editing
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tweetSearchHistory != nil, tweetSearchHistory!.count > indexPath.row  {
                tweetSearchHistory!.removeSearchTerm(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SmashTweetTableSegueID" {
            if let tweetsVC = segue.destination as? SmashTweetTableViewController,
                let cell = sender as? UITableViewCell
            {
                dependencyInjector?.inject(to: tweetsVC)
                tweetsVC.searchText = cell.textLabel?.text
            }
        } else if segue.identifier == "PopularitySegueID" {
            if let vc = segue.destination as? PopularityViewController,
                let cell = sender as? UITableViewCell
            {
                dependencyInjector?.inject(to: vc)
                if cell.textLabel?.text != nil {
                    vc.viewModel = TweetPopularityViewModel(withSearchString: cell.textLabel!.text!)
                }
            }
        }
    }
    
    // MARK: - TweetSearchHistoryDelegate
    func tweetSearchHistoryDidChange(tweetSearchHistory: TweetSearchHistory) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
