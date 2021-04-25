//
//  ImageModal.swift
//  iPictures
//
//  Created by Ahdivio Matian Mendes on 22/04/21.
//

import Foundation
import UIKit
class Image:Codable{
    var ImageUrl: Data?
    
    init(imageUrl:Data) {
        self.ImageUrl = imageUrl
    }
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Image").appendingPathExtension("plist")
        
        static func loadImages() -> [Image]? {
            guard let codedImages = try? Data(contentsOf: ArchiveURL) else { return nil }
            
            let propertyListDecoder = PropertyListDecoder()
            return try? propertyListDecoder.decode(Array<Image>.self, from: codedImages)
        }
        
        static func loadSampleImages() -> [Image] {
            return [Image.init(imageUrl: Data())]
        }
        
        static func saveImages(_ images: [Image]) {
            let propertyListEncoder = PropertyListEncoder()
            let codedImages = try? propertyListEncoder.encode(images)
            try? codedImages?.write(to: ArchiveURL, options: .noFileProtection)
        }
    
}

