//
//  TagSchemaProcessor.swift
//
//  Created by RCG on 12/5/17.
//
import UIKit
import CoreData

class TagSchemaProcessor: NSObject {
    
    let tagsModelJSONString: [AnyObject]
    let coreDataContext = CoreDataCommonMethods()
    
    init(tagsModelJSON: [AnyObject]) {
        tagsModelJSONString = tagsModelJSON
        super.init()
        deleteAllTags()
        processJSON(tagsModelJSON)
    }
    
    func processJSON(_ schema: [AnyObject]) {
        for entity in schema {
            if let result = entity["result"] {
                let objects = result as! [AnyObject]
                processTagsJSON(objects)
            }
        }
    }
    
    func deleteAllTags() {
        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Tags")
        fReq.returnsObjectsAsFaults = false
        do {
            let results = try coreDataContext.managedObjectContext.fetch(fReq)
            for result in results {
                let r = try coreDataContext.managedObjectContext.delete(result as! NSManagedObject)
            }
        } catch {
            abort()
        }
    }
    
    func fetchAllTags() {
        let fReq = NSFetchRequest<NSFetchRequestResult>()
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fReq)
            let tags = result as! [Tags]
            print("Printing titles of all tagss")
            for tag in tags {
                var toPrint = ""
                let title = String(tag.item_id)
                toPrint += title + " "
                print(toPrint)
            }
        } catch {
            print("Unable to fetch all items from the database.")
            abort()
        }
    }
    
    func getAllTags() -> [Tags]? {
        let fReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Tags")
        let sorter = NSSortDescriptor(key: "item_id", ascending: false)
        fReq.sortDescriptors = [sorter]
        fReq.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fReq)
            return result as? [Tags]
        } catch {
            NSLog("Unable to fetch Tags from the database.")
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
    
    func processTagsJSON(_ tagObjects: [AnyObject]) {
        for tagObject in tagObjects {
            if let tagDict = tagObject as? Dictionary<String, AnyObject> {
                let tag = NSEntityDescription.insertNewObject(forEntityName: "Tags", into:
                    coreDataContext.backgroundContext!) as! Tags
                
                if let item_id = tagDict["item_id"] {
                    tag.item_id = (item_id as? Int32)!
                }
                if let _tag = tagDict["tag"] {
                    tag.tag = _tag as? String
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
