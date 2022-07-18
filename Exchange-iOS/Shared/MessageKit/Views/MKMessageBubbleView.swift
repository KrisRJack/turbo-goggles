//
//  MKMessageBubbleView.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/16/22.
//

import UIKit

final class MKMessageBubbleView: UIView {
    
    typealias Color = (background: UIColor, label: UIColor)
    
    public enum Style {
        case primary
        case secondary
        
        public var isPrimary: Bool {
            return self == .primary
        }
    }

    private let padding: CGFloat = 8
    private let style: Style = .primary
    private let primaryColor: Color = Color(background: .darkThemeColor, label: .white)
    private let secondaryColor: Color = Color(background: .secondarySystemBackground, label: .label)
    
    public let label: UILabel = .build { label in
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
    }
    
    init(style: Style) {
        super.init(frame: .zero)
        configureView()
        setUI(forStyle: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureView() {
        addSubview(label)
        label.edges(equalToLayoutMarginIn: self, padding: padding)
    }
    
    public func setUI(forStyle style: Style) {
        label.textColor = (style.isPrimary ? primaryColor : secondaryColor).label
        backgroundColor = (style.isPrimary ? primaryColor : secondaryColor).background
        let roundedCorners: [UIRectCorner] = [.topLeft, .topRight, style.isPrimary ? .bottomLeft : .bottomRight]
        cornerRadius(26, corners: roundedCorners)
    }

}
