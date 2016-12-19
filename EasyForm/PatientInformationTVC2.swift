//
//  PatientInformationTVC2.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 11/21/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit

class PatientInformationTVC2: UITableViewController {
    
    @IBOutlet weak var emergencyFirstName: UITextField!
    @IBOutlet weak var emergencyCellNumber: UITextField!
    @IBOutlet weak var emergencyLastName: UITextField!
    @IBOutlet weak var emergencyRelationship: UITextField!
    @IBOutlet weak var employmentStatus: UITextField!
    @IBOutlet weak var employerCellNumber: UITextField!
    @IBOutlet weak var employerZipCode: UITextField!
    @IBOutlet weak var employerAddress2: UITextField!
    @IBOutlet weak var employerAddress1: UITextField!
    @IBOutlet weak var employerName: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emergencyCellNumber.keyboardType = .numberPad
        self.employerCellNumber.keyboardType = .numberPad
        self.employerZipCode.keyboardType = .numberPad
        
        self.navigationItem.title = "Patient Information"
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        emergencyFirstName =  setupTextField(textField: emergencyFirstName)
        emergencyLastName =  setupTextField(textField: emergencyLastName)
        emergencyCellNumber =  setupTextField(textField: emergencyCellNumber)
        emergencyRelationship =  setupTextField(textField: emergencyRelationship)
        
        employmentStatus =  setupTextField(textField: employmentStatus)
        employerName =  setupTextField(textField: employerName)
        employerAddress1 =  setupTextField(textField: employerAddress1)
        employerAddress2 =  setupTextField(textField: employerAddress2)
        employerZipCode =  setupTextField(textField: employerZipCode)
        employerCellNumber =  setupTextField(textField: employerCellNumber)
        
        saveButton.layer.cornerRadius = 20
        saveButton.addTarget(self, action:#selector(saveButtonPressed), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
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
    
    
    func saveButtonPressed(){
        
        KVNProgress.show()

        delay(1.0) {
           
        KVNProgress.dismiss()
            
              self.performSegue(withIdentifier: "showInsurance", sender: self)
        }
      
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

}
