//
//  SearchResult.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 13/11/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import CoreData

class SearchResult: NSManagedObject
{
    class func findOrCreateSearchResult(forSearchResult searchResult: String, in context: NSManagedObjectContext) throws -> SearchResult
    {
        let request: NSFetchRequest<SearchResult> = SearchResult.fetchRequest()
        request.predicate = NSPredicate(format: "searchText = %@", searchResult)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "SearchResult.findOrCreateSearchResult -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let entity = SearchResult(context: context)
        entity.searchText = searchResult
        return entity
    }
}

