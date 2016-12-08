//
//  StockDetailViewController.swift
//  WXLC
//
//  Created by liangpengshuai on 28/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class StockDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate {
    
    var stockDetail: StockDetail!
    var accountDetail: StockAccount!

    var priceUnit: String = ""

    @IBOutlet weak var tableView: UITableView!
    
    var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stockDetail.type == 1 {
            priceUnit = "HK$"
            
        } else if stockDetail.type == 2 {
            priceUnit = "$"
            
        } else {
            priceUnit = "¥"
        }
     
        self.navigationItem.title = stockDetail.name
        
        self.tableView.register(UINib(nibName: "StockInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "stockInfo")
        self.tableView.register(UINib(nibName: "StockActionTableViewCell", bundle: nil), forCellReuseIdentifier: "stockActionCell")

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        WXStockManager.updateStockInstantInfo(stockInfo: stockDetail, completionBlock: {(isSuccess) in
            self.tableView.reloadData()
            
        })
        
        let actionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        actionButton.setTitle("买卖", for: .normal)
        actionButton.setTitleColor(APP_THEME_COLOR, for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        actionButton.addTarget(self, action: #selector(buyAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }

    func buyAction(sender: UIButton) {
        let actionSheet = UIActionSheet(title: "操作", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "买入", "卖出", "其他")
        actionSheet.show(in: self.view)
        
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 || buttonIndex == 2 {
            let actionType = (buttonIndex == 1) ? "买入" : "卖出"
            let alertView = UIAlertView(title: actionType, message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alertView.alertViewStyle = .loginAndPasswordInput
            let t1 = alertView.textField(at: 0)
            let t2 = alertView.textField(at: 1)
            t2?.isSecureTextEntry = false
            t1?.placeholder = "输入您\(actionType)的单价"
            t2?.placeholder = "输入您\(actionType)的数量"
            alertView.tag = buttonIndex-1
            alertView.show()
            
        } else if buttonIndex == 3 {
            let alertView = UIAlertView(title: "其它操作", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "收入", "支出")
            alertView.alertViewStyle = .loginAndPasswordInput
            let t1 = alertView.textField(at: 0)
            let t2 = alertView.textField(at: 1)
            t2?.isSecureTextEntry = false
            t1?.placeholder = "输入价格"
            t2?.placeholder = "输入备注信息"
            alertView.tag = buttonIndex-1
            alertView.show({ (index) in
                if index != 0 {
                    var action = StockAction()
                    action.actionType = 2
                    let t1 = alertView.textField(at: 0)
                    let t2 = alertView.textField(at: 1)
                    if index == 1 {
                        action.price = Double((t1?.text!)!)
                    } else if index == 2 {
                        action.price = -Double((t1?.text!)!)!
                    }
                    action.count = 0
                    action.memo = t2?.text
                    WXStockManager.addStockAction(stockInfo: self.stockDetail, action: action, completionBlock: { (isSuccess) in
                        if isSuccess {
                            self.stockDetail.actionList.append(action)
                            self.tableView.reloadData()
                            
                            let account = AVObject(className: "StockAccount", objectId: self.accountDetail.id)
                            var amount = self.accountDetail.cashpool!
                            amount += action.price
                            
                            account.setObject(amount, forKey: "cashpool")
                            self.accountDetail.cashpool = amount
                            account.saveInBackground()
                            
                            WXStockManager.updateStockInstantInfo(stockInfo: self.stockDetail, completionBlock: {(isSuccess) in
                                self.tableView.reloadData()
                                
                            })
                            
                        }
                    })
                }
                
            })

        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            var action = StockAction()
            action.actionType = alertView.tag
            let t1 = alertView.textField(at: 0)
            let t2 = alertView.textField(at: 1)
            action.price = Double((t1?.text!)!)
            action.count = Int((t2?.text!)!)
            WXStockManager.addStockAction(stockInfo: stockDetail, action: action, completionBlock: { (isSuccess) in
                if isSuccess {
                    self.stockDetail.actionList.append(action)
                    self.tableView.reloadData()
                    
                    let account = AVObject(className: "StockAccount", objectId: self.accountDetail.id)
                    var amount = self.accountDetail.cashpool!

                    if action.actionType == 0 {
                        amount -= Double(action.count) * action.price
                    }
                    if action.actionType == 1 {
    
                        amount += Double(action.count) * action.price
                    }
                    account.setObject(amount, forKey: "cashpool")
                    self.accountDetail.cashpool = amount
                    account.saveInBackground()
                    
                    WXStockManager.updateStockInstantInfo(stockInfo: self.stockDetail, completionBlock: {(isSuccess) in
                        self.tableView.reloadData()
                        
                    })
                }
            })
        }
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 49
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "股票信息"
        }
        return "操作信息"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return stockDetail.actionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: StockInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "stockInfo", for: indexPath) as! StockInfoTableViewCell
            cell.contentLabel.textColor = UIColorFromRGB(rgb: 0x333333, alpha: 1)
            if indexPath.row == 0 {
                cell.titleLabel.text = "盈亏:"
                
                let profitValue = self.stockDetail.getTotalProfit()
                cell.contentLabel.text = String(format: "%.2f", profitValue)

                if profitValue > 0 {
                    cell.contentLabel.textColor = UIColor.red
                } else {
                    cell.contentLabel.textColor  = APP_GREEN_COLOR
                }
            }
            if indexPath.row == 1 {
                cell.titleLabel.text = "当前单价:"
                cell.contentLabel.text = "\(priceUnit)\(self.stockDetail.currentPrice ?? 0)"
            }
            if indexPath.row == 2 {
                cell.titleLabel.text = "持有总数量:"
                cell.contentLabel.text = "\(self.stockDetail.stockCount())股"
            }
            return cell
            
        } else {
            let action = stockDetail.actionList[indexPath.row]
            let cell:StockActionTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "stockActionCell", for: indexPath) as! StockActionTableViewCell
            if action.actionType == 0 {
                cell.actionLabel.text = "买入"
                cell.priceLabel.text = "\(priceUnit)\(action.price!)"
                cell.countLabel.text = "\(action.count!)股"
                cell.priceLabel.textColor = APP_GREEN_COLOR

            } else if action.actionType == 1 {
                cell.actionLabel.text = "卖出"
                cell.priceLabel.text = "\(priceUnit)\(action.price!)"
                cell.countLabel.text = "\(action.count!)股"
                cell.priceLabel.textColor = UIColor.red

            } else if action.actionType == 2 {
                cell.actionLabel.text = "其它"
                
                cell.priceLabel.text = "\(priceUnit)\(action.price!)"
                cell.countLabel.text = "\(action.memo ?? "")"
                if action.price! > 0 {
                    cell.priceLabel.textColor = UIColor.red
                } else {
                    cell.priceLabel.textColor = APP_GREEN_COLOR
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertView(title: "删除操作无法恢复，确认删除吗？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alert.show({ (index) in
                if index == 1 {
                    SVProgressHUD.show(withStatus: "正在删除")
                    let obj = AVObject(className: "StockAction", objectId: self.stockDetail.actionList[indexPath.row].actionId)
                    obj.deleteInBackground({ (isSuccess, error) in
                        if isSuccess {
                            SVProgressHUD.showSuccess(withStatus: "删除成功")
                            self.stockDetail.actionList.remove(at: indexPath.row)
                            self.tableView.reloadData()
                            
                        } else {
                            SVProgressHUD.showError(withStatus: "删除失败")
                        }
                    })
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
