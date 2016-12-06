//
//  AccountInfoTableViewCell.swift
//  WXLC
//
//  Created by liangpengshuai on 23/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class AccountInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var editTF: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amoutLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
