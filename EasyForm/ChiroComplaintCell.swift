//
//  ChiroComplaintCell.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 12/5/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit

class ChiroComplaintCell: UITableViewCell {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var segmentControl: AnimatedSegmentSwitch!
    @IBOutlet weak var whatsWorseField: UITextField!
    @IBOutlet weak var whatsBetterField: UITextField!
    @IBOutlet weak var howLongField: UITextField!
    @IBOutlet weak var ratePainField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
