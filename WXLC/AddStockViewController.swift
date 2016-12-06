//
//  AddStockViewController.swift
//  WXLC
//
//  Created by liangpengshuai on 23/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class AddStockViewController: UIViewController {
    
    var accountType: Int = 0
    var accountId: String!

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var codeLabel: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if accountType == 0 {
            self.navigationItem.title = "新建A股账号"
        }
        if accountType == 1 {
            self.navigationItem.title = "新建港股账号"
            
        }
        if accountType == 2 {
            self.navigationItem.title = "新建美股账号"
        }
        
        let leftView = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 45))
        leftView.text = " 股票名称:"
        leftView.font = UIFont.systemFont(ofSize: 15)
        leftView.textColor = UIColor.gray
        titleLabel.leftView = leftView
        titleLabel.leftViewMode = .always

        let leftView1 = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 45))
        leftView1.text = " 股票代码:"
        leftView1.font = UIFont.systemFont(ofSize: 15)
        leftView1.textColor = UIColor.gray
        codeLabel.leftView = leftView1
        codeLabel.leftViewMode = .always
        if accountType == 0 {
            codeLabel.placeholder = "上海以sh开头,深圳以sz开头"
        } else {
            codeLabel.placeholder = "股票代码"
        }
        
        
        addButton.layer.cornerRadius = 3.0
        addButton.clipsToBounds = true

    }
    
    @IBAction func addAction(_ sender: Any) {
        SVProgressHUD.show(withStatus: "正在添加")
        WXStockManager.createStock(accountId: accountId, type: accountType, number: codeLabel.text!, stockName: titleLabel.text!, completionBlock: {(success) in
            if success {
                SVProgressHUD.showSuccess(withStatus: "添加成功")
                _ = self.navigationController?.popViewController(animated: true)
                
            } else {
                SVProgressHUD.showError(withStatus: "添加失败")
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
