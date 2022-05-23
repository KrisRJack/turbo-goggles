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
    var images: ReferenceArray<Data>
    var navigationDelegate: ListingEditImageNavigationDelegate?
    
    init(images: ReferenceArray<Data>) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reloadDataIfNeeded()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditImageCell.reuseIdentifier, for: indexPath)
        (cell as? EditImageCell)?.textViewDelegate = self
        (cell as? EditImageCell)?.setImage(with: images.objects[indexPath.item])
        return cell
    }
    
    private func reloadDataIfNeeded() {
        guard !didReload else { return }
        tableView.reloadData()
        didReload = true
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(EditImageCell.self, forCellReuseIdentifier: EditImageCell.reuseIdentifier)
    }
    
    private func configureNavigationBar() {
        title = "Edit Photos"
    }
    
}

extension ListingEditImageViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
