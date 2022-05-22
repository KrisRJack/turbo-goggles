//
//  ListingPhotosViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/21/22.
//

import UIKit

protocol ListingPhotosDelegate {
    func shouldGetMedia()
}

final class ListingPhotosViewController: UICollectionViewController {
    
    var delegate: ListingPhotosDelegate?
    private var viewModel: ListingPhotosViewModel!
    
    init(imageData: ReferenceArray<Data>) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        viewModel = ListingPhotosViewModel(imageData: imageData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.backgroundColor = .clear
        collectionView.dragInteractionEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        collectionView.register(ListingImageCell.self, forCellWithReuseIdentifier: ListingImageCell.reuseIdentifier)
        collectionView.register(ListingEmptyImageCell.self, forCellWithReuseIdentifier: ListingEmptyImageCell.reuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !viewModel.imageArrayIsEmpty else { return 1 }
        return viewModel.imageCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard !viewModel.imageArrayIsEmpty else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ListingEmptyImageCell.reuseIdentifier, for: indexPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListingImageCell.reuseIdentifier, for: indexPath)
        (cell as? ListingImageCell)?.setImage(data: viewModel.item(at: indexPath.item))
        (cell as? ListingImageCell)?.deleteButtonPressed = ({ [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteItem(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        })
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.imageArrayIsEmpty {
            delegate?.shouldGetMedia()
        }
    }
    
}

extension ListingPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentTopBottomInset = collectionView.contentInset.top + collectionView.contentInset.bottom
        let contentLeftRightInset = collectionView.contentInset.left + collectionView.contentInset.right
        guard !viewModel.imageArrayIsEmpty else {
            return CGSize(width: view.frame.width - contentLeftRightInset, height: view.frame.height - contentTopBottomInset)
        }
        return CGSize(width: 150, height: view.frame.height - contentTopBottomInset)
    }
    
}

// MARK: - UICollectionViewDragDelegate


extension ListingPhotosViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard !viewModel.imageArrayIsEmpty else { return [] }
        let itemProvider = NSItemProvider(object: "\(indexPath)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = viewModel.item(at: indexPath.item)
        return [dragItem]
    }
    
}

// MARK: - UICollectionViewDropDelegate


extension ListingPhotosViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return .init(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return .init(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        guard !viewModel.imageArrayIsEmpty else { return }
        
        var destinationIndexPath: IndexPath!
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(row: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destingationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
        
    }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destingationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                
                viewModel.deleteItem(at: sourceIndexPath.item)
                if let data = item.dragItem.localObject as? Data {
                    viewModel.insert(item: data, at: destingationIndexPath.item)
                }
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destingationIndexPath])
                
            }, completion: nil)
            
            coordinator.drop(item.dragItem, toItemAt: destingationIndexPath)
        }
    }
    
}
