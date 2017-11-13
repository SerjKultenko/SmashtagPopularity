//
//  TweetInfoModel.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 02/10/2017.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation
import Twitter

struct TweetInfoModel {
    private let tweet: Twitter.Tweet
    private var sections: [TweetInfoSection] = []
    
    var sectionsNumber: Int {
        get {
            return sections.count
        }
    }
    
    var title: String {
        return tweet.user.name
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard sections.count > section else {
            return 0
        }
        return sections[section].numberOfRows
    }

    func title(forSection section: Int) -> String {
        guard sections.count > section else {
            return ""
        }
        return sections[section].sectionTitle
    }

    func type(forSection section: Int) -> TweetInfoSectionType? {
        guard sections.count > section else {
            return nil
        }
        return sections[section].sectionType
    }

    func title(forRow row: Int, inSection section: Int) -> String {
        guard sections.count > section, sections[section].numberOfRows > row  else {
            return ""
        }
        return sections[section].title(forRow: row)
    }

    func object(forRow row: Int, inSection section: Int) -> Any? {
        guard sections.count > section, sections[section].numberOfRows > row  else {
            return nil
        }
        return sections[section].object(forRow: row)
    }

    init(for tweet: Twitter.Tweet) {
        self.tweet = tweet
        sections = getSections(for: tweet)
    }
    
    private func getSections(for tweet: Twitter.Tweet) -> [TweetInfoSection] {
        var sections: [TweetInfoSection] = []
        if tweet.media.count>0 {
            let section = TweetInfoSection(title: "Media",
                                           type: .MediaSection,
                                           rowsNumber: tweet.media.count,
                                           titleForRowProvider: { (row: Int) -> String in
                                            guard tweet.media.count > row else {
                                                return ""
                                            }
                                            return tweet.media[row].description
            },
                                           objectForRowProvider: { (row: Int) -> Any? in
                                            guard tweet.media.count > row else {
                                                return nil
                                            }
                                            return tweet.media[row]
            })
            sections.append(section)
        }
        if tweet.hashtags.count>0 {
            let section = TweetInfoSection(title: "Hash tags",
                                           type: .HashTagsSection,
                                           rowsNumber: tweet.hashtags.count,
                                           titleForRowProvider: { (row: Int) -> String in
                                            guard tweet.hashtags.count > row else {
                                                return ""
                                            }
                                            return tweet.hashtags[row].keyword
            },
                                           objectForRowProvider: { (row: Int) -> Any? in
                                            guard tweet.hashtags.count > row else {
                                                return nil
                                            }
                                            return tweet.hashtags[row]
            })
            sections.append(section)
        }
        if tweet.urls.count>0 {
            let section = TweetInfoSection(title: "URLs",
                                           type: .URLsSection,
                                           rowsNumber: tweet.urls.count,
                                           titleForRowProvider: { (row: Int) -> String in
                                            guard tweet.urls.count > row else {
                                                return ""
                                            }
                                            return tweet.urls[row].keyword
            },
                                           objectForRowProvider: { (row: Int) -> Any? in
                                            guard tweet.urls.count > row else {
                                                return nil
                                            }
                                            return tweet.urls[row]
            })
            sections.append(section)
        }
            
        // UserMentions
        let titleForRowProvider = { (row: Int) -> String in
            if row == 0 {
                return "@" + tweet.user.screenName
            }
            let userMentionsIndex = row - 1
            guard tweet.userMentions.count > userMentionsIndex else {
                return ""
            }
            return tweet.userMentions[userMentionsIndex].keyword
        }
        
        let objectForRowProvider = { (row: Int) -> Any? in
            if row == 0 {
                return "@" + tweet.user.screenName
            }
            let userMentionsIndex = row - 1
            guard tweet.userMentions.count > userMentionsIndex else {
                return nil
            }
            return tweet.userMentions[userMentionsIndex]
        }
        
        let section = TweetInfoSection(title: "Users",
                                       type: .UserMentionsSection,
                                       rowsNumber: tweet.userMentions.count + 1,
                                       titleForRowProvider: titleForRowProvider,
                                       objectForRowProvider: objectForRowProvider)
        sections.append(section)
        return sections
    }
}
