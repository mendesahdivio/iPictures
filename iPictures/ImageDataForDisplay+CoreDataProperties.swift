//
//  ImageDataForDisplay+CoreDataProperties.swift
//  iPictures
//
//  Created by Ahdivio Matian Mendes on 14/06/21.
//
//

import Foundation
import CoreData


extension ImageDataForDisplay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageDataForDisplay> {
        return NSFetchRequest<ImageDataForDisplay>(entityName: "ImageDataForDisplay")
    }

    @NSManaged public var attribute: UUID?
    @NSManaged public var imageData: String?
    @NSManaged public var isFavourite: Bool

}

extension ImageDataForDisplay : Identifiable {

}
