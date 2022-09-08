//
//  InboxViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 8/23/22.
//

import UIKit
import Firebase

final class InboxViewModel {
    
    typealias ReloadDataClosure = () -> Void
    typealias ShowErrorMessageClosure = (_ error: String) -> Void
    
    public struct Actions {
        var reloadData: ReloadDataClosure?
        var showErrorMessage: ShowErrorMessageClosure?
    }
    
    private var actions: Actions
    private var service: InboxServiceType
    
    init(actions: Actions, service: InboxServiceType) {
        self.actions = actions
        self.service = service
    }
    
    public func viewDidLoad() {
        service.listenAndAddDataToDisk { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.actions.showErrorMessage?(error.localizedDescription)
            } else {
                self.actions.reloadData?()
            }
        }
    }
    
    public func numberOfRows(inSection section: Int) -> Int {
        return service.numberOfChannels
    }
    
    public func item(atIndexPath indexPath: IndexPath) -> Channel {
        switch service.channel(atIndex: indexPath.item) {
        case .success(let channel):
            return channel
        case .failure(let error):
            // TODO: This error should be handled in the UI. Not with fatalError().
            fatalError(error.localizedDescription)
        }
    }
    
}
