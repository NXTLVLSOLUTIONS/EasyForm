//
//  DentalFormTVC4.swift
//  
//
//  Created by Rahiem Klugh on 11/29/16.
//
//

import UIKit

class DentalFormTVC4: UITableViewController {
    
    @IBOutlet weak var caffeneDrinksTextField: UITextField!
    @IBOutlet weak var explainTextField: UITextField!
    @IBOutlet weak var excerciseDaysTextField: UITextField!
    @IBOutlet weak var drugsPerWeekTextField: UITextField!
    @IBOutlet weak var recreationalDrugsTextField: UITextField!
    @IBOutlet weak var packsTextField: UITextField!
    @IBOutlet weak var drinksPerWeekTextField: UITextField!
    @IBOutlet weak var secPartnersTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var segmentControl1: AnimatedSegmentSwitch!
    @IBOutlet weak var segmentControl2: AnimatedSegmentSwitch!
    @IBOutlet weak var segmentControl3: AnimatedSegmentSwitch!
    @IBOutlet weak var segmentControl4: AnimatedSegmentSwitch!
    @IBOutlet weak var segmentControl5: AnimatedSegmentSwitch!
    @IBOutlet weak var segmentControl6: AnimatedSegmentSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        IQKeyboardManager.shared().isEnabled = false
        
        self.caffeneDrinksTextField.keyboardType = .numberPad
        self.excerciseDaysTextField.keyboardType = .numberPad
        self.drugsPerWeekTextField.keyboardType = .numberPad
        self.packsTextField.keyboardType = .numberPad
        self.drinksPerWeekTextField.keyboardType = .numberPad
        self.secPartnersTextField.keyboardType = .numberPad

        self.navigationItem.title = "Lifestyle"
        
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
        
        segmentControl4.items = ["Yes", "No"]
        segmentControl4.selectedIndex = 1
        segmentControl4.borderWidth = 3.0
        segmentControl4.borderColor = .black
        segmentControl4.tag = 0
        segmentControl4.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        segmentControl5.items = ["Yes", "No"]
        segmentControl5.selectedIndex = 1
        segmentControl5.borderWidth = 3.0
        segmentControl5.borderColor = .black
        segmentControl5.tag = 0
        segmentControl5.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        segmentControl6.items = ["Yes", "No"]
        segmentControl6.selectedIndex = 1
        segmentControl6.borderWidth = 3.0
        segmentControl6.borderColor = .black
        segmentControl6.tag = 0
        segmentControl6.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        
        saveButton.layer.cornerRadius = 20
        saveButton.addTarget(self, action:#selector(saveButtonPressed), for: .touchUpInside)
        
        caffeneDrinksTextField =  setupTextField(textField: caffeneDrinksTextField)
        explainTextField =  setupTextField(textField: explainTextField)
        excerciseDaysTextField =  setupTextField(textField: excerciseDaysTextField)
        drugsPerWeekTextField =  setupTextField(textField: drugsPerWeekTextField)
        recreationalDrugsTextField =  setupTextField(textField: recreationalDrugsTextField)
        packsTextField =  setupTextField(textField: packsTextField)
        drinksPerWeekTextField =  setupTextField(textField: drinksPerWeekTextField)
        secPartnersTextField =  setupTextField(textField: secPartnersTextField)
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
        return 7
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
        self.performSegue(withIdentifier: "goToDentalFormComplete", sender: self)
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

}
