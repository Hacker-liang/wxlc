//
//  StockListTableViewCell.swift
//  WXLC
//
//  Created by liangpengshuai on 25/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class StockListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var pfofitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
