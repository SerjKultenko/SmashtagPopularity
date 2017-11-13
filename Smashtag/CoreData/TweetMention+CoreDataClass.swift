//
//  TweetMention+CoreDataClass.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 13/11/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//
//

import Foundation
import CoreData


class TweetMention: NSManagedObject {
    class func updateOrCreateTweetMention(withKeyword keyword: String,
                                        forTweetEntity tweetEntity: Tweet,
                                        inSearchRequest searchRequest:SearchResult,
                                        inContext context: NSManagedObjectContext) throws -> TweetMention
    {
        let request: NSFetchRequest<TweetMention> = TweetMention.fetchRequest()
        request.predicate = NSPredicate(format: "(search = %@) and (keyword like[c] %@)", searchRequest, keyword)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
                let entity = matches[0]
                entity.addToTweet(tweetEntity)
                entity.popularity = Int64(entity.tweet?.count ?? 0)
                return entity
            }
        } catch {
            throw error
        }
        
        let entity = TweetMention(context: context)
        entity.keyword = keyword
        entity.search = searchRequest
        entity.addToTweet(tweetEntity)
        entity.popularity = Int64(entity.tweet?.count ?? 0)
        return entity
    }
}
