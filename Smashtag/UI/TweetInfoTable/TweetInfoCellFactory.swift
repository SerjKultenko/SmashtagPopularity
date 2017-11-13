//
//  TweetInfoCellFactory.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 02/10/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import Foundation
import UIKit
import Twitter

class TweetInfoCellFactory {
    var tweetInfoModel: TweetInfoModel?

    static let kTweetInfoSimpleCellID = "kTweetInfoSimpleCellID"
    
    init(tweetInfoModel: TweetInfoModel) {
        self.tweetInfoModel = tweetInfoModel
    }
    
    func createTweetInfoCell(forRow row: Int, inSection section: Int, inTableView tableView: UITableView) -> UITableViewCell {
        guard tweetInfoModel != nil,
            tweetInfoModel!.sectionsNumber > section,
            let objectToShow = tweetInfoModel!.object(forRow: row, inSection: section),
            let sectionType = tweetInfoModel!.type(forSection: section) else
        {
            return UITableViewCell()
        }
        switch sectionType {
        case .MediaSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetImageViewCellID", for: IndexPath(row: row, section: section))
            if let mediaInfoCell = cell as? TweetInfoMediaTableViewCell,
                let media = objectToShow as? Twitter.MediaItem {
            mediaInfoCell.mediaURL = media.url
                let queue = DispatchQueue.global(qos: .utility)
                queue.async{
                    if let data = try? Data(contentsOf: media.url){
                        DispatchQueue.main.async {
                            if mediaInfoCell.mediaURL == media.url {
                                mediaInfoCell.mediaImageView.image = UIImage(data: data)
                            }
                        }
                    }
                }
            }
            return cell
        case .HashTagsSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: TweetInfoCellFactory.kTweetInfoSimpleCellID, for: IndexPath(row: row, section: section))
            if let mention = objectToShow as? Twitter.Mention {
                cell.textLabel?.text = mention.keyword
            }
            return cell
        case .URLsSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: TweetInfoCellFactory.kTweetInfoSimpleCellID, for: IndexPath(row: row, section: section))
            if let mention = objectToShow as? Twitter.Mention {
                cell.textLabel?.text = mention.keyword
            }
            return cell
        case .UserMentionsSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: TweetInfoCellFactory.kTweetInfoSimpleCellID, for: IndexPath(row: row, section: section))
            if let mention = objectToShow as? Twitter.Mention {
                cell.textLabel?.text = mention.keyword
            } else if let mentionString = objectToShow as? String {
                cell.textLabel?.text = mentionString
            }
            return cell
        }
    }
}
