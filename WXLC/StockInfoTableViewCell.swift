//
//  StockInfoTableViewCell.swift
//  WXLC
//
//  Created by liangpengshuai on 28/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class StockInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
