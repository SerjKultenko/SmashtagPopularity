//
//  PopularityViewController.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 13/11/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import UIKit
import CoreData

class PopularityViewController: UITableViewController, DependencyInjectorUse {

    var dependencyInjector: DependencyInjector?
    
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.fetchedResultsController?.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = viewModel?.fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = viewModel?.fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].name
        } else {
            return nil
        }
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel?.fetchedResultsController?.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel?.fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetPopularityTableViewCell", for: indexPath)
        
        if let tweetMention = viewModel?.fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = tweetMention.keyword
            cell.detailTextLabel?.text = "\(tweetMention.popularity)"
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tweetSearchVC = segue.destination as? SmashTweetTableViewController,
            let cell = sender as? UITableViewCell
        {
            dependencyInjector?.inject(to: tweetSearchVC)
            tweetSearchVC.searchText = cell.textLabel?.text
        }
    }
}
