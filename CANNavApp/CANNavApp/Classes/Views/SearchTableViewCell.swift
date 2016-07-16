//
//  SearchTableViewCell.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/15/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    

    @IBOutlet var mLblAddress: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAddress(address : String) -> () {
        mLblAddress.text = address
    }
    
}
