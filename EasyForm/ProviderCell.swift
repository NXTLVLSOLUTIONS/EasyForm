//
//  ProviderCell.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 11/21/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit

class ProviderCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var providerImage: UIImageView!
    @IBOutlet weak var fillFormsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
