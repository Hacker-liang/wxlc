//
//  AddAccountViewController.swift
//  WXLC
//
//  Created by liangpengshuai on 23/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController, UITextFieldDelegate {

    var accountType: Int = 0
    var userId: String?

    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var amountLabel: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if accountType == 0 {
            self.navigationItem.title = "新建A股账号"
            amountLabel.placeholder = "(CNY)"
        }
        if accountType == 1 {
            self.navigationItem.title = "新建港股账号"
            amountLabel.placeholder = "(HKD)"

        }
        if accountType == 2 {
            self.navigationItem.title = "新建美股账号"
            amountLabel.placeholder = "(USD)"
        }
        
        let leftView1 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 45))
        leftView1.text = " 账户名称:"
        leftView1.font = UIFont.systemFont(ofSize: 15)
        leftView1.textColor = UIColor.gray
        titleLabel.leftView = leftView1
        titleLabel.leftViewMode = .always
        titleLabel.delegate = self
        
        let leftView2 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 45))
        leftView2.text = " 账户余额:"
        leftView2.font = UIFont.systemFont(ofSize: 15)
        leftView2.textColor = UIColor.gray
        amountLabel.leftView = leftView2
        amountLabel.leftViewMode = .always
        amountLabel.delegate = self
        
        addButton.layer.cornerRadius = 3.0
        addButton.clipsToBounds = true
    }

    @IBAction func addAction(_ sender: Any) {
        SVProgressHUD.show(withStatus: "正在添加")
        WXStockManager.createStockAccount(userId: self.userId, accountName: titleLabel.text!, type: accountType, amount: Double(amountLabel.text!)!, completionBlock: {(success) in
            if success {
                SVProgressHUD.showSuccess(withStatus: "添加成功")
                _ = self.navigationController?.popViewController(animated: true)
                
            } else {
                SVProgressHUD.showError(withStatus: "添加失败")
            }
            
        })
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
