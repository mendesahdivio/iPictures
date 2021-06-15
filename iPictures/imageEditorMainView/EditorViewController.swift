//
//  EditorViewController.swift
//  iPictures
//
//  Created by Ahdivio Matian Mendes on 24/04/21.
//

import UIKit
import Photos
class EditorViewController: UIViewController,UITabBarDelegate,UIScrollViewDelegate {
    let alert = GData()
    var ImageAssetAsPhasset:PHAsset?
    private var isvFlipped:Bool = false
    private var isHFlipped:Bool = false
    private var modifiedImageOfOrientation:UIImage?
    @IBOutlet weak var OptionsTabBar: UITabBar!
    @IBOutlet weak var changedImageView: UIImageView!
    @IBOutlet weak var editingImageView: UIImageView!
    @IBOutlet weak var verticalFlipBtn: UITabBarItem!
    @IBOutlet weak var horizontalFlipBtn: UITabBarItem!
    @IBOutlet weak var cropBtn: UITabBarItem!
    @IBOutlet weak var infoBtn: UITabBarItem!
    @IBOutlet weak var ScrollViewForImage: UIScrollView!
    @IBOutlet weak var scrollViewHolderView: UIView!
    
    @IBOutlet weak var aspectRatioControlView: UIView!
    
    @IBOutlet weak var sixteenToNineAspectRatioBtn: UIButton!
    @IBOutlet weak var fourToThreeAspectRatioBtn: UIButton!
    
    @IBOutlet weak var oneIToOneAspectRatioBtn: UIButton!
    
    private var ImageData:UIImage?
    var editingImage:UIImage? {
        get{
           
            return self.ImageData
        }
        set(value){
            self.ImageData = value
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OptionsTabBar.delegate = self
        ScrollViewForImage.delegate = self
        aspectRatioControlView.isHidden = true
        scrollViewHolderView.isHidden = true
        // Do any additional setup after loading the view.
       
    }
    
    
    private func setImageForImageView(Image:UIImage){
        self.editingImageView.image = Image
    }

    private func PerformVerticalFlip(isVerticallyFlipped:inout Bool){
//        Image.reloadInputViews()
//        Image.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        if !isVerticallyFlipped{
            self.editingImageView.layer.transform = CATransform3DMakeScale(1, -1, 1)
            self.RetrunModifiedCGIImage(outPutuiImage:&(modifiedImageOfOrientation),orientation:.downMirrored)
            isVerticallyFlipped = true
        } else{
            self.editingImageView.layer.transform = CATransform3DMakeScale(1, 1, -1)
            self.RetrunModifiedCGIImage(outPutuiImage:&(modifiedImageOfOrientation),orientation:.upMirrored)
            isVerticallyFlipped = false
        }
    
    
    }
    
    
   private func PerformHorizontalFlip(IsHFliped:inout Bool){
    if !IsHFliped{
        self.editingImageView.layer.transform = CATransform3DMakeScale(-1, 1, 1)
       
        
        self.RetrunModifiedCGIImage(outPutuiImage:&(modifiedImageOfOrientation),orientation:.leftMirrored)
        IsHFliped = true
    }else{
        self.editingImageView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        self.RetrunModifiedCGIImage(outPutuiImage:&(modifiedImageOfOrientation),orientation:.rightMirrored)
        IsHFliped = false
    }
    }
    
    
    private func performCrop(){
        if aspectRatioControlView.isHidden{
            aspectRatioControlView.isHidden = false
        }else{
            aspectRatioControlView.isHidden = true
            scrollViewHolderView.isHidden = true
            editingImageView.isHidden  = false
        }
    }
    
    
    private func ShowAlertForInfo(){
        let alertController = UIAlertController(title: "Image Details", message: generateExif(), preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: .none)
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    private func generateExif()->String?{
        let message = "Image EXIF :" + ImageAssetAsPhasset!.description
        
        
          
        
        
        
        return message
    }
    
    

  
    func tabBar(_ OptionsTabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            PerformVerticalFlip(isVerticallyFlipped: &isvFlipped)
        case 1:
            PerformHorizontalFlip(IsHFliped:&isHFlipped)
        case 2:
            performCrop()
        case 3:
            ShowAlertForInfo()
        default:
            break
        }
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return changedImageView
    }
    
    
    
    @IBAction func ChangeRatiosOfImage(_ sender:UIButton){
        switch sender.tag {
        case 0:
            changingImageRatio(ratio:1.77)
            
        case 1:
            changingImageRatio(ratio:1.33)
        case 2:
            
            changingImageRatio(ratio:1.00)
        default:
            break
        }
        
    }
   
  
    
    
    private func changingImageRatio(ratio:CGFloat){
        let newImage = editingImageView.image?.cropedToRatio(ratio: ratio)
        scrollViewHolderView.isHidden = false
        changedImageView.image = newImage
        editingImageView.isHidden  = true
    }
    
    @IBAction func cancelEdit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func SaveImageButton(_ sender: UIButton) {
        
        if editingImageView.isHidden == false{
            if modifiedImageOfOrientation != nil{
                writeToPhotoAlbum(image: self.modifiedImageOfOrientation!)
            }
          
        }else {
            writeToPhotoAlbum(image: self.changedImageView.image!)
        }
        
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.errorOfSavingImage), nil)
        
           
        }
    
    
    @objc func errorOfSavingImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if error != nil {
            print(error.debugDescription)
            
            alert.alert(message: "Failed Saving", title: "Save incomplete Error:" + error!.localizedDescription, viewController: self)
        }
        else {
            alert.alert(message: "Success Saving", title: "Save Comeplete", viewController: self)
        }
        
        
    }
    
    
}


extension UIImage {

    func cropedToRatio(ratio: CGFloat) -> UIImage? {
        let ImageWidth = size.height * ratio

        let cropRatio = CGRect(x: ((size.width - ImageWidth) / 2.0) * scale,
                              y: 0.0,
                              width: ImageWidth * scale,
                              height: size.height * scale)

        guard let cgImage = cgImage else {
            return nil
        }
        guard let newCgImage = cgImage.cropping(to: cropRatio) else {
            return nil
        }

        return UIImage(cgImage: newCgImage, scale: scale, orientation: imageOrientation)
    }
    
    
    
}


extension EditorViewController {
    func RetrunModifiedCGIImage(outPutuiImage:inout UIImage?,orientation:UIImage.Orientation){
        
        outPutuiImage = UIImage(cgImage: self.editingImageView.image!.cgImage!, scale: self.editingImageView.image! .scale, orientation: orientation)
    }
}
