//
//  CheckPhotoAccessProtocol.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/9/24.
//

import Foundation
import Photos

protocol CheckPhotoAccessProtocol: AnyObject {
    func checkAccess()
}

extension CheckPhotoAccessProtocol {
    func checkAccess() {
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .authorized, .limited, .restricted:
            UserDefaults.standard.set(true, forKey: "photoPermissionKey")
        case .notDetermined, .denied:
            UserDefaults.standard.set(false, forKey: "photoPermissionKey")
        @unknown default:
            return
        }
    }
}
