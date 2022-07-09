//
//  TagsCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/25/22.
//

import UIKit

final class TagsCell: UICollectionViewCell {
    
    public var color: UIColor {
        get { return label.textColor }
        set {
            label.textColor = newValue
            contentView.backgroundColor = .systemGray5
        }
    }
    
    let label: UILabel = .build { label in
        label.font = .systemFont(ofSize: 14, weight: .heavy)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        color = .label
        contentView.addSubviews(label)
        [label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
         label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
         label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
         label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ].activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
