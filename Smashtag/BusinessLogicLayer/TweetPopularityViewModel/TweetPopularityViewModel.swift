//
//  TweetPopularityViewModel.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 13/11/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TweetPopularityViewModel {

    var persistentContainer: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    var searchString: String {
        didSet {
            fetchedResultsController = createFetchedResultsController()
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<TweetMention>? = {
        return createFetchedResultsController()
    }()

    // MARK: - Create NSFetchedResultsController
    func createFetchedResultsController() -> NSFetchedResultsController<TweetMention>? {
        guard persistentContainer != nil else { return nil }

        let request: NSFetchRequest<TweetMention> = TweetMention.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false),
            NSSortDescriptor(
                key: "keyword",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        ]

        request.predicate = NSPredicate(format: "(popularity > 1) and (search.searchText like[c] %@)", searchString)

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.persistentContainer!.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    func reloadData() {
        try? fetchedResultsController?.performFetch()
    }

    // MARK: - Initialization
    init(withSearchString searchString:String) {
        self.searchString = searchString
    }
}
