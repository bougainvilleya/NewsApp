//
//  NewsItem.swift
//  NewsApp
//
//  Created by Leyla Nyssanbayeva on 10.03.2022.
//

import Foundation
import UIKit

struct News: Encodable, Decodable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}
