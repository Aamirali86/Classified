//
//  Box+Ext.swift
//  ClassifiedTests
//
//  Created by Amir on 09/04/2021.
//

import Foundation

extension Classified {
    public static func fake(created_at: String, price: String, name: String) -> Classified {
        Classified(created_at: created_at, price: price, name: name)
    }
}
