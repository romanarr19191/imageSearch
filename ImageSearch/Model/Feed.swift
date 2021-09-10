//
//  Feed.swift
//  ImageSearch
//
//  Created by Roman Arriaga on 9/10/21.
//

import Foundation

struct Feed: Decodable, Equatable {
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [ImageItem]
}

struct ImageItem: Decodable, Equatable {
    let title: String
    let link: String
    let media: Media
    let description: String
    let published: String
    let author: String
    let tags: String
}

struct Media: Decodable, Equatable {
    let imageLink: String
    
    enum CodingKeys: String, CodingKey {
        case imageLink = "m"
    }
}
