//
//  InsuranceInformationTVC2.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 11/22/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit

class InsuranceInformationTVC2: UITableViewController {

    @IBOutlet weak var saveButton2: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var segmentControl: AnimatedSegmentSwitch!
    @IBOutlet weak var segmentControl2: AnimatedSegmentSwitch!
    
    @IBOutlet weak var insuranceCarrier: UITextField!
    @IBOutlet weak var insurancePlan: UITextField!
    @IBOutlet weak var insuranceCopay: UITextField!
    @IBOutlet weak var insuranceGroup: UITextField!
    @IBOutlet weak var insuranceId: UITextField!
    @IBOutlet weak var insuranceRelationship: UITextField!
    @IBOutlet weak var insuranceDateOfBirth: UITextField!
    @IBOutlet weak var insuranceLastName: UITextField!
    @IBOutlet weak var insuranceFirstName: UITextField!
    @IBOutlet weak var areYouCoveredLabel: UILabel!
    var areYouCoveredSelected: Bool!
    var whoIsPrimarySelected: Bool!
    var isSecondaryInsurance: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isSecondaryInsurance != nil){
             self.navigationItem.title = "Secondary Insurance"
            areYouCoveredLabel.text = "Do you have secondary insurance?"
        }
        else{
             self.navigationItem.title = "Insurance"
        }
       
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        areYouCoveredSelected = false
        whoIsPrimarySelected = false
        
        insuranceRelationship.isHidden = true
        insuranceDateOfBirth.isHidden = true
        insuranceLastName.isHidden = true
        insuranceFirstName.isHidden = true
        
        segmentControl.items = ["No", "Yes"]
        segmentControl.selectedIndex = 1
        segmentControl.borderWidth = 3.0
        segmentControl.borderColor = .black
        segmentControl.tag = 0
        segmentControl.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        segmentControl2.items = ["I am", "Someone else is"]
        segmentControl2.selectedIndex = 1
        segmentControl2.borderWidth = 3.0
        segmentControl2.borderColor = .black
        segmentControl2.tag = 1
        segmentControl2.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        saveButton.layer.cornerRadius = 20
        saveButton.addTarget(self, action:#selector(saveButtonPressed), for: .touchUpInside)
        
        saveButton2.layer.cornerRadius = 20
        saveButton2.addTarget(self, action:#selector(saveButtonPressed), for: .touchUpInside)
        
        insuranceCarrier =  setupTextField(textField: insuranceCarrier)
        insurancePlan =  setupTextField(textField: insurancePlan)
        insuranceCopay =  setupTextField(textField: insuranceCopay)
        insuranceGroup =  setupTextField(textField: insuranceGroup)
        insuranceId =  setupTextField(textField: insuranceId)
        insuranceRelationship =  setupTextField(textField: insuranceRelationship)
        insuranceDateOfBirth =  setupTextField(textField: insuranceDateOfBirth)
        insuranceLastName =  setupTextField(textField: insuranceLastName)
        insuranceFirstName =  setupTextField(textField: insuranceFirstName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if  (!areYouCoveredSelected){
            return 1
        }
        else{
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.section == 0){
            if (!areYouCoveredSelected){
                return 320.0
            }
            else{
                return 150.0
            }
        }
        else{
            return 540
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
        
        if (sender.tag == 0) {
            if (sender.selectedIndex == 1) {
                areYouCoveredSelected = true
            }
            else{
                areYouCoveredSelected = false
            }
        }
        else{
            if (sender.selectedIndex == 1) {
                whoIsPrimarySelected = true
                
                insuranceRelationship.isHidden = false
                insuranceDateOfBirth.isHidden = false
                insuranceLastName.isHidden = false
                insuranceFirstName.isHidden = false
            }
            else{
                whoIsPrimarySelected = false
                
                insuranceRelationship.isHidden = true
                insuranceDateOfBirth.isHidden = true
                insuranceLastName.isHidden = true
                insuranceFirstName.isHidden = true
            }
        }

        
        self.tableView.reloadData()
    }
    
    func saveButtonPressed(){
        
        if(isSecondaryInsurance == nil){
            HUD.show(.progress)
            delay(2.0) {
                HUD.hide()
                let destinationViewController = UIStoryboard(name: "Forms1", bundle: nil).instantiateViewController(withIdentifier: "InsuranceVC2") as! InsuranceInformationTVC2
                destinationViewController.isSecondaryInsurance = true
                self.navigationController?.show(destinationViewController, sender: self)
            }
        }
        else{
            
            HUD.show(.progress)
            
            // Now some long running task starts...
            delay(2.0) {
                // ...and once it finishes we flash the HUD for a second.
                HUD.flash(.success, delay: 1.0)
               // self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "goToHalfway", sender: self)
            }
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
