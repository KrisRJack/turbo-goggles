//
//  EditImageCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/22/22.
//

import UIKit

protocol EditImageCellDelegate {
    func textViewDidChange(_ textView: UITextView, at indexPath: IndexPath)
    func textViewDidBeginEditing(_ textView: UITextView, at indexPath: IndexPath)
}

final class EditImageCell: UITableViewCell {
    
    var delegate: EditImageCellDelegate?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            scaledHeightImageView,
            textView
        ])
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 8, right: 12)
        return stackView
    }()
    
    private let scaledHeightImageView: ScaledHeightImageView = .build { imageView in
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.3
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.separator.cgColor
    }
    
    private lazy var textView: TextView = {
        let textView = TextView()
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 18)
        textView.placeholder = "Describe this item..."
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureConstraints()
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        contentView.addSubviews(stackView)
        [stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
         stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
         textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ].activate()
    }
    
    public func setListingImage(with object: ListingImage) {
        textView.text = object.description
        scaledHeightImageView.image = UIImage(data: object.imageData)
    }
    
}

extension EditImageCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let indexPath = indexPath else { return }
        delegate?.textViewDidBeginEditing(textView, at: indexPath)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let indexPath = indexPath else { return }
        delegate?.textViewDidChange(textView, at: indexPath)
    }
    
}
