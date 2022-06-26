//
//  ListingDetailsHeaderCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/24/22.
//

import UIKit

final class ListingDetailsHeaderCell: UITableViewCell {
    
    private let view: ListingDetailsHeaderView = .build { view in
        view.backgroundColor = .systemBackground
        view.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(view)
        contentView.backgroundColor = .secondarySystemBackground
        [view.topAnchor.constraint(equalTo: contentView.topAnchor),
         view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
         view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         view.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ].activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: ListingDetailsHeaderView.Model, parentViewController: UIViewController) {
        view.configure(with: model, parentViewController: parentViewController)
    }
    
}
