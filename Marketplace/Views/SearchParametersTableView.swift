//
//  SearchParametersTableView.swift
//  Marketplace
//
//  Created by student on 12/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class SearchParametersTableView: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // TODO: Upon submit, check vals and set bool for filter______ vars
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterPicker: UIPickerView!
    
    @IBOutlet weak var distanceEntry: UITextField!

    @IBOutlet weak var minPriceEntry: UITextField!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var maxPriceEntry: UITextField!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var outtaTenLabel: UILabel!
    @IBOutlet weak var ratingStepper: UIStepper!
	
	@IBOutlet weak var toggleDistance: UISwitch!
	@IBOutlet weak var togglePrice: UISwitch!
	@IBOutlet weak var toggleCategory: UISwitch!
	@IBOutlet weak var toggleRating: UISwitch!
    
    @IBOutlet weak var popupDistance: UITableViewCell!
    @IBOutlet weak var popupPrice: UITableViewCell!
    @IBOutlet weak var popupCategory: UITableViewCell!
    @IBOutlet weak var popupRating: UITableViewCell!
    
    private var selectedCellIndexPath: IndexPath?
    
    private let unselectedCellHeight = 50.0
    private var selectedCellHeight = 60.0
    
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
	var sort = false
	var filterDistance = false
	var filterPrice = false
	var filterCategory = false
	var filterRating = false

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
        
        let hiddenCells = [popupCategory, popupDistance, popupPrice, popupRating]
        for cell in hiddenCells {
            cell?.isHidden = true
        }
        
        toggleDistance.setOn(false, animated: false)
        togglePrice.setOn(false, animated: false)
        toggleRating.setOn(false, animated: false)
        toggleCategory.setOn(false, animated: false)
        
        if !noFilters {
            if let loc = locDiameter {
                distanceEntry.text = String(loc)
				filterDistance = true
            }
            if let lp = lowerPrice {
                minPriceEntry.text = String(lp)
				filterPrice = true
            }
            if let hp = higherPrice {
                maxPriceEntry.text = String(hp)
				filterPrice = true
            }
            if let cindex = categories.index(of: cat), !cat.isEmpty {
                categoryPicker.selectRow(cindex, inComponent: 0, animated: false)
                categoryChoice.text = cat
				filterCategory = true
            }
            if let findex = filterChoices.index(of: filter), !filter.isEmpty {
                filterPicker.selectRow(findex, inComponent: 0, animated: false)
                filterChoice.text = filter
				sort = true
            }
            if let r = rate {
                rating.text = String(r)
				filterRating = true
            }
        }
        
    }
    
    @objc func clickedBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
	
	@IBAction func switchForDistance(_ sender: UISwitch) {
        popupDistance.isHidden = !(sender.isOn)
        filterDistance = sender.isOn
        self.tableView.reloadData()
	}
	
	@IBAction func switchForPrice(_ sender: UISwitch) {
        popupPrice.isHidden = !(sender.isOn)
        filterPrice = sender.isOn
        self.tableView.reloadData()
	}
	
	
    @IBAction func switchForCategory(_ sender: UISwitch) {
        popupCategory.isHidden = !(sender.isOn)
        filterCategory = sender.isOn
        self.tableView.reloadData()
    }
    
    @IBAction func switchForRating(_ sender: UISwitch) {
        popupRating.isHidden = !(sender.isOn)
        filterRating = sender.isOn
         self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
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
	
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let titleRows = [1, 3, 5, 7]
        if titleRows.contains(indexPath.row) {
            return 60.0
        }
        if indexPath.row == 2 {
            return toggleDistance.isOn ? 60.0 : 0.0
        }
        if indexPath.row == 4 {
            return togglePrice.isOn ? 60.0 : 0.0
        }
        if indexPath.row == 6 {
            return toggleCategory.isOn ? 90.0 : 0.0
        }
        if indexPath.row == 8 {
            return toggleRating.isOn ? 60.0 : 0.0
        }
        return 150.0
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
