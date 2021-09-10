//
//  ItemViewModel.swift
//  ImageSearch
//
//  Created by Roman Arriaga on 9/10/21.
//

import Foundation

protocol ItemViewModelType {
    var imageData: Data? { get }
    var title: String { get }
    var width: String { get }
    var height: String { get }
    var published: String { get }
}

class ItemViewModel {
    
    let imageFeed: ImageItem
    
    init(item: ImageItem) {
        self.imageFeed = item
    }
    
}

extension ItemViewModel: ItemViewModelType {
    
    var imageData: Data? {
        return ImageCache.sharedCache.get(url: imageFeed.media.imageLink)
    }
    
    var title: String {
        return self.imageFeed.title
    }
    
    var width: String {
        return self.imageFeed.description.components(separatedBy: " ").filter { str in
            return str.contains("width")
        }.first?.filter({ char in
            return (0...9).contains(Int(String(char)) ?? -1)
        }) ?? "0"
    }
    
    var height: String {
        return self.imageFeed.description.components(separatedBy: " ").filter { str in
            return str.contains("height")
        }.first?.filter({ char in
            return (0...9).contains(Int(String(char)) ?? -1)
        }) ?? "0"
    }
    
    var published: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: self.imageFeed.published)!
        formatter.dateFormat = "MMM d, yyyy"
        
        return formatter.string(from: date)
    }
    
}
