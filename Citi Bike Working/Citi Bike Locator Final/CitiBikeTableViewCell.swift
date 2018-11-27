//
//  CitiBikeTableViewCell.swift
//  Citi Bike Locator
//
//  Created by David Hartglass on 4/24/18.
//  Copyright © 2018 David Hartglass. All rights reserved.
//

import UIKit

class CitiBikeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var BikeIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

