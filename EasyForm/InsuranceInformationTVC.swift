//
//  InsuranceInformationTVC.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 11/22/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit

class InsuranceInformationTVC: UITableViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        HUD.show(.progress)
        delay(1.0) {
            HUD.hide()
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
        
        return textField
    }

}
