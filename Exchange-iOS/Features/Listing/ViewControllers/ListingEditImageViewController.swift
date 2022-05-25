//
//  ListingEditImageViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/22/22.
//

import UIKit

protocol ListingEditImageNavigationDelegate {
    
}

final class ListingEditImageViewController: UITableViewController {
    
    var didReload = false
    var viewModel: ListingEditImageViewModel!
    var navigationDelegate: ListingEditImageNavigationDelegate?
    
    init(images: ReferenceArray<ListingImage>) {
        super.init(nibName: nil, bundle: nil)
        viewModel = ListingEditImageViewModel(images: images)
        viewModel.reloadData = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Photos"
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditImageCell.reuseIdentifier, for: indexPath)
        (cell as? EditImageCell)?.delegate = self
        (cell as? EditImageCell)?.setListingImage(with: viewModel.object(at: indexPath.item))
        return cell
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(EditImageCell.self, forCellReuseIdentifier: EditImageCell.reuseIdentifier)
    }
    
}

extension ListingEditImageViewController: EditImageCellDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView, at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewDidChange(_ textView: UITextView, at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
        viewModel.set(text: textView.text, forObjectAt: indexPath.item)
    }
    
}
