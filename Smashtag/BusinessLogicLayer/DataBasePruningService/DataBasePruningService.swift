//
//  DataBasePruningService.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 14/11/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import Foundation
import CoreData

class DataBasePruningService: NSObject, TweetSearchHistoryElementsDeleteDelegate {
    
    fileprivate var persistentContainer: NSPersistentContainer

    // MARK: - TweetSearchHistory Delegate
    func tweetSearchHistoryElementsDidRemove(searchTerms: [String]) {
        persistentContainer.performBackgroundTask { (context) in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchResult")
            
            request.predicate = NSPredicate(format: "searchText IN %@", searchTerms)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            if (try? context.execute(deleteRequest)) != nil {
                try? context.save()
            }
            DataBasePruningService.removeNotConnectedTweets(inContext: context)
            DataBasePruningService.removeNotConnectedTwitterUser(inContext: context)
        }
    }
    
    // MARK: - Supporting functions
    fileprivate static func removeNotConnectedTweets(inContext context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")
        
        request.predicate = NSPredicate(format: "mentions.@count == 0")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        if (try? context.execute(deleteRequest)) != nil {
            try? context.save()
        }
    }

    fileprivate static func removeNotConnectedTwitterUser(inContext context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
        
        request.predicate = NSPredicate(format: "tweets.@count == 0")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        if (try? context.execute(deleteRequest)) != nil {
            try? context.save()
        }
    }

    // MARK: - Initialization
    init(withPersistentContainer persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
}
