//
//  DataStorage.swift
//  NewsApp
//
//  Created by Leyla Nyssanbayeva on 12.03.2022.
//

import UIKit

class DataStorage {
    static let shared = DataStorage()
    
    enum Key: String {
        case news
    }
    
    var savedNews: [News] = []  {
        didSet {
            let data = try? JSONEncoder().encode(savedNews)
            UserDefaults.standard.set(data, forKey: DataStorage.Key.news.rawValue)
        }
    }
    
    init() {
        UserDefaults.standard.register(
            defaults: [DataStorage.Key.news.rawValue: Data()]
        )
        savedNews = getBookmarksValue(key: DataStorage.Key.news.rawValue)
    }
    
    private func getBookmarksValue(key: String) -> [News] {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else{
            return []
        }
        let value = try? JSONDecoder().decode([News].self, from: data)
        return value ?? []
    }
}

