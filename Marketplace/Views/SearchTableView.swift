//
//  SearchTableView.swift
//  Marketplace
//
//  Created by Gaybriella Igno on 11/22/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit
import CoreLocation

class SearchTableView: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var filterChoices = ["", "Most Recent", "Price (High - Low)", "Price (Low - High)", "Item Name (A - Z)", "Item Name (Z - A)"]
    
    let itemModel = ItemModel()
    
    var items = [ItemView]()
    
    var filteredItems = [ItemView]()
    
    var searchParams = false
    var keyWords = ""
    // var sortBy: Int! // Index in filterChoices
    var distanceParameter: Double!
    var minPrice: Double!
    var maxPrice: Double!
    var category: String!
    var rating: Int!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var locationManager = CLLocationManager()
    
    var currentLocation = CLLocation()
    var previousLocation = CLLocation()
    var latitude = 0.0
    var longitude = 0.0
    
    var downloadAssistant: Download! //= Download(withURLString: "http://localhost:8181/items/all?apikey=" + Download.apikey)
    let udownloadAssistant = Download(withURLString: "http://localhost:8181/users/all?apikey=" + Download.apikey)
    var itemsSchema: ItemSchemaProcessor!
    
    var itemDataSource: ItemDataSource? = nil
    var itemsToShow = [Item]()
    
    var usersSchema: UserSchemaProcessor!
    var userDataSource: UserDataSource? = nil
    
    
    //var currentLocation = CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
