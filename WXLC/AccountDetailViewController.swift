//
//  AccountDetailViewController.swift
//  WXLC
//
//  Created by liangpengshuai on 23/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class AccountDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var totalIncomeLabel: UILabel!
    var totalInvestLabel: UILabel!
    var expectedIncomeLabel: UILabel!
    var remainingLabel: UILabel!
    var accountDetail: StockAccount!

    var navigationView: UIView!
    
    var dataSource:[StockDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorColor = UIColor.lightGray
        self.tableView.register(UINib(nibName: "AccountInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        self.tableView.register(UINib(nibName: "StockListTableViewCell", bundle: nil), forCellReuseIdentifier: "stockCell")

        self.view.addSubview(self.tableView)
        self.setupFooterView()
        self.navigationItem.title = self.accountDetail.name
        
        let actionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        actionButton.setTitle("编辑", for: .normal)
        actionButton.setTitle("保存", for: .selected)

        actionButton.setTitleColor(APP_THEME_COLOR, for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        actionButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadStockList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func editAction(sender: UIButton) {
        if !sender.isSelected {
            self.tableView.isEditing = true
            self.tableView.reloadData()
            sender.isSelected = !sender.isSelected

        } else {
            SVProgressHUD.show(withStatus: "正在保存")
            let cell: AccountInfoTableViewCell = tableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! AccountInfoTableViewCell
            let objc = AVObject(className: "StockAccount", objectId: self.accountDetail.id)
            objc.setObject(Double(cell.editTF.text!), forKey: "cashpool")
            objc.saveInBackground({ (isSuccess, error) in
                if isSuccess {
                    self.accountDetail.cashpool = Double(cell.editTF.text!)
                    self.tableView.reloadData()
                    SVProgressHUD.showSuccess(withStatus: "保存成功")
                    sender.isSelected = !sender.isSelected

                } else {
                    SVProgressHUD.showError(withStatus: "保存失败")
                }
            })
            self.tableView.isEditing = false
        }
    }
    
    func setupFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kWindowWidth, height: 100))
        let addButton = UIButton(frame: CGRect(x: 10, y: 30, width: kWindowWidth-20, height: 45))
        addButton.backgroundColor = APP_THEME_COLOR
        addButton.layer.cornerRadius = 3.0
        addButton.clipsToBounds = true
        addButton.setTitle("添加", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.addTarget(self, action: #selector(addNewAccount), for: .touchUpInside)
        footerView.addSubview(addButton)
        self.tableView.tableFooterView = footerView
    }
    
    func loadStockList() {
        WXStockManager.loadStockListInAccount(accountId: self.accountDetail.id, completionBlock: {(isSuccess, stockList) in
            if isSuccess {
                self.dataSource = stockList!
                self.accountDetail.stockList = stockList!
                var count = 0
                for stock in self.dataSource {
                    WXStockManager.updateStockInstantInfo(stockInfo: stock, completionBlock: { (isSuccess) in
                        if isSuccess {
                            
                        }
                        count += 1
                        if count == self.dataSource.count {
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        })
    }
    
    func updateAccountInfo() {
        
    }
    
    func addNewAccount() {
        let ctl = AddStockViewController()
        ctl.accountType = accountDetail.type
        ctl.accountId = accountDetail.id
        self.navigationController?.pushViewController(ctl, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 49
        }
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "账户信息"
        }
        return "股票列表"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var priceUnit: String = ""

            if accountDetail.type == 1 {
                priceUnit = "HK$"
                
            } else if accountDetail.type == 2 {
                priceUnit = "$"
                
            } else {
                priceUnit = "¥"
            }
            let cell: AccountInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! AccountInfoTableViewCell
            cell.editTF.isHidden = true
            cell.amoutLabel.textColor = UIColorFromRGB(rgb: 0x333333, alpha: 1)
            if indexPath.row == 0 {
                var totalValue = 0.0
                for stock in self.dataSource {
                    totalValue += stock.getTotalProfit()
                }
                if totalValue > 0 {
                    cell.amoutLabel.textColor = UIColor.red
                } else {
                    cell.amoutLabel.textColor = APP_GREEN_COLOR
                }
                cell.typeLabel.text = "盈亏:"
                let value1 = String(format: "%.2f", totalValue)

                cell.amoutLabel.text = "\(priceUnit)\(value1)"
            }
            if indexPath.row == 1 {
                var totalValue = 0.0
                for stock in self.dataSource {
                    if stock.stockCount() > 0 {
                        let profitValue = stock.currentPrice * Double(stock.stockCount())
                        totalValue += profitValue
                    }
                }
                cell.typeLabel.text = "在投总值:"
                cell.amoutLabel.text = "\(priceUnit)\(totalValue)"
            }
        
            if indexPath.row == 2 {
                cell.typeLabel.text = "账户余额:"
                cell.amoutLabel.text = "\(priceUnit)\(accountDetail.cashpool!)"
                cell.editTF.text = "\(accountDetail.cashpool!)"
                cell.editTF.isHidden = !tableView.isEditing
                cell.amoutLabel.isHidden = tableView.isEditing
            }
            return cell
        }
        let cell:StockListTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockListTableViewCell
        cell.titleLable.text = "\(dataSource[indexPath.row].name!)(\(dataSource[indexPath.row].number!))"
        let stockDetail = dataSource[indexPath.row]
        let profitValue = stockDetail.getTotalProfit()
        cell.pfofitLabel.text = String(format: "%.2f", profitValue)
        
        if profitValue > 0 {
            cell.pfofitLabel.textColor = UIColor.red
        } else {
            cell.pfofitLabel.textColor  = APP_GREEN_COLOR
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertView(title: "删除操作无法恢复，确认删除吗？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alert.show({ (index) in
                if index == 1 {
                    SVProgressHUD.show(withStatus: "正在删除")
                    let obj = AVObject(className: "StockDetail", objectId: self.dataSource[indexPath.row].id)
                    obj.deleteInBackground({ (isSuccess, error) in
                        if isSuccess {
                            SVProgressHUD.showSuccess(withStatus: "删除成功")
                            self.accountDetail.stockList.remove(at: indexPath.row)
                            self.dataSource.remove(at: indexPath.row)
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
        if indexPath.section == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            let ctl = StockDetailViewController()
            ctl.stockDetail = dataSource[indexPath.row]
            ctl.accountDetail = accountDetail
            self.navigationController?.pushViewController(ctl, animated: true)
        }
    }
    
}
