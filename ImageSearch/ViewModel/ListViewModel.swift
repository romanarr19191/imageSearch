//
//  ListViewModel.swift
//  ImageSearch
//
//  Created by Roman Arriaga on 9/10/21.
//

import Foundation


protocol ListViewModelType {
    var count: Int { get }
    func image(for index: Int, completion: @escaping (Data?) -> Void)
    func itemViewModel(for index: Int) -> ItemViewModelType?
    func getItems(query: String)
    func bind(updateH: @escaping () -> Void)
}

class ListViewModel {
    
    let service: Service
    
    var updateHandler: (() -> Void)?
    
    var imageFeedArr: [ImageItem] = []
    
    init(service: Service) {
        self.service = service
    }
    
}

extension ListViewModel: ListViewModelType {
    
    func bind(updateH: @escaping () -> Void) {
        self.updateHandler = updateH
    }
    
    
    func getItems(query: String) {
        guard !query.isEmpty else {
            self.imageFeedArr = []
            self.updateHandler?()
            return
        }
        
        self.service.requestModel(url: NetworkRequests.feed(query).url) { [weak self] (result: Result<Feed, Error>) in
            switch result {
            case .success(let feed):
                self?.imageFeedArr = feed.items
                self?.updateHandler?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var count: Int {
        return imageFeedArr.count
    }
    
    func image(for index: Int, completion: @escaping (Data?) -> Void) {
        guard index < self.count else {
            completion(nil)
            return
        }
        
        if let imageData = ImageCache.sharedCache.get(url: self.imageFeedArr[index].media.imageLink) {
            completion(imageData)
            return
        }
        let key = self.imageFeedArr[index].media.imageLink
        
        self.service.requestRawData(url: NetworkRequests.image(self.imageFeedArr[index].media.imageLink).url) { result in
            switch result {
            case .success(let imageData):
                ImageCache.sharedCache.set(data: imageData, url: key)
                completion(imageData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func itemViewModel(for index: Int) -> ItemViewModelType? {
        guard index < self.count else { return nil }
        return ItemViewModel(item: self.imageFeedArr[index])
    }
    
}
