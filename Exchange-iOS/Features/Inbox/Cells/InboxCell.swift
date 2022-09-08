//
//  InboxCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 8/26/22.
//

import UIKit

final class InboxCell: UITableViewCell {
    
    let view = InboxView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(view)
        view.edges(equalToLayoutMarginIn: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Channel) {
        view.configure(with: model)
    }
    
}
