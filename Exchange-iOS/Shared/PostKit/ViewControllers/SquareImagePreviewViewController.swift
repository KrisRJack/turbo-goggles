//
//  SquareImagePreviewViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/12/22.
//

import UIKit
import FirebaseStorageUI

final class SquareImagePreviewViewController: UICollectionViewController {
    
    private let spacing: CGFloat = 3
    private let imageRefs: [StorageReference]
    
    init(imageReferences: [StorageReference]) {
        imageRefs = imageReferences
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.contentInset = .zero
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.reuseIdentifier)
        collectionView.register(MultipleImageViewCell.self, forCellWithReuseIdentifier: MultipleImageViewCell.reuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(imageRefs.count, 4)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let showNumberLabel = imageRefs.count > 4 && indexPath.item == 3
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: showNumberLabel ? MultipleImageViewCell.reuseIdentifier : ImageViewCell.reuseIdentifier,
            for: indexPath
        )
        (cell as? MultipleImageViewCell)?.setLabel(to: imageRefs.count - 4)
        (cell as? ImageViewCell)?.imageView.sd_setImage(with: imageRefs[indexPath.item], placeholderImage: nil)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SquareImagePreviewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch imageRefs.count {
        case 1:
            return CGSize(width: view.frame.width, height: view.frame.height)
            
        case 2:
            return CGSize(width: (view.frame.width - spacing) / 2, height: view.frame.height)
            
        case 3:
            let smallImageSize = (view.frame.height - spacing) / 2
            guard indexPath.item != 0 else { return CGSize(width: view.frame.width - smallImageSize, height: view.frame.height) }
            return CGSize(width: smallImageSize, height: smallImageSize)
            
        default:
            let smallImageSize = (view.frame.height - (spacing * 2)) / 3
            guard indexPath.item != 0 else { return CGSize(width: view.frame.width - smallImageSize, height: view.frame.height) }
            return CGSize(width: smallImageSize, height: smallImageSize)
            
        }
    }
    
}
