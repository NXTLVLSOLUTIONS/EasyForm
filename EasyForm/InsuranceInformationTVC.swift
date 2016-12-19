//
//  InsuranceInformationTVC.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 11/22/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit

class InsuranceInformationTVC: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var segmentControl: AnimatedSegmentSwitch!
    
    @IBOutlet weak var saveButton2: UIButton!
    
    @IBOutlet weak var partyFirstName: UITextField!
    @IBOutlet weak var partyMiddleName: UITextField!
    @IBOutlet weak var partyDateOfBirth: UITextField!
    @IBOutlet weak var partyCellNumber: UITextField!
    @IBOutlet weak var partyZipCode: UITextField!
    @IBOutlet weak var partyState: UITextField!
    @IBOutlet weak var partyCity: UITextField!
    @IBOutlet weak var partyAddress2: UITextField!
    @IBOutlet weak var partyAddress1: UITextField!
    
    
    @IBOutlet weak var partyEmployerName: UITextField!
    @IBOutlet weak var partyEmployerAddress1: UITextField!
    @IBOutlet weak var partyEmployerAddress2: UITextField!
    @IBOutlet weak var partyEmployerCity: UITextField!
    @IBOutlet weak var partyEmployerZipCode: UITextField!
    @IBOutlet weak var partyEmployerState: UITextField!
    
    var isSomeoneElseSelected: Bool!
    var datePicker : UIDatePicker!
    var pickerView1 = UIPickerView()
    var pickerView2 = UIPickerView()
    var pickOption = ["AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY", "AE", "AA", "AP"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        partyDateOfBirth.delegate = self
        pickerView1.delegate = self
        pickerView2.delegate = self
        
        self.partyState.inputView = pickerView1
        self.partyEmployerState.inputView = pickerView2
        
        self.partyCellNumber.keyboardType = .numberPad
        self.partyZipCode.keyboardType = .numberPad
        self.partyEmployerZipCode.keyboardType = .numberPad
        
        self.navigationItem.title = "Insurance"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        isSomeoneElseSelected = false
        
        segmentControl.items = ["I am", "Someone else is"]
        segmentControl.selectedIndex = 1
        segmentControl.borderWidth = 3.0
        segmentControl.borderColor = .black
        segmentControl.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        saveButton.layer.cornerRadius = 20
        saveButton.addTarget(self, action:#selector(saveButtonPressed), for: .touchUpInside)
        
        saveButton2.layer.cornerRadius = 20
        saveButton2.addTarget(self, action:#selector(saveButtonPressed), for: .touchUpInside)
        
        partyFirstName =  setupTextField(textField: partyFirstName)
        partyMiddleName =  setupTextField(textField: partyMiddleName)
        partyDateOfBirth =  setupTextField(textField: partyDateOfBirth)
        partyCellNumber =  setupTextField(textField: partyCellNumber)
        partyZipCode =  setupTextField(textField: partyZipCode)
        partyState =  setupTextField(textField: partyState)
        partyCity =  setupTextField(textField: partyCity)
        partyAddress2 =  setupTextField(textField: partyAddress2)
        partyAddress1 =  setupTextField(textField: partyAddress1)
        partyEmployerName =  setupTextField(textField: partyEmployerName)
        partyEmployerAddress1 =  setupTextField(textField: partyEmployerAddress1)
        partyEmployerAddress2 =  setupTextField(textField: partyEmployerAddress2)
        partyEmployerCity =  setupTextField(textField: partyEmployerCity)
        partyEmployerZipCode =  setupTextField(textField: partyEmployerZipCode)
        partyEmployerState =  setupTextField(textField: partyEmployerState)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if  (!isSomeoneElseSelected){
            return 1
        }
        else{
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.section == 0){
            if (!isSomeoneElseSelected){
                return 320.0
            }
            else{
                return 150.0
            }
        }
        else{
            return 320
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(partyState.isEditing){
            partyState.text = pickOption[row]
        }else{
            partyEmployerState.text = pickOption[row]
        }
    }

    
    func segmentValueDidChange(_ sender: AnimatedSegmentSwitch) {
        print("valueChanged: \(sender.selectedIndex)")
        
        if (sender.selectedIndex == 1) {
            isSomeoneElseSelected = true
        }
        else{
            isSomeoneElseSelected = false
        }
        
        self.tableView.reloadData()
    }
    
    func saveButtonPressed(){
        
        KVNProgress.show()

        delay(1.0) {
            KVNProgress.dismiss()

            self.performSegue(withIdentifier: "showInsurance2", sender: self)
        }
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
    func setupTextField( textField: UITextField) -> UITextField{
        
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(white: 0.5, alpha: 0.2).cgColor
        
        let paddingView = UIView(frame: CGRect(0, 0, 15, textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextFieldViewMode.always
        textField.attributedPlaceholder = NSAttributedString(string:textField.placeholder!,attributes: [NSForegroundColorAttributeName: UIColor.darkGray])

        
        return textField
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpDate(self.partyDateOfBirth)

    }
    
    //MARK:- Function of datePicker
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // MARK:- Button Done and Cancel
    func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter1.timeStyle = .none
        partyDateOfBirth.text = dateFormatter1.string(from: datePicker.date)
        partyDateOfBirth.resignFirstResponder()
    }
    func cancelClick() {
        partyDateOfBirth.resignFirstResponder()
    }

    
}
