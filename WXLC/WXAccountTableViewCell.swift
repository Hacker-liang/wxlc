//
//  WXAccountTableViewCell.swift
//  WXLC
//
//  Created by liangpengshuai on 23/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class WXAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLable: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
