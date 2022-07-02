//
//  MessagingViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/2/22.
//

import Foundation

final class MessagingViewModel {
    
    typealias GetTextClosure = () -> String?
    typealias ReloadDataClosure = () -> Void
    typealias ShouldPresentErrorClosure = (_ error: String) -> Void
    typealias SetNavigationTitleClosure = (_ setTo: String?) -> Void
    
    public var getText: GetTextClosure?
    public var reloadData: ReloadDataClosure?
    public var error: ShouldPresentErrorClosure?
    public var navigationTitle: SetNavigationTitleClosure?

    private var listing: Listing?
    private var user: UserStore? {
        didSet { reloadData?() }
        willSet { navigationTitle?(newValue?.displayName) }
    }
    
    init(with listing: Listing) {
        loadUser(withID: listing.userID)
    }
    
    private func loadUser(withID id: String) {
        DatabaseService.collection(.users).document(id).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.error?(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot, let data = snapshot.data() else {
                self.error?("User no longer exists.")
                return
            }
            
            self.user = UserStore(withData: data)
        }
    }
    
}
