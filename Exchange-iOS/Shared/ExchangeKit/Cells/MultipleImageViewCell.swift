//
//  MultipleImageViewCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/12/22.
//

import UIKit

final class MultipleImageViewCell: ImageViewCell {
    
    let label: UILabel = .build { label in
        label.textColor = .white
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.backgroundColor = .transparentImageLabel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        contentView.addSubviews(label)
        contentView.bringSubviewToFront(label)
        [label.topAnchor.constraint(equalTo: contentView.topAnchor),
         label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ].activate()
    }
    
    public func setLabel(to number: Int) {
        label.text = "+\(number)"
    }
    
}
