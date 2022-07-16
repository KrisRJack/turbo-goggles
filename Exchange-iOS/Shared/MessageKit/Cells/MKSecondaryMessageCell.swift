//
//  MKMessageBubbleCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/15/22.
//

import UIKit

final class MKMessageCell: UITableViewCell {
    
    enum Mes
    
    public let profileImageView: UIImageView = .build { imageView in
        
    }
    
    public let bubbleView: MKMessageBubbleView = .build { view in
        
    }
    
    public let timeLabel: UILabel = .build { label in
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(forUser: ) {
        
    }
    
}
