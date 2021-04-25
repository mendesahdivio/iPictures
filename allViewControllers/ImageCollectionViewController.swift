//
//  ImageCollectionViewController.swift
//  iPictures
//
//  Created by Ahdivio Matian Mendes on 24/04/21.
//

import UIKit

private let reuseIdentifier = "ImageCellForCollection"

class ImageCollectionViewController: UICollectionViewController{
let values = GData()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       
       
        // Do any additional setup after loading the view.
    }
    
     override  func viewWillAppear(_ animated: Bool) {
        FetchData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    private func FetchData(){
        DispatchQueue.main.async {
            self.values.FetchImageDataFromLibrary()
            self.collectionView?.reloadData()
        }
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard let count = GData.sharedInstance.ImagesForView?.count else{
            return 0
        }
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
    
        cell.ImageViewForCollection.image = GData.sharedInstance.ImagesForView?[indexPath.row].getAssetThumbnail(isImage: false)
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//      let Controller =  ChangeViewController(SendingviewController: self, identifier: "ImagePreview") as? ImagePreviewViewController
//
//        guard ((Controller) != nil) else {
//            print(Error.self)
//            return
//        }
//
//        Controller?.rawImageAssest = GAlert.sharedInstance.ImagesForView?[indexPath.row]
//        Controller?.fullScreenImagePreview.image = SetValuesForImageCall(index:indexPath)
        
        AlertForOpenOrEdit(indexPath:indexPath)
        
        
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    
    
    
    private func SetValuesForImageCall(index:IndexPath)->UIImage{
        let Image:UIImage?
        
        Image =  GData.sharedInstance.ImagesForView?[index.row].image(contentMode: .aspectFit)
        return Image!
    }
    
    
    private func AlertForOpenOrEdit(indexPath:IndexPath){
        let alertController = UIAlertController(title: title, message: "Select Action", preferredStyle: .actionSheet)
        let OpenAction = UIAlertAction(title: "Open", style: .default, handler: {(action) in
            DispatchQueue.main.async {
                let Controller =  self.ChangeViewController(SendingviewController: self, identifier: "ImagePreview") as? ImagePreviewViewController
                  
                  guard ((Controller) != nil) else {
                      print(Error.self)
                      return
                  }
                  
                  Controller?.rawImageAssest = GData.sharedInstance.ImagesForView?[indexPath.row]
                Controller?.fullScreenImagePreview.image = self.SetValuesForImageCall(index:indexPath)
            }
           
            
        })
        
        let editAction =  UIAlertAction(title: "Edit", style: .default, handler: {(action) in
            DispatchQueue.main.async {
                let Controller =  self.ChangeViewController(SendingviewController: self, identifier: "EditorViewController") as? EditorViewController
                  
                  guard ((Controller) != nil) else {
                      print(Error.self)
                      return
                  }
                  
                  Controller?.ImageAssetAsPhasset = GData.sharedInstance.ImagesForView?[indexPath.row]
                Controller?.editingImageView.image = self.SetValuesForImageCall(index:indexPath)
            }
          
            
        })
        
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alertController.addAction(OpenAction)
        alertController.addAction(editAction)
        alertController.addAction(cancleAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

}


//extension UIViewController{
//    func ChangeViewController(SendingviewController:UIViewController,identifier:String)->UIViewController{
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController =  storyBoard.instantiateViewController(withIdentifier: identifier)
//
//        SendingviewController.present(newViewController,animated:true,completion:nil)
//
//        return newViewController
//    }
//
//
//
//}
