//
//  NewsEnvelope.swift
//  NewsApp
//
//  Created by Leyla Nyssanbayeva on 11.03.2022.
//

import Foundation

struct NewsEnvelope: Decodable {
    var status: String
    var totalResults: Int
    var articles: [News]
    
    init() {
        status = "not ok"
        totalResults = 0
        articles = []
    }
}

