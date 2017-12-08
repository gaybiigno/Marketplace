//
//  ItemSchemaProcessor.swift
//
//  Created by RCG on 12/5/17.
//

import UIKit
import CoreData

class ItemSchemaProcessor: NSObject {
    
    let itemModelJSONString: [AnyObject]
    let coreDataContext = CoreDataCommonMethods()
    
    init(itemModelJSON: [AnyObject]) {
        itemModelJSONString = itemModelJSON
        super.init()
        processJSON(itemModelJSON)
    }
    
    func processJSON(_ schema: [AnyObject]) {
        for entity in schema {
            if let result = entity["result"] {
                let objects = result as! [AnyObject]
                    processItemsJSON(objects)
            }
        }
    }
    
    func fetchAllItems() {
        let fReq = NSFetchRequest<NSFetchRequestResult>()
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fReq)
            let items = result as! [Item]
            print("Printing titles of all items")
            for item in items {
                var toPrint = ""
                if let title = item.item_name {
                    toPrint += title + " "
                }
                print(toPrint)
            }
        } catch {
            print("Unable to fetch all items from the database.")
            abort()
        }
    }
    
    func getAllItems() -> [Item]? {
        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let sorter = NSSortDescriptor(key: "item_id", ascending: false)
        fReq.sortDescriptors = [sorter]
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fReq)
            return result as? [Item]
        } catch {
            NSLog("Unable to fetch Artist from the database.")
            abort()
        }
        return nil
    }
    
//    func fetchAllAlbums() {
//        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
//        fReq.returnsObjectsAsFaults = false
//        do {
//            let result = try coreDataContext.managedObjectContext.fetch(fReq)
//            let albums = result as! [Album]
//            print("Printing titles of all albums")
//            for album in albums {
//                var toPrint = ""
//                if let title = album.title {
//                    toPrint += title + " "
//                }
//                if let id = album.album_id {
//                    toPrint += id.stringValue
//                }
//                print(toPrint)
//            }
//        } catch {
//            print("Unable to fetch all albums from the database.")
//            abort()
//        }
//    }
    
    func processItemsJSON(_ itemObjects: [AnyObject]) {
        for itemObject in itemObjects {
            if let itemDict = itemObject as? Dictionary<String, AnyObject> {
                let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into:
                    coreDataContext.backgroundContext!) as! Item
                
                if let item_id = itemDict["item_id"] {
                    item.item_id = (item_id as? Int32)!
                }
                if let seller_email = itemDict["seller_email"] {
                    item.seller_email = seller_email as? String
                }
                if let item_name = itemDict["item_name"] {
                    item.item_name = item_name as? String
                }
                if let item_description = itemDict["item_description"] {
                    item.item_description = item_description as? String
                }
                if let item_category = itemDict["item_category"] {
                    item.item_category = item_category as? String
                }
                if let quantity = itemDict["quantity"] {
                    item.quantity = (quantity as? Int16)!
                }
                if let price = itemDict["price"] {
                    item.price = (price as? Double)!
                }
                if let minAge = itemDict["minAge"] {
                    item.minAge = (minAge as? Int16)!
                }
            }
        }
        coreDataContext.saveContext();
    }

    
//    func fetchArtistWithName(_ name: String) -> [Artist]? {
//        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
//        let pred = NSPredicate(format: "artist_name == %@", name)
//        fReq.predicate = pred
//        fReq.returnsObjectsAsFaults = false
//        do {
//            let result = try coreDataContext.managedObjectContext.fetch(fReq)
//            let artists = result as! [Artist]
//            print("Artist with name: \(name)")
//            for artist in artists {
//                print(artist)
//            }
//            return result as? [Artist]
//        } catch {
//            print("Unable to fetch artist with name \(name) from the database.")
//            abort()
//        }
//        return nil
//
    }
    
//    func fetchAlbumWithID(_ album_id: String) -> [Album]? {
//        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
//        let pred = NSPredicate(format: "album_id == %@", album_id)
//        fReq.predicate = pred
//        fReq.returnsObjectsAsFaults = false
//        do {
//            let result = try coreDataContext.managedObjectContext.fetch(fReq)
//            let albums = result as! [Album]
//            print("Albums with album ID \(album_id)")
//            for album in albums {
//                print(album.title!)
//            }
//
//            return result as? [Album]
//        } catch {
//            print("Unable to fetch artist with name \(album_id) from the database.")
//            abort()
//        }
//        return nil
//
//    }

//    func albumsForArtistWithID(_ artist_id: NSNumber) -> [Album]? {
//        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
//        let pred = NSPredicate(format: "artist_id == %@", artist_id)
//        fReq.predicate = pred
//        fReq.returnsObjectsAsFaults = false
//        do {
//            let result = try coreDataContext.managedObjectContext.fetch(fReq)
//            return result as? [Album]
//        } catch {
//            print("Unable to fetch albums for artist with ID \(artist_id) from the database.")
//            abort()
//        }
//        return nil
//    }

//func getAllItems() -> [Item]? {
//    let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
//    let sorter = NSSortDescriptor(key: "item_name", ascending: false)
//    fReq.sortDescriptors = [sorter]
//    fReq.returnsObjectsAsFaults = false
//            do {
//                let result = try coreDataContext.managedObjectContext.fetch(fReq)
//                return result as? [Artist]
//            } catch {
//                NSLog("Unable to fetch Artist from the database.")
//                abort()
//            }
//            return nil
//}

//    func getAllArtists() -> [Artist]? {
//        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
//        let sorter = NSSortDescriptor(key: "artist_name", ascending: false)
//        fReq.sortDescriptors = [sorter]
//        fReq.returnsObjectsAsFaults = false
//        do {
//            let result = try coreDataContext.managedObjectContext.fetch(fReq)
//            return result as? [Artist]
//        } catch {
//            NSLog("Unable to fetch Artist from the database.")
//            abort()
//        }
//        return nil
//    }

//    func linkArtistAndAlbums(_ artist: Artist, albums: [Album]) {
//        for album in albums {
//            album.artist = artist
//            var alb = artist.albums! as Set
//            alb.insert(album)
//        }
//
//    }

//    func integrateArtistsAndAlbums() {
//        if let artists = getAllArtists() {
//            print("Integrating artists and albums.")
//            for artist in artists {
//                if let albums = albumsForArtistWithID(artist.artist_id!) {
//                    linkArtistAndAlbums(artist, albums: albums)
//                }
//            }
//            coreDataContext.saveContext()
//        }
//
//    }
//}

