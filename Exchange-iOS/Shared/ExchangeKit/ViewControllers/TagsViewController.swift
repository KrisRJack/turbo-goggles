//
//  TagsViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/24/22.
//

import UIKit

open class TagsViewController: UICollectionViewController {
    
    private let tagsArray: [String]
    
    init(tags: [String]) {
        tagsArray = tags
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        super.init(collectionViewLayout: layout)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TagsCell.self, forCellWithReuseIdentifier: TagsCell.reuseIdentifier)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsArray.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsCell.reuseIdentifier, for: indexPath)
        (cell as? TagsCell)?.cornerRadius(8)
        (cell as? TagsCell)?.color = .darkThemeColor
        (cell as? TagsCell)?.label.text = "#\(tagsArray[indexPath.item])"
        return cell
    }
    
}
