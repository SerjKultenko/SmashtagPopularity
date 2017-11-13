//
//  DependencyInjector.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 03/10/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import Foundation

class DependencyInjector {
    var tweetSearchHistory: TweetSearchHistory?
    
    func inject(to object: Any) {
        if var objectWithInjector = object as? DependencyInjectorUse {
            objectWithInjector.dependencyInjector = self
        }
        if var objectWithHistory = object as? TweetSearchHistoryUse {
            objectWithHistory.tweetSearchHistory = tweetSearchHistory
        }
    }
}
