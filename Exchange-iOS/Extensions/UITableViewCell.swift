//
//  UITableViewCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 2/26/22.
//

import UIKit

extension UITableViewCell {
    
    public static var reuseIdentifier: String {
        return String(describing: self.self)
    }
    
    var tableView: UITableView? {
        return self.next(of: UITableView.self)
    }

    var indexPath: IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
    
}
