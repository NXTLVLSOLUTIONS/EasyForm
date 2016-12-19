//
//  DentalForm2.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 11/29/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit

class DentalForm2: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var flossTextField: UITextField!
    @IBOutlet weak var brushTextField: UITextField!
    @IBOutlet weak var lastXrayTextField: UITextField!
    @IBOutlet weak var lastExamTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var segmentControl1: AnimatedSegmentSwitch!
    @IBOutlet weak var segmentControl2: AnimatedSegmentSwitch!
    @IBOutlet weak var segmentControl3: AnimatedSegmentSwitch!
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    
    var datePicker1 : UIDatePicker!
    var datePicker2 : UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastExamTextField.delegate = self
        lastXrayTextField.delegate = self
      
        self.flossTextField.keyboardType = .numberPad
        self.brushTextField.keyboardType = .numberPad
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        segmentControl1.items = ["Yes", "No"]
        segmentControl1.selectedIndex = 1
        segmentControl1.borderWidth = 3.0
        segmentControl1.borderColor = .black
        segmentControl1.tag = 0
        segmentControl1.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        segmentControl2.items = ["Yes", "No"]
        segmentControl2.selectedIndex = 1
        segmentControl2.borderWidth = 3.0
        segmentControl2.borderColor = .black
        segmentControl2.tag = 0
        segmentControl2.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        segmentControl3.items = ["Yes", "No"]
        segmentControl3.selectedIndex = 1
        segmentControl3.borderWidth = 3.0
        segmentControl3.borderColor = .black
        segmentControl3.tag = 0
        segmentControl3.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        saveButton.layer.cornerRadius = 20
        saveButton.addTarget(self, action:#selector(saveButtonPressed), for: .touchUpInside)
        
        flossTextField =  setupTextField(textField: flossTextField)
        brushTextField =  setupTextField(textField: brushTextField)
        lastExamTextField =  setupTextField(textField: lastExamTextField)
        lastXrayTextField =  setupTextField(textField: lastXrayTextField)
        
        if (ParseDataFormatter.sharedInstance().providerType == ProviderTypeChiropractor){
            self.navigationItem.title = "Chiro Questions"
            lastExamTextField.placeholder = "Last Chiro Visit"
            lastXrayTextField.placeholder = "Last Doctor Visit"
            brushTextField.placeholder = "How much do you weight?"
            flossTextField.placeholder = "How many hours a night do you sleep?"
            
            
            labelOne.text = "Are you currently pregnant?"
            labelTwo.text = "Have you ever had chiropractic treatment?"
            labelThree.text = "Is your health related to a recent accident?"
            
            flossTextField =  setupTextField(textField: flossTextField)
            brushTextField =  setupTextField(textField: brushTextField)
            lastExamTextField =  setupTextField(textField: lastExamTextField)
            lastXrayTextField =  setupTextField(textField: lastXrayTextField)
        }
        else{
            self.navigationItem.title = "Dental Questions"
        }

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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        if (ParseDataFormatter.sharedInstance().providerType == ProviderTypeChiropractor){
                let header = view as! UITableViewHeaderFooterView
                header.textLabel?.text = "CHIRO QUESTIONS"
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
    
    func saveButtonPressed(){
        if (ParseDataFormatter.sharedInstance().providerType == ProviderTypeChiropractor){
             self.performSegue(withIdentifier: "showComplaints", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "goToDentalForm3", sender: self)
        }
        
    }
    
    
    func segmentValueDidChange(_ sender: AnimatedSegmentSwitch) {
        print("valueChanged: \(sender.selectedIndex)")
        
        
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
        self.pickUpDate(self.lastXrayTextField)
        self.pickUpDate(self.lastExamTextField)
    }

    //MARK:- Function of datePicker
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        self.datePicker1 = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker1.backgroundColor = UIColor.white
        self.datePicker1.datePickerMode = UIDatePickerMode.date
        lastExamTextField.inputView = self.datePicker1
        
        ///
        self.datePicker2 = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker2.backgroundColor = UIColor.white
        self.datePicker2.datePickerMode = UIDatePickerMode.date
        lastXrayTextField.inputView = self.datePicker2
        
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
        
        if(lastExamTextField.isEditing){
            lastExamTextField.text = dateFormatter1.string(from: datePicker1.date)
            lastExamTextField.resignFirstResponder()
        }else{
            lastXrayTextField.text = dateFormatter1.string(from: datePicker2.date)
            lastXrayTextField.resignFirstResponder()
        }
    }
    
    func cancelClick() {
        
        if(lastExamTextField.isEditing){
            lastExamTextField.resignFirstResponder()
        }else{
            lastXrayTextField.resignFirstResponder()
        }
    }
    
}
