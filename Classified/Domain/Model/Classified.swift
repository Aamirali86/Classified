//
//  Classified.swift
//  Classified
//
//  Created by Amir on 06/04/2021.
//

import Foundation

struct ClassifiedList: Codable {
    let results: [Classified]
}

@objcMembers
class Classified: NSObject, Codable {
    let created_at: String
    let price: String
    let name: String
    let image_ids: [String]
    let image_urls: [String]
    let image_urls_thumbnails: [String]
    
    init(created_at: String,
         price: String,
         name: String,
         image_ids: [String] = [],
         image_urls: [String] = [],
         image_urls_thumbnails: [String] = []) {
        self.created_at = created_at
        self.price = price
        self.name = name
        self.image_ids = image_ids
        self.image_urls = image_urls
        self.image_urls_thumbnails = image_urls_thumbnails
    }
}
