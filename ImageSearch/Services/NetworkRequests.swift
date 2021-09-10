//
//  NetworkRequests.swift
//  ImageSearch
//
//  Created by Roman Arriaga on 9/10/21.
//

import Foundation

enum NetworkRequests {
    
    struct NetworkConstants {
        static let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne"
    }
    
    case feed(String)
    case image(String)
    
    var url: URL? {
        
        switch self {
        case .feed(let tagQuery):
            guard var urlComponents = URLComponents(string: NetworkConstants.baseURL) else {
                return nil
            }
            // format=json&nojsoncallback=1
            urlComponents.queryItems = [URLQueryItem(name: "tags", value: tagQuery), URLQueryItem(name: "format", value: "json"), URLQueryItem(name: "nojsoncallback", value: "1")]
            return urlComponents.url
        case .image(let urlString):
            return URL(string: urlString)
        }
        
    }
}
