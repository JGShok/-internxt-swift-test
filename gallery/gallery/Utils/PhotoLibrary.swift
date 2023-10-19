//
//  PhotoLibrary.swift
//  gallery
//
//  Created by Femer Garcia on 19/10/23.
//

import Photos

class PhotoLibrary {

    static func checkAuthorization() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            debugPrint("Photo library access authorized.")
            return true
        case .notDetermined:
            debugPrint("Photo library access not determined.")
            return await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
        case .denied:
            debugPrint("Photo library access denied.")
            return false
        case .limited:
            debugPrint("Photo library access limited.")
            return false
        case .restricted:
            debugPrint("Photo library access restricted.")
            return false
        @unknown default:
            return false
        }
    }
}
