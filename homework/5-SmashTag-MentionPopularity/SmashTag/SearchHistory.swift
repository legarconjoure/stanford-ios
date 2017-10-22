//
//  SearchHistory.swift
//  SmashTag
//
//  Created by Dong, Vincent on 10/7/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import Foundation

class SearchHistory {
    
    private static let maxSearches = 100
    
    private static let searchHistoryKey = "searches"
    private static var searches = UserDefaults.standard.array(forKey: searchHistoryKey) as? [String] ?? [String]()
    
    static func save(_ search: String) {
        if searches.count == SearchHistory.maxSearches {
            searches.removeLast()
        }
        searches.insert(search, at: 0)
        UserDefaults.standard.set(searches, forKey: searchHistoryKey)
        UserDefaults.standard.synchronize()
    }
    
    static func read() -> [String] {
        return UserDefaults.standard.array(forKey: searchHistoryKey) as? [String] ?? []
    }
}
