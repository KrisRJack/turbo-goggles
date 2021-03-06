//
//  Listing.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/29/22.
//

import Firebase
import Foundation

struct Listing {
    
    struct ImageMetadata {
        let id: String
        let description: String?
        var imageName: String { "\(id).\(String.jpegExtensionFormat)" }
        var imageReference: StorageReference { StorageService.reference(.market).child(imageName) }
    }
    
    let id: String
    var sold: Bool = false
    let created: Date
    let description: String?
    let userID: String
    let displayName: String
    let username: String
    let header: String
    let price: Decimal
    let size: String?
    let condition: String?
    let category: String?
    let tags: [String]?
    let metadata: [ImageMetadata]
    
    var userReference: DocumentReference {
        DatabaseService.collection(.users).document(userID)
    }
    
    var userImageReference: StorageReference {
        StorageService.reference(.users).child("\(userID).\(String.jpegExtensionFormat)")
    }
    
    var imageReferences: [StorageReference] {
        metadata.map({ $0.imageReference })
    }
    
    var imageDescriptions: [String?] {
        metadata.map({ $0.description })
    }
    
    var formattedPrice: String {
        guard price != 0 else { return NSLocalizedString("Free", comment: "Subheader") }
        let price = NSDecimalNumber(decimal: price)
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: price) ?? formatter.string(from: 0)!
    }
    
    var toDictionary: [String: Any] {
        get {
            return [
                DatabaseKeys.Listing.id.rawValue: id,
                DatabaseKeys.Listing.sold.rawValue: sold,
                DatabaseKeys.Listing.created.rawValue: created,
                DatabaseKeys.Listing.description.rawValue: description ?? NSNull(),
                DatabaseKeys.Listing.userID.rawValue: userID,
                DatabaseKeys.Listing.displayName.rawValue: displayName,
                DatabaseKeys.Listing.username.rawValue: username,
                DatabaseKeys.Listing.header.rawValue: header,
                DatabaseKeys.Listing.price.rawValue: price,
                DatabaseKeys.Listing.size.rawValue: size ?? NSNull(),
                DatabaseKeys.Listing.condition.rawValue: condition ?? NSNull(),
                DatabaseKeys.Listing.category.rawValue: category ?? NSNull(),
                DatabaseKeys.Listing.tags.rawValue: tags ?? NSNull(),
                DatabaseKeys.Listing.item_id.rawValue: metadata.map({ $0.id }),
                DatabaseKeys.Listing.item_description.rawValue: metadata.map({ $0.description }),
            ]
        }
    }
    
    init(
        id: String,
        sold: Bool = false,
        created: Date,
        description: String?,
        userID: String,
        displayName: String,
        username: String,
        header: String,
        price: Decimal,
        size: String?,
        condition: String?,
        category: String?,
        tags: [String]?,
        metadata: [ImageMetadata]
    ) {
        self.id = id
        self.sold = sold
        self.created = created
        self.description = description
        self.userID = userID
        self.displayName = displayName
        self.username = username
        self.header = header
        self.price = price
        self.size = size
        self.condition = condition
        self.category = category
        self.tags = tags
        self.metadata = metadata
    }
    
    init(withData data: [String: Any]) {
        
        let item_id = data[DatabaseKeys.Listing.item_id.rawValue] as? [String] ?? []
        let item_description = data[DatabaseKeys.Listing.item_description.rawValue] as? [String?] ?? []
        
        var metadata: [ImageMetadata] = []
        for (index, id) in item_id.enumerated() {
            let data = ImageMetadata(id: id, description: item_description[index])
            metadata.append(data)
        }
        
        self.init(
            id: data[DatabaseKeys.Listing.id.rawValue] as? String ?? "",
            sold: data[DatabaseKeys.Listing.sold.rawValue] as? Bool ?? false,
            created: (data[DatabaseKeys.Listing.created.rawValue] as? Timestamp)?.dateValue() ?? Date(),
            description: data[DatabaseKeys.Listing.description.rawValue] as? String,
            userID: data[DatabaseKeys.Listing.userID.rawValue] as? String ?? "",
            displayName: data[DatabaseKeys.Listing.displayName.rawValue] as? String ?? "",
            username: data[DatabaseKeys.Listing.username.rawValue] as? String ?? "",
            header: data[DatabaseKeys.Listing.header.rawValue] as? String ?? "",
            price: (data[DatabaseKeys.Listing.price.rawValue] as? NSNumber ?? 0).decimalValue,
            size: data[DatabaseKeys.Listing.size.rawValue] as? String,
            condition: data[DatabaseKeys.Listing.condition.rawValue] as? String,
            category: data[DatabaseKeys.Listing.category.rawValue] as? String,
            tags: data[DatabaseKeys.Listing.tags.rawValue] as? [String],
            metadata: metadata
        )
    }
    
}
