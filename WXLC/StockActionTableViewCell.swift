//
//  StockActionTableViewCell.swift
//  WXLC
//
//  Created by liangpengshuai on 28/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class StockActionTableViewCell: UITableViewCell {

    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
