//
//  SearchParametersTableView.swift
//  Marketplace
//
//  Created by student on 12/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class SearchParametersTableView: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var filterPicker: UIPickerView!
    @IBOutlet weak var distanceEntry: UITextField!
    @IBOutlet weak var minPriceEntry: UITextField!
    @IBOutlet weak var maxPriceEntry: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var ratingStepper: UIStepper!
    
    private var categories = ["", "Home & Garden", "Fashion", "Electronics", "Art & Collectibles", "Auto & Vehicles", "Sporting Goods"]
    var categoryChoice = UILabel()
    var cat = ""
    
    private var filterChoices = ["", "Most Recent", "Price (High - Low)", "Price (Low - High)", "Item Name (A - Z)", "Item Name (Z - A)"]
    var filterChoice = UILabel()
    var filter = ""
    
    var locDiameter: Double! // max 100.0
    var lowerPrice: Double! // min 0.0
    var higherPrice: Double! //max 1000000.00
    var rate: Int!
    
    
    var noFilters = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set dataSources, delegates, targets
        filterPicker.delegate = self
        filterPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        backButton.addTarget(self, action: #selector(clickedBack(_:)), for: .touchUpInside)

        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        if !noFilters {
            if let loc = locDiameter {
                distanceEntry.text = String(loc)
            }
            if let lp = lowerPrice {
                minPriceEntry.text = String(lp)
            }
            if let hp = higherPrice {
                maxPriceEntry.text = String(hp)
            }
            if let cindex = categories.index(of: cat), !cat.isEmpty {
                categoryPicker.selectRow(cindex, inComponent: 0, animated: false)
                categoryChoice.text = cat
            }
            if let findex = filterChoices.index(of: filter), !filter.isEmpty {
                filterPicker.selectRow(findex, inComponent: 0, animated: false)
                filterChoice.text = filter
            }
            if let r = rate {
                rating.text = String(r)
            }
        }
        
    }
    
    @objc func clickedBack(_ sender: UIButton) {
        //print("back")
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
        return 5
    }
    
    // Picker data source and formatting
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == filterPicker {
            return filterChoices.count
        } else {
            return categories.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == categoryPicker {
            let titleData = categories[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Book", size: 17.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
            return myTitle
        } else {
            let titleData = filterChoices[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Book", size: 17.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
            return myTitle
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == filterPicker {
            filterChoice.text = filterChoices[row]
        } else {
            categoryChoice.text = categories[row]
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
