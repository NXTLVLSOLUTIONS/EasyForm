//
//  DentalFormVC.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 11/25/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit

class DentalFormVC: UITableViewController {

    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var dosageAmountTextField: UITextField!
    @IBOutlet weak var medicationNameTextField: UITextField!
    @IBOutlet weak var allergyReactionTextField: UITextField!
    @IBOutlet weak var allergyNameTextField: UITextField!
    @IBOutlet weak var generalHealthTextField: UITextField!
    @IBOutlet weak var concernsTextField: UITextField!
    @IBOutlet weak var reasonTextfield: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var segmentControl: AnimatedSegmentSwitch!
    
    var conditionsArray: NSArray!
    var allergyArray: NSArray!
    var selectionInt: NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Visit Information"

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        conditionsArray =  ["Bad Breath","Bleeding Gums","Blisters on Mouth", "Broken Fillings", "Clicking Jaw" , "Difficulty Chewing", "Difficulty Opening or Closing Mouth", "Dry Mouth", "Jaw Pain", "Loose Teeth", "Mouth Pain", "Mouth Sores", "Swolen Gums", "Teeth Sensitivity to Cold", "Teeth Sensitivity to Heat","Teeth Sensitivity to Pressure", "Teeth Sensitivity to Sweets", "None of the Above"]
        
        allergyArray = ["Adhesive Tape", "Antibiotics" , "Asprin", "Sleeping Pills", "Codine", "Iodine", "Latex", "Local Anesthetics", "Sulfa", "None of the Above"]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        segmentControl.items = ["No", "Yes"]
        segmentControl.selectedIndex = 1
        segmentControl.borderWidth = 3.0
        segmentControl.borderColor = .black
        segmentControl.tag = 0
        segmentControl.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        saveButton.layer.cornerRadius = 20
        saveButton.addTarget(self, action:#selector(saveButtonPressed), for: .touchUpInside)
        
        frequencyTextField =  setupTextField(textField: frequencyTextField)
        dosageAmountTextField =  setupTextField(textField: dosageAmountTextField)
        medicationNameTextField =  setupTextField(textField: medicationNameTextField)
        allergyNameTextField =  setupTextField(textField: allergyNameTextField)
        allergyReactionTextField =  setupTextField(textField: allergyReactionTextField)
        generalHealthTextField =  setupTextField(textField: generalHealthTextField)
        concernsTextField =  setupTextField(textField: concernsTextField)
        reasonTextfield =  setupTextField(textField: reasonTextfield)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectionInt = 1
        }
        else{
            selectionInt = 2
        }
        self.performSegue(withIdentifier: "goToSelection", sender: self)
    }
    
    func saveButtonPressed(){
        self.performSegue(withIdentifier: "goToDentalForm2", sender: self)
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
        
        return textField
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToSelection"{
            let selectionVC = segue.destination as! SelectionTVC;
            
            if selectionInt == 1 {
                selectionVC.selectionArray = conditionsArray
                selectionVC.titleString = "Symptoms"
            }
            else{
                selectionVC.selectionArray = allergyArray
                selectionVC.titleString = "Allergies"
            }
        }
        
 
   
    }

}
