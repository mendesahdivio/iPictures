//
//  ImagePreviewViewController.swift
//  iPictures
//
//  Created by Ahdivio Matian Mendes on 24/04/21.
//

import UIKit
import Photos
class ImagePreviewViewController: UIViewController {

    @IBOutlet weak var backToView: UIButton!
    var rawImageAssest: PHAsset?
    
    @IBOutlet weak var editButton: UIButton!
    
    
    @IBOutlet weak var fullScreenImagePreview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
  
    @IBAction func dismissTheView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func EditButtonClicked(_ sender: UIButton) {
        DispatchQueue.main.async{ [self] in
            let Controller =  self.ChangeViewController(SendingviewController: self, identifier: "EditorViewController") as? EditorViewController
              
            Controller?.editingImageView.image = rawImageAssest?.image(contentMode: .aspectFit)
            Controller?.ImageAssetAsPhasset = rawImageAssest
             
        }
     
    }
    

}

extension UIViewController{
    func ChangeViewController(SendingviewController:UIViewController,identifier:String)->UIViewController{
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController =  storyBoard.instantiateViewController(withIdentifier: identifier)
       
        SendingviewController.present(newViewController,animated:true,completion:nil)
        
        return newViewController
    }
    
    
    
}



