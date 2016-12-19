//
//  DentalFormCompleteVC.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 11/29/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit

class DentalFormCompleteVC: UIViewController {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        verifyButton.layer.cornerRadius = 5
        verifyButton.layer.borderWidth = 1.0
        verifyButton.layer.borderColor = UIColor.darkGray.cgColor
        
        saveButton.layer.cornerRadius = 20
        saveButton.addTarget(self, action:#selector(saveButtonPressed), for: .touchUpInside)
        
        verifyButton.addTarget(self, action:#selector(verifyButtonPressed), for: .touchUpInside)
        
        checkImage.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveButtonPressed(){
        
        let signatureVC = SignatureVC()
        signatureVC.showSignature()
        
//                HUD.flash(.success, delay: 1.0)
//        DispatchQueue.main.async(execute: {
//             //self.dismiss(animated: true, completion: nil)
//            self.navigationController?.popToRootViewController(animated: true)
//            return
//        })
     
    }
    
    func verifyButtonPressed(){
        if checkImage.isHidden == true {
            checkImage.isHidden = false
        }
        else{
            if checkImage.isHidden == false {
                checkImage.isHidden = true
            }
        }
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
