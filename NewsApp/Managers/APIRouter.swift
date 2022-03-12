//
//  NetworkLayer.swift
//  NewsApp
//
//  Created by Leyla Nyssanbayeva on 11.03.2022.
//

import UIKit
import Alamofire

struct APIRouter {
    var type: NewsType
    var page = 1
    private let pageSize = 15
    private let key = "60c21905a1a8441482fd3f8d0397a30f"
//    private let key = "e65ee0938a2a43ebb15923b48faed18d"
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(type: NewsType) {
        self.type = type
    }
    
    enum NewsType {
        case everything
        case topHeadlines
    }
    
    func getURL() -> String {
        switch type {
        case .everything:
            return "https://newsapi.org/v2/everything?q=war&language=en&pageSize=\(pageSize)&page=\(page)&apiKey=\(key)"
        case .topHeadlines:
            return "https://newsapi.org/v2/top-headlines?q=war&pageSize=\(pageSize)&page=\(page)&apiKey=\(key)"
        }
    }
    
    func sendRequest(completion: @escaping (Result<NewsEnvelope, Error>) -> Void) {
        print("SENDREQUEST PAGE: ", page)
        AF.request(self.getURL())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: NewsEnvelope.self, decoder: decoder) { response in
                switch response.result {
                case .success(let value):
                    print("SUCCESS REQUEST")
                    completion(.success(value))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
}
