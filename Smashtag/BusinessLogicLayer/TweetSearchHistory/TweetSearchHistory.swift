//
//  TweetSearchHistory.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 03/10/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import Foundation

protocol TweetSearchHistoryDelegate: NSObjectProtocol {
    func tweetSearchHistoryDidChange(tweetSearchHistory: TweetSearchHistory)
}

class TweetSearchHistory: Codable {
    private var searches:[String] = [] {
        didSet {
            saveHistory()
            delegate?.tweetSearchHistoryDidChange(tweetSearchHistory: self)
        }
    }
    
    weak var delegate: TweetSearchHistoryDelegate? = nil
    
    private enum CodingKeys: String, CodingKey {
        case searches
    }
    
    init() {
    }
    
    init?(data: Data) {
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(TweetSearchHistory.self, from: data) {
            searches = decoded.searches
        } else {
            return nil
        }
    }
    
    var count: Int {
        return searches.count
    }
    
    subscript(index: Int) -> String {
        guard searches.count > index else {
            return ""
        }
        return searches[index]
    }
    
    func add(searchTerm term: String) {
        // Do not add string which already is in the array
        let index = searches.index { (string) -> Bool in
            return term.localizedCaseInsensitiveCompare(string) == .orderedSame
        }
        guard index == nil else {
            return
        }
        if searches.count > 99 {
                searches.removeLast(searches.count - 99)
        }
        searches.insert(term, at: 0)
    }
    
    func removeSearchTerm(at position: Int) {
        guard searches.count > position else {
            return
        }
        searches.remove(at: position)
    }

    private let kTweetSearchesHistoryKey = "TweetSearchesHistoryKey"

    func saveHistory() {
        UserDefaults.standard.set(encode(), forKey: kTweetSearchesHistoryKey)
        UserDefaults.standard.synchronize()
    }
    
    func loadHistory()->Bool {
        guard let historyData = UserDefaults.standard.object(forKey: kTweetSearchesHistoryKey) as? Data else {
                return false
        }
        load(from: historyData)
        
        return true
    }
    
    private func load(from data: Data) {
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(TweetSearchHistory.self, from: data) {
            searches = decoded.searches
        }
    }
    
    private func encode() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
