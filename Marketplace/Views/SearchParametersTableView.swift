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
    weak var delegate: SegueHandler?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterPicker: UIPickerView!
    @IBOutlet weak var distanceEntry: UITextField!
    @IBOutlet weak var minPriceEntry: UITextField!
    @IBOutlet weak var maxPriceEntry: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var rating: UILabel!
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
        
        let hiddenCells = [popupCategory, popupDistance, popupPrice, popupRating]
        for cell in hiddenCells {
            cell?.isHidden = true
        }
        toggleDistance.setOn(false, animated: false)
        togglePrice.setOn(false, animated: false)
        toggleRating.setOn(false, animated: false)
        toggleCategory.setOn(false, animated: false)

        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
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
            } else {
                rate = 0
            }
        }
        
    }
    
    @objc func clickedBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeRating(_ sender: UIStepper) {
        rate = Int(sender.value)
        rating.text = String(rate)
    }
    
    // paramsToSearch
    @IBAction func clickedApply(_ sender: UIButton) {
        self.performSegue(withIdentifier: "paramsToSearch", sender: self)
        if let pe = Double(minPriceEntry.text!) {
            lowerPrice = pe
        }
        if let pe = Double(maxPriceEntry.text!) {
            higherPrice = pe
        }
        if let r = Int(rating.text!) {
            rate = r
        }
    }
    
    
    
    // MARK: - UISwitch functions controlling option cells
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

    // MARK: - Table view functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
        if indexPath.row == 9 {
            return 40.0
        }
        return 150.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Picker view functions
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
            cat = categoryChoice.text!
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SearchTableView,
            segue.identifier == "paramsToSearch" {
            vc.searchParams = true
            vc.category = cat.isEmpty ? nil : cat
            vc.minPrice = lowerPrice
            vc.maxPrice = higherPrice
            vc.rating = rate
            vc.keyWords = " "
        }
    }
 

}
