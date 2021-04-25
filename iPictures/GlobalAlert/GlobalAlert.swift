//
//  GlobalAlert.swift
//  iPictures
//
//  Created by Ahdivio Matian Mendes on 23/04/21.
//

import Foundation
import UIKit
import Photos
protocol CallAccessGrant{
    func CallAccessFunc()
}


 final class GAlert {
    static let sharedInstance = GAlert()

    

    
    private var allPhotos : PHFetchResult<PHAsset>? = nil
    
    var ImagesForView:PHFetchResult<PHAsset>?{
        get{
            return allPhotos ?? nil
        }
        set(value){
            allPhotos = value
        }
    }
    
    
    func FetchImageDataFromLibrary(){
        let fetchOptions = PHFetchOptions()
        GAlert.sharedInstance.ImagesForView = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
   
    
   
    
    func alert(message: String, title: String,viewController:UIViewController ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in
            
            self.FetchImageDataFromLibrary()
        })
        alertController.addAction(OKAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
//     func AccessGrantForPhotoLibrary(viewController:UIViewController){
//        PHPhotoLibrary.requestAuthorization({
//               (newStatus) in
//            let fetchOptions = PHFetchOptions()
//            switch newStatus {
//            case .authorized,.limited:
//                print("Good to proceed")
//
//                self.ImagesForView = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//            case .notDetermined:
//                self.alert(message: "PLease provide access to the app to view the images for better functionality", title: "Access Grant", viewController: viewController)
//            case .restricted,.denied:
//
//                self.alert(message: "PLease provide access to the app to view the images for better functionality", title: "Access Grant", viewController: viewController)
//
//            @unknown default:
//                print("Issue noticed")
//
//            }
//        })
//    }
    
   
    
}



