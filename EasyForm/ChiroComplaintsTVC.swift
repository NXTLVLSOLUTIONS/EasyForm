//
//  ChiroComplaintsTVC.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 12/5/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit

class ChiroComplaintsTVC: UITableViewController {

    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var segmentControl: AnimatedSegmentSwitch!
    @IBOutlet weak var ratePainField: UITextField!
    @IBOutlet weak var worseField: UITextField!
    @IBOutlet weak var betterField: UITextField!
    @IBOutlet weak var howLongField: UITextField!
    
    @IBOutlet weak var segmentControl2: AnimatedSegmentSwitch!
    @IBOutlet weak var ratePainField2: UITextField!
    @IBOutlet weak var worseField2: UITextField!
    @IBOutlet weak var betterField2: UITextField!
    @IBOutlet weak var howLongField2: UITextField!
    
    @IBOutlet weak var segmentControl3: AnimatedSegmentSwitch!
    @IBOutlet weak var ratePainField3: UITextField!
    @IBOutlet weak var worseField3: UITextField!
    @IBOutlet weak var betterField3: UITextField!
    @IBOutlet weak var howLongField3: UITextField!
    
    @IBOutlet weak var segmentControl4: AnimatedSegmentSwitch!
    @IBOutlet weak var ratePainField4: UITextField!
    @IBOutlet weak var worseField4: UITextField!
    @IBOutlet weak var betterField4: UITextField!
    @IBOutlet weak var howLongField4: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.ratePainField.keyboardType = .numberPad
        self.ratePainField2.keyboardType = .numberPad
        self.ratePainField3.keyboardType = .numberPad
        self.ratePainField4.keyboardType = .numberPad
        
        self.navigationItem.title = "Complaints"
              navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.howLongField =  setupTextField(textField: self.howLongField)
        self.ratePainField =  setupTextField(textField: self.ratePainField)
        self.betterField =  setupTextField(textField: self.betterField)
        self.worseField =  setupTextField(textField: self.worseField)
        
        self.howLongField2 =  setupTextField(textField: self.howLongField2)
        self.ratePainField2 =  setupTextField(textField: self.ratePainField2)
        self.betterField2 =  setupTextField(textField: self.betterField2)
        self.worseField2 =  setupTextField(textField: self.worseField2)
        
        self.howLongField3 =  setupTextField(textField: self.howLongField3)
        self.ratePainField3 =  setupTextField(textField: self.ratePainField3)
        self.betterField3 =  setupTextField(textField: self.betterField3)
        self.worseField3 =  setupTextField(textField: self.worseField3)
        
        self.howLongField4 =  setupTextField(textField: self.howLongField4)
        self.ratePainField4 =  setupTextField(textField: self.ratePainField4)
        self.betterField4 =  setupTextField(textField: self.betterField4)
        self.worseField4 =  setupTextField(textField: self.worseField4)
        

        self.segmentControl = setupSegmentControl(segment: self.segmentControl)
         self.segmentControl2 = setupSegmentControl(segment: self.segmentControl2)
         self.segmentControl3 = setupSegmentControl(segment: self.segmentControl3)
         self.segmentControl4 = setupSegmentControl(segment: self.segmentControl4)
        
        self.saveButton.layer.cornerRadius = 20
        self.saveButton.addTarget(self, action:#selector(saveButtonPressed), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "chiroComplaintCell", for: indexPath) as! ChiroComplaintCell
//        
//        cell.howLongField =  setupTextField(textField: cell.howLongField)
//        cell.ratePainField =  setupTextField(textField: cell.ratePainField)
//        cell.whatsBetterField =  setupTextField(textField: cell.whatsBetterField)
//        cell.whatsWorseField =  setupTextField(textField: cell.whatsWorseField)
//        
//        cell.segmentControl.items = ["AM", "PM", "Both"]
//        cell.segmentControl.selectedIndex = 1
//        cell.segmentControl.tag = 0
//        cell.segmentControl.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
//        
//        cell.saveButton.layer.cornerRadius = 20
//        cell.saveButton.addTarget(self, action:#selector(saveButtonPressed), for: .touchUpInside)
//        
//        return cell
//    }
    
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
    
    func setupSegmentControl (segment: AnimatedSegmentSwitch) -> AnimatedSegmentSwitch{
        segment.items = ["AM", "PM", "Both"]
        segment.selectedIndex = 1
        segment.tag = 0
        segment.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        return segment
    }
    
    func saveButtonPressed(){
        self.performSegue(withIdentifier: "goToDentalForm3", sender: self)
    }
    
    
    func segmentValueDidChange(_ sender: AnimatedSegmentSwitch) {
        print("valueChanged: \(sender.selectedIndex)")
        
        
    }
    

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
