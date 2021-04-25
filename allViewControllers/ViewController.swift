//
//  ViewController.swift
//  iPictures
//
//  Created by Ahdivio Matian Mendes on 21/04/21.
//

import UIKit
import Photos

class ViewController: UIViewController ,CallAccessGrant{
    func CallAccessFunc() {
        AccessGrantForPhotoLibrary()
    }
  
    var allPhotos : PHFetchResult<PHAsset>? = nil
    @IBOutlet weak var galleryBttn: UIButton!
    @IBOutlet weak var viewAllFolderBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructorForViewDefaultValues()
        guard UserDefaults.standard.value(forKey: "GrantAccess") == nil else{
            let fetchOptions = PHFetchOptions()
            GData.sharedInstance.ImagesForView = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            changeView(viewNumeber:0)
            return
        }
        AccessGrantForPhotoLibrary()
    }

    
    
    
    
    private func constructorForViewDefaultValues(){
        setButtonsviewradius(button: galleryBttn)
        setButtonsviewradius(button: viewAllFolderBttn)
    }

    
    
    private func setButtonsviewradius(button:UIButton){
        button.layer.cornerRadius = 25
        
    }
    
    @IBAction func ButtonsClicked(sender:UIButton!){
        
        switch sender.tag {
        case 0:
            changeView(viewNumeber:0)
            break
        case 1:
            GData.infoAlert(view: self)
            break
        default:
            print("Unable to get button tag value")
        }
    }
    
    
    private func changeView(viewNumeber:Int){
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController =  storyBoard.instantiateViewController(withIdentifier: "selctionTabBar")  as! GalleryOrImageFilesTabViewController
            newViewController.selectedIndex = viewNumeber
            self.present(newViewController,animated:true,completion:nil)
        }
       
    }
    
    
   
    
    public func AccessGrantForPhotoLibrary(){
        PHPhotoLibrary.requestAuthorization({
               (newStatus) in
            let fetchOptions = PHFetchOptions()
            
            switch newStatus {
            case .authorized,.limited:
                print("Good to proceed")
               
                GData.sharedInstance.ImagesForView = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                UserDefaults.standard.setValue("AccessGranted", forKey: "GrantAccess")
            case .notDetermined:
                DispatchQueue.main.async {
                    self.alert(message: "Please provide access to photos as app cant access photos to perform actions", title: "No Access granted",viewController: self)
                }
               
            case .denied:
                
                DispatchQueue.main.async {
                    self.alert(message: "Please provide access to photos as app cant access photos to perform actions", title: "No Access granted",viewController: self)
                }
                
            case .restricted:
                GData.sharedInstance.ImagesForView = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                UserDefaults.standard.setValue("AccessGranted", forKey: "GrantAccess")
            
            @unknown default:
                print("Issue noticed")
                
            }
        })
    }
    
    
    
    
    
    func alert(message: String, title: String,viewController:UIViewController ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in
            
            self.AccessGrantForPhotoLibrary()
        })
        alertController.addAction(OKAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

extension PHAsset {
    func getAssetThumbnail(isImage:Bool) -> UIImage {
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    var thumbnail = UIImage()
        
    option.isSynchronous = false
        if !isImage{
            manager.requestImage(for: self,
                                 targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                                 contentMode: .aspectFit,
                                 options: option,
                                 resultHandler: {(result, info) -> Void in
                                    guard result != nil else {
                                        return
                                    }
                                    thumbnail = result!
                                    
                                 })
        } else{
//            manager.requestImageData(for: <#T##PHAsset#>, options: <#T##PHImageRequestOptions?#>, resultHandler: <#T##(Data?, String?, UIImage.Orientation, [AnyHashable : Any]?) -> Void#>)
        }
    
    
    
    return thumbnail
    }
    
    
    func image( contentMode: PHImageContentMode) -> UIImage {
            var thumbnail = UIImage()
            let imageManager = PHCachingImageManager()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        option.resizeMode = .fast
            imageManager.requestImage(for: self, targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight), contentMode: contentMode, options: option, resultHandler: { image, _ in
                thumbnail = image!
            })
            return thumbnail
        }
    
    
    
    func getImageFileName() ->String {
        
        var originalFilename: String? {
                return PHAssetResource.assetResources(for: self).first?.originalFilename
            }
        
       
        
        return ""
    }
    
    
    
    func metadata(_ completion: @escaping (CGImageMetadata?) -> Void) {
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = true

        requestContentEditingInput(with: options) { input, _ in
            guard let url =  input?.fullSizeImageURL,
                let image = CIImage(contentsOf: url) else {
                completion(nil)
                return
            }
            let properties = image.properties
            let tiffDict = properties["{TIFF}"] as? [String: Any]
            let make = tiffDict?["Make"] as? String ?? ""
            completion((make as! CGImageMetadata))
        }
    }
    
    
    
   


}

