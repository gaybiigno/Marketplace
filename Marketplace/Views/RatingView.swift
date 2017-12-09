//
//  RatingView.swift
//  Marketplace
//
//  Created by student on 12/8/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class RatingView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var ratePicker: UIPickerView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    private let choices = ["", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    private var rateChoice = UILabel()
    
    private var choseRating = false

    override func viewDidLoad() {
        super.viewDidLoad()
        ratePicker.delegate = self
        ratePicker.dataSource = self
        
        setUp()
    }
    
    func setUp() {
        errorMessage.isHidden = true
        
        // Set up submit button
        submitButton.frame.size = CGSize(width: view.frame.width, height: submitButton.frame.height)
        submitButton.addTarget(self, action: #selector(clickedSubmit(_:)), for: .touchUpInside)
    }
    
    @objc func clickedSubmit(_ sender: UIButton) {
        if (!choseRating) {
            errorMessage.isHidden = true
        }
    }
    
    
    // MARK: - Picker set up
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == ratePicker {
            rateChoice.text = choices[row]
            if !choices[row].isEmpty {
                errorMessage.isHidden = true
                choseRating = true
            } else {
                choseRating = false
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = choices[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Book", size: 17.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        return myTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
