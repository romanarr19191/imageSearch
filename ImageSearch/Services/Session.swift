//
//  Session.swift
//  ImageSearch
//
//  Created by Roman Arriaga on 9/10/21.
//

import Foundation

protocol Session {
    func fetch(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: Session {
    
    func fetch(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = self.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }

}
