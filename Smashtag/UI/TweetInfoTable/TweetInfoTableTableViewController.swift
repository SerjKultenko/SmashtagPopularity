//
//  TweetInfoTableTableViewController.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 02/10/2017.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetInfoTableTableViewController: UITableViewController, TweetSearchHistoryUse, DependencyInjectorUse {
 
    var tweetSearchHistory: TweetSearchHistory?
    var dependencyInjector: DependencyInjector?

    var tweetInfoModel: TweetInfoModel? {
        didSet {
            if tweetInfoModel != nil {
                tweetInfoCellFactory = TweetInfoCellFactory(tweetInfoModel: tweetInfoModel!)
            }
            self.tableView.reloadData()
        }
    }
    private var tweetInfoCellFactory: TweetInfoCellFactory?
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TweetInfoCellFactory.kTweetInfoSimpleCellID)

        title = tweetInfoModel?.title
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweetInfoModel?.sectionsNumber ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetInfoModel?.numberOfRows(inSection: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tweetInfoModel?.title(forSection: section) ?? ""
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard tweetInfoModel != nil,
            tweetInfoModel!.sectionsNumber > indexPath.section,
            let objectToShow = tweetInfoModel!.object(forRow: indexPath.row, inSection: indexPath.section),
            let sectionType = tweetInfoModel!.type(forSection: indexPath.section),
            sectionType == .MediaSection,
            let media = objectToShow as? Twitter.MediaItem
        else {
            return UITableViewAutomaticDimension
        }
        let rowRect = tableView.bounds
        return rowRect.width / CGFloat(media.aspectRatio)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tweetInfoCellFactory != nil else {
            return UITableViewCell()
        }
        return tweetInfoCellFactory!.createTweetInfoCell(forRow: indexPath.row, inSection: indexPath.section, inTableView: tableView)
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tweetInfoModel != nil,
            tweetInfoModel!.sectionsNumber > indexPath.section,
            let sectionType = tweetInfoModel!.type(forSection: indexPath.section),
            sectionType != .MediaSection
        else {
            return
        }
        var stringToSearch = tweetInfoModel!.title(forRow: indexPath.row, inSection: indexPath.section)
        if stringToSearch.hasPrefix("@") {
            stringToSearch = String(stringToSearch[stringToSearch.index(after: stringToSearch.startIndex)...])
        }
        if sectionType == .URLsSection {
            if let url = URL(string: stringToSearch) {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TweetWebViewControllerID")
                if let webViewVC = vc as? TweetWebViewController {
                    webViewVC.url = url
                    navigationController?.pushViewController(webViewVC, animated: true)
                }
                //UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SmashTweetTableViewControllerID")
            if let tweetsVC = vc as? SmashTweetTableViewController {
                dependencyInjector?.inject(to: tweetsVC)
                tweetsVC.searchText = stringToSearch
                navigationController?.pushViewController(tweetsVC, animated: true)
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageViewSegueID" {
            if let tweetMediaImageTVC = segue.destination as? TweetMediaImageViewController,
                let cell = sender as? TweetInfoMediaTableViewCell
            {
                tweetMediaImageTVC.mediaImage = cell.mediaImageView.image
                if tweetInfoModel != nil {
                    tweetMediaImageTVC.title = tweetInfoModel!.title + " " + "Media"
                }
                dependencyInjector?.inject(to: tweetMediaImageTVC)
            }
        }
    }

    // MARK: - Go to the Root View Controller
    @IBAction func backwardAction(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

