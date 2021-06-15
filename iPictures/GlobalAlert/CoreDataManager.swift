//
//  CoreDataManager.swift
//  iPictures
//
//  Created by Ahdivio Matian Mendes on 14/06/21.
//

import Foundation
import CoreData
import UIKit
final class CoreDataManager{
    static let sharedInstance = CoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "ImageDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
           if let error = error as NSError? {
             fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        })
         
         return container
      }()
       
    func saveContext() throws{
    let context = persistentContainer.viewContext
         if context.hasChanges {
           do {
             try context.save()
          } catch {
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
        }
      }
    
    
    
    
    func SaveData(imageData:String?,isFavourite:Bool){
    
            let context =  CoreDataManager.sharedInstance.persistentContainer.viewContext
                    
                    let entity = NSEntityDescription.entity(forEntityName: "ImageDataForDisplay", in: context)
                    let ImageData = NSManagedObject(entity: entity!, insertInto: context) as? ImageDataForDisplay
                    
                    
            ImageData?.setValue(imageData, forKey: "imageData")
            ImageData?.setValue(isFavourite, forKey: "isFavourite")
           
            
      
                
       
                
              
    }
    
    
    
    func FetchRequest()->[ImageDataForDisplay]{
        var fetchingImage = [ImageDataForDisplay]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageDataForDisplay")
        do {
            let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        fetchingImage = try context.fetch(fetchRequest) as! [ImageDataForDisplay]
        } catch {
        print("Error while fetching the image")
        }
        return fetchingImage
    }
    
    
    
    
    func InsertUpdateForSpecificImage(isFav:Bool,ImageData:String){
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageDataForDisplay")
        fetchRequest.predicate = NSPredicate(format: "imageData = %@", ImageData)
        do{
            let data = try context.fetch(fetchRequest)
            let updatingObeject = data[0] as! NSManagedObject
            updatingObeject.setValue(isFav, forKey: "isFavourite")
            
            
        }catch{
            print(error)
        }
    }
    
}

