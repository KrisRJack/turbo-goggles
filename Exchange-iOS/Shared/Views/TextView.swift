//
//  TextView.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/22/22.
//

import UIKit

@IBDesignable
open class TextView: UITextView {
    
    @IBInspectable
    public var placeholder: String {
        get { placeholderTextView.text }
        set { placeholderTextView.text = newValue }
    }
    
    open override var textAlignment: NSTextAlignment {
        willSet { placeholderTextView.textAlignment = newValue }
    }
    
    open override var font: UIFont? {
        willSet { placeholderTextView.font = newValue }
    }
    
    open override var isScrollEnabled: Bool {
        willSet { placeholderTextView.isScrollEnabled = newValue }
    }
    
    open override var showsVerticalScrollIndicator: Bool {
        willSet { placeholderTextView.showsVerticalScrollIndicator = newValue }
    }
    
    open override var showsHorizontalScrollIndicator: Bool {
        willSet { placeholderTextView.showsHorizontalScrollIndicator = newValue }
    }
    
    private var showPlaceholder: Bool = true {
        willSet { placeholderTextView.isHidden = !newValue }
    }
    
    private lazy var placeholderTextView: UITextView = {
        let textView = UITextView()
        textView.font = font
        textView.isHidden = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        textView.text = "Add text here..."
        textView.textColor = .placeholderText
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUp()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        setUp()
    }
    
    convenience public init() {
        self.init(frame: .zero, textContainer: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        configureConstraints()
        hidePlaceholderIfNeeded()
    }
    
    private func configureConstraints() {
        addSubview(placeholderTextView)
        bringSubviewToFront(placeholderTextView)
        NSLayoutConstraint.activate([
            placeholderTextView.widthAnchor.constraint(equalTo: widthAnchor),
            placeholderTextView.heightAnchor.constraint(equalTo: heightAnchor),
            placeholderTextView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderTextView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func hidePlaceholderIfNeeded() {
        NotificationCenter.default.addObserver(
            forName: UITextView.textDidChangeNotification,
            object: self,
            queue: nil
        ) { [weak self] notification in
            guard let self = self else { return }
            guard let text = self.text else {
                self.showPlaceholder = true
                return
            }
            self.showPlaceholder = text.isEmpty
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
