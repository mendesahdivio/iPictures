//
//  GallaryAndImageFilesViewController.swift
//  iPictures
//
//  Created by Ahdivio Matian Mendes on 21/04/21.
//

import UIKit
import Photos
import ImageIO
import PhotosUI
class GalleryImageFilesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var backToPreviousView: UIBarButtonItem!
    
    @IBOutlet weak var imageTableView: UITableView!
    var images:PHFetchResult<PHAsset>? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = images?.count else{
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImagesTableViewCell
        cell.imageViewForDisplay.image = images?[indexPath.row].getAssetThumbnail(isImage: false)
        self.SetValuesForCell(cell:cell,image:(images?[indexPath.row])!)
                return cell
    }
    
   
   
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTableView.delegate = self
        imageTableView.dataSource = self
       
        DispatchQueue.main.async {
            self.images =  GAlert.sharedInstance.ImagesForView
            self.imageTableView.reloadData()
        }
       
    }
    

    
//    private func LoadImages(){
//        let fm = FileManager.default
//        let path = Bundle.main.resourcePath!
//        let items = try! fm.contentsOfDirectory(atPath: path)
//
//        for item in items {
//            if item.hasPrefix("nssl") {
//                images.append(item)
//                imageTableView.reloadData()
//            }
//        }
//    }
    
    
    @IBAction func dissmissTheView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func SetValuesForCell(cell:ImagesTableViewCell,image:PHAsset){
        cell.imageViewForDisplay.image = image.getAssetThumbnail(isImage: false)
        
        cell.location.text = image.localIdentifier
        print(image.debugDescription)
    }
    
    
  
    
}