//        downloadAssistant.download_request()
        
        udownloadAssistant.addObserver(self, forKeyPath: "udataFromServer", options: .old, context: nil)
        udownloadAssistant.download_request()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        locationManager.distanceFilter = 50
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.startUpdatingLocation()
        
        currentLocation = locationManager.location!
        latitude = (currentLocation.coordinate.latitude)
        longitude = (currentLocation.coordinate.longitude)
        print(latitude)
        print(longitude)
        
        searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.text = keyWords
        definesPresentationContext = true
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //        print(downloadAssistant.dataFromServer!)
        if keyPath == "dataFromServer" {
            
            itemsSchema = ItemSchemaProcessor(itemModelJSON: downloadAssistant.dataFromServer! as! [AnyObject])
            print("---------items downloaded-----------")
            let items_returned = itemsSchema.getAllItems()
            
            itemDataSource = ItemDataSource(dataSource: items_returned)
            itemDataSource?.consolidate()
            itemsToShow = (itemDataSource?.items)!
//            if itemsToShow == nil {
//                itemsToShow = [Item]()
//            }
        } else {
            usersSchema = UserSchemaProcessor(userModelJSON: udownloadAssistant.dataFromServer! as! [AnyObject])
            let users_returned = usersSchema.getAllUsers()
            userDataSource = UserDataSource(dataSource: users_returned)
            userDataSource?.consolidate()
        }
        
    }
    
    deinit {
        if downloadAssistant != nil {
            downloadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
        }
        //if udownloadAssistant != nil {
            udownloadAssistant.removeObserver(self, forKeyPath: "dataFromServer", context: nil)
        //}
    }
    
    func setSearchies() {
        if let matchedItems = filterBySearchParams() {
            itemsToShow = matchedItems
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        var address = searchBar.text
        //        getCoordinatesOfAddress(addressString: address!)
        downloadAssistant = Download(withURLString: "http://localhost:8181/items/all")
        downloadAssistant.addObserver(self, forKeyPath: "dataFromServer", options: .old, context: nil)
        downloadAssistant.download_request()
        
        let searchString = searchBar.text
        if var searchText = searchString?.components(separatedBy: " ") {
            for i in 0..<searchText.count {
                searchText[i] = searchText[i].lowercased()
            }
            print(searchText)
            
            let matchedItems = findItemsWithStrings(searchText)
            itemsToShow = matchedItems
            tableView.reloadData()
        }
    }
    func findUserByEmail(_ senderEmail: String) -> User? {
        for user in (userDataSource?.users)! {
            if user.email == senderEmail {
                return user
            }
        }
        return nil
    }
    
    func filterBySearchParams() -> [Item]? {
        var endResults = [Item]()
        
        for item in itemsToShow {
            var count = 0
            var fcount = 0
            if let cat = category, item.item_category?.lowercased() == cat.lowercased() {
                count += 1
                fcount += 1
            }
            if let rate = rating {
                count += 1
                if let seller = findUserByEmail((item.seller_email?.lowercased())!) {
                    if seller.rating > rate {
                        fcount += 1
                    }
                }
            }
            if let lower = minPrice {
                count += 1
                if lower <= item.price {
                    fcount += 1
                }
            }
            if let higher = maxPrice {
                count += 1
                if higher >= item.price {
                    fcount += 1
                }
            }
            if count == fcount, count != 0 {
                endResults.append(item)
            }
        }
        print(endResults)
        return endResults
    }
    
    
    // Ryan???
    func findCoordinatesOfItem(_ item: Item) {
        
    }
    
    func findItemsWithStrings(_ params: [String]) -> [Item] {
        var itemsWithStrings = [Item]()
        var lookList = [Item]()
        if searchParams {
            lookList = filterBySearchParams()!
        } else {
            lookList = itemsToShow
        }
        for item in lookList {
            if var splitTitle = item.item_name?.components(separatedBy: " ") {
                if var splitCategory = item.item_category?.components(separatedBy: " ") {
                    for j in 0..<splitCategory.count {
                        splitTitle.append(splitCategory[j])
                    }
                    for i in 0..<splitTitle.count {
                        splitTitle[i] = splitTitle[i].lowercased()
                    }
                    for param in params {
                        for titleToken in splitTitle {
                            if titleToken.contains(param) { //param == titleToken {
                                if !itemsWithStrings.contains(item) {
                                    itemsWithStrings.append(item)
                                }
                            }
                        }
                    }
                }
            }
        }
        return itemsWithStrings
    }
    
    func getCoordinatesOfAddress(addressString: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    return
            }
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get placemark from location to approximate current address
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) -> Void in
            
            if error != nil {
                print("Error: " + error!.localizedDescription)
                return
            }
            
            let location = locations[0]
            print(location)
            if placemarks!.count > 0 {
                // Store previous & current loactions
                self.previousLocation = self.currentLocation
                self.currentLocation = manager.location!
                
                
                // Upload only address changes to database
                if (self.currentLocation.distance(from: self.previousLocation) > 50) {
                    //                    self.uploadLocation(place)
                }
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // One of
        // kCLErrorLocationUnknown (likely temporary. Keep waiting...)
        // kCLErrorDenied  (User refuses to give you permission to CoreLocation)
        // kCLErrorHeadingFailure  (too much magnetic interference. Keep waiting...)
        print("Error: " + error.localizedDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsToShow.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        //        let item: ItemView
        //        if isFiltering() {
        //            item = filteredItems[indexPath.row]
        //        } else {
        //            item = items[indexPath.row]
        //        }
        //
        //        cell.imageView?.image = itemModel.getMainImage()
        //        cell.textLabel?.text = itemModel.getTitle()
        //        cell.detailTextLabel?.text = String(itemModel.getPrice())
        
        if let itemCell = cell as? ItemTableViewCell {
            let thisItem = itemsToShow[indexPath.row]
            //let thisItem = itemDataSource?.itemAt(indexPath.row)
            print(thisItem)
            itemCell.useItem(thisItem)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("tapped")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredItems = items.filter({(items : ItemView) -> Bool in
            return items.itemCategory.text?.lowercased() == searchText.lowercased()
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let items = itemDataSource?.items
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let item = items![indexPath.row]
                let controller = (segue.destination as! ItemView)
                //controller.detailCandy = item
                controller.hasValues = true
                controller.givenTitle = item.item_name!
                controller.descrip = item.item_description!
                controller.category = item.item_category!
                controller.quantity = Int(item.quantity)
                controller.age = Int(item.minAge)
                controller.price = Float(round(100.0 * item.price)/100.0)
                let defaultPic = [UIImage(named: "PhotoIcon")]
                controller.imageArray = defaultPic as! [UIImage]
                controller.tags = [String()]
                //controller.imageCounterLabel.text = "1"
            }
        }
    }
    
}

extension SearchTableView: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

