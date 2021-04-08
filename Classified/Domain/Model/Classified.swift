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
}
