//
//  StorageService.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/18/22.
//

import FirebaseStorage

public final class StorageService {
    
    public enum StoragePath: String {
        case users = "users"
    }

    public static func reference(_ path: StoragePath) -> StorageReference {
        Storage.storage().reference(withPath: path.rawValue)
    }
    
}

extension StorageReference {
    
    public func child(_ path: StorageService.StoragePath) {
        self.child(path.rawValue)
    }
    
}
