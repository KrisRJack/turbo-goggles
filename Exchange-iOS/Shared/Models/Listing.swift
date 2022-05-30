//
//  Listing.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/29/22.
//

import Foundation

struct Listing {
    
    struct Item {
        var id: String
        var description: String?
        var imageName: String { "\(id).\(String.jpegExtensionFormat)" }
    }
    
    let id: String
    let sold: Bool = false
    let created: Date
    let description: String?
    let userID: String
    let header: String
    let price: Decimal
    let size: String?
    let condition: String?
    let category: String?
    let tags: [String]?
    let items: [Item]
    
    var toDictionary: [String: Any] {
        get {
            return [
                DatabaseKeys.Listing.id.rawValue: id,
                DatabaseKeys.Listing.sold.rawValue: sold,
                DatabaseKeys.Listing.created.rawValue: created,
                DatabaseKeys.Listing.description.rawValue: description ?? NSNull(),
                DatabaseKeys.Listing.userID.rawValue: userID,
                DatabaseKeys.Listing.header.rawValue: header,
                DatabaseKeys.Listing.price.rawValue: price,
                DatabaseKeys.Listing.size.rawValue: size ?? NSNull(),
                DatabaseKeys.Listing.condition.rawValue: condition ?? NSNull(),
                DatabaseKeys.Listing.category.rawValue: category ?? NSNull(),
                DatabaseKeys.Listing.tags.rawValue: tags ?? NSNull(),
                DatabaseKeys.Listing.item_id.rawValue: items.map({ $0.id }),
                DatabaseKeys.Listing.item_imageName.rawValue: items.map({ $0.id }),
                DatabaseKeys.Listing.item_description.rawValue: items.map({ $0.description }),
            ]
        }
    }
    
}
