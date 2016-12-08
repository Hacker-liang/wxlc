//
//  WXHomeViewController.swift
//  WXLC
//
//  Created by liangpengshuai on 21/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class WXHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var totalIncomeLabel: UILabel!
    var totalInvestLabel: UILabel!
    var expectedIncomeLabel: UILabel!
    var remainingLabel: UILabel!
    var doller2rmb = 0.0
    var hkd2rmb = 0.0
    var navigationView: UIView!
    var userId: String!
    
    var dataSource: [StockAccount] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = "maodongliang"
        self.view.backgroundColor = UIColor.white
        
        let bgView = UIImageView(frame:CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 235))
        bgView.image = UIImage(named: "icon_home_bg.png")
        bgView.contentMode = .scaleAspectFill
        bgView.clipsToBounds = true
        self.view.addSubview(bgView)
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorColor = UIColor.lightGray
        self.tableView.register(UINib(nibName: "WXAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "accountCell")
        self.view.addSubview(self.tableView)
        self.setupTableViewHeaderView()
        self.setupFooterView()
        navigationView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 64))
        navigationView.backgroundColor = APP_THEME_COLOR
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: self.view.bounds.size.width, height: 44))
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.text = "股票助手"
        titleLabel.textAlignment = .center
        navigationView.addSubview(titleLabel)
        
        self.navigationItem.title = "首页"
        self.view.addSubview(navigationView)
        navigationView.alpha = 0
        self.loadUserAccount()
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadUserAccount()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
    }
    
    func loadMoneyInfo() {
        let url = "http://op.juhe.cn/onebox/exchange/query"
        WXNetworkingAPI.get(url, params: ["key": "47e27ba2819ff652257eb855159ffe6e"]) { (responseObject, error) in
            if let dic = responseObject as? NSDictionary {
                if let result = dic.object(forKey: "result") as? NSDictionary {
                    if let array = result.object(forKey: "list") as? NSArray {
                        for obj in array {
                            if let j = obj as? NSArray {
                                if (j.object(at: 0) as! String) == "美元" {
                                    self.doller2rmb = Double(j.object(at: 3) as! String)!/100
                                    print("美元汇率  \(self.doller2rmb)")
                                }
                                if (j.object(at: 0) as! String) == "港币" {
                                    self.hkd2rmb = Double(j.object(at: 3) as! String)!/100
                                    print("港币汇率  \(self.hkd2rmb)")
                                }
                            }
                        }
                        self.updateAccountDetail()
                    }
                }
            }
        }
    }
    
    func updateAccountDetail() {
        
        var allValue = 0.0
        var allInvest = 0.0
        var allRemain = 0.0

        var i = 0
   
        
        for accountDetail in self.dataSource {
            if accountDetail.type == 1 {
                allRemain += accountDetail.cashpool * hkd2rmb

            } else if accountDetail.type == 2 {
                allRemain += accountDetail.cashpool * doller2rmb

            } else {
                allRemain += accountDetail.cashpool

            }
            WXStockManager.loadStockListInAccount(accountId: accountDetail.id, completionBlock: {(isSuccess, stockList) in
                if isSuccess {
                    var count = 0
                    accountDetail.stockList = stockList!
                    if stockList?.count == 0 {
                        i += 1
                    }
                    for stock in stockList! {
                        
                        WXStockManager.updateStockInstantInfo(stockInfo: stock, completionBlock: { (isSuccess) in
                            if isSuccess {
                                
                            }
                            count += 1
                            
                            let profitValue = stock.getTotalProfit()
                            if stock.type == 1 {
                                allValue += profitValue * self.hkd2rmb
                                allInvest += stock.currentPrice * Double(stock.stockCount()) * self.hkd2rmb
                            } else if stock.type == 2 {
                                allValue += profitValue * self.doller2rmb
                                allInvest += stock.currentPrice * Double(stock.stockCount()) * self.doller2rmb
                            } else {
                                allValue += profitValue
                                allInvest += stock.currentPrice * Double(stock.stockCount())
                            }
                            
                            if count == stockList!.count {
                                i += 1
                                if i == self.dataSource.count {
                                    let str = String(format: "%.2f", allValue)
                                    let str1 = String(format: "%.2f", allInvest)

                                    self.totalIncomeLabel.text = "¥\(str)"
                                    self.totalInvestLabel.text = "¥\(str1)"
                                    self.tableView.reloadData()
                                    self.tableView.mj_header.endRefreshing()
                                    
                                }
                                
                            }
                        })
                    }
                    
                }
            })
        }
        let str = String(format: "%.2f", allRemain)
        self.remainingLabel.text = "¥\(str)"

    }
    
    func setupTableViewHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 235))
        headerView.backgroundColor = UIColor.clear
        
        let tempLabel1 = UILabel(frame: CGRect(x: 0, y: 50, width: self.view.bounds.size.width, height: 20))
        tempLabel1.textColor = UIColor.white
        tempLabel1.font = UIFont.systemFont(ofSize: 15)
        tempLabel1.text = "盈亏"
        tempLabel1.textAlignment = .center
        headerView.addSubview(tempLabel1)
        
        totalIncomeLabel = UILabel(frame: CGRect(x: 0, y: 75, width: self.view.bounds.size.width, height: 40))
        totalIncomeLabel.textColor = UIColor.white
        totalIncomeLabel.font = UIFont.boldSystemFont(ofSize: 38)
        totalIncomeLabel.textAlignment = .center
        headerView.addSubview(totalIncomeLabel)
        
        let tempLabel2 = UILabel(frame: CGRect(x: 20, y: 145, width: self.view.bounds.size.width/3, height: 20))
        tempLabel2.textColor = UIColor.white
        tempLabel2.font = UIFont.systemFont(ofSize: 13.0)
        tempLabel2.text = "在投总值"
        tempLabel2.textAlignment = .center
        headerView.addSubview(tempLabel2)
        
        totalInvestLabel = UILabel(frame: CGRect(x: 20, y: 165, width: self.view.bounds.size.width/3, height: 20))
        totalInvestLabel.textColor = UIColor.white
        totalInvestLabel.font = UIFont.systemFont(ofSize: 14.0)
        totalInvestLabel.textAlignment = .center
        headerView.addSubview(totalInvestLabel)
        
        let tempLabel4 = UILabel(frame: CGRect(x: self.view.bounds.size.width/3*2-20, y: 145, width: self.view.bounds.size.width/3, height: 20))
        tempLabel4.textColor = UIColor.white
        tempLabel4.font = UIFont.systemFont(ofSize: 13.0)
        tempLabel4.text = "可用余额"
        tempLabel4.textAlignment = .center
        headerView.addSubview(tempLabel4)
        
        remainingLabel = UILabel(frame: CGRect(x: self.view.bounds.size.width/3*2-20, y: 165, width: self.view.bounds.size.width/3, height: 20))
        remainingLabel.textColor = UIColor.white
        remainingLabel.font = UIFont.systemFont(ofSize: 14.0)
        remainingLabel.textAlignment = .center
        headerView.addSubview(remainingLabel)
        
        self.tableView.tableHeaderView = headerView
    }
    
    func setupFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kWindowWidth, height: 80))
        let addButton = UIButton(frame: CGRect(x: 10, y: 40, width: kWindowWidth-20, height: 45))
        addButton.backgroundColor = APP_THEME_COLOR
        addButton.layer.cornerRadius = 3.0
        addButton.clipsToBounds = true
        addButton.setTitle("添加", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.addTarget(self, action: #selector(addNewAccount), for: .touchUpInside)
        footerView.addSubview(addButton)
        self.tableView.tableFooterView = footerView
    }
    
    func addNewAccount() {
        let actionSheet = UIActionSheet(title: "新增账户", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "A股账号", "港股账号", "美股账号")
        actionSheet.show(in: self.view)
    }
    
    func loadUserAccount() {
        
        WXStockManager.loadUserAccountList(userId: self.userId, completionBlock: {(success, retList) in
            if success {
                self.dataSource = retList!
                self.loadMoneyInfo()
                self.tableView.reloadData()
            }
        })
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }
        let addAccountCtl = AddAccountViewController()
        addAccountCtl.accountType = buttonIndex-1
        addAccountCtl.userId = userId
        self.navigationController?.pushViewController(addAccountCtl, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WXAccountTableViewCell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! WXAccountTableViewCell
        cell.titleLabel.text = dataSource[indexPath.row].name
        var priceUnit: String = ""

        if dataSource[indexPath.row].type == 0 {
            cell.typeLabel.text = "A股账号"
            priceUnit = "¥"
        }
        if dataSource[indexPath.row].type == 1 {
            cell.typeLabel.text = "港股账号"
            priceUnit = "HK$"

        }
        if dataSource[indexPath.row].type == 2 {
            cell.typeLabel.text = "美股账号"
            priceUnit = "$"
        }
        
        var totalValue = 0.0
        for stock in self.dataSource[indexPath.row].stockList {
            totalValue += stock.getTotalProfit()
        }
        if totalValue > 0 {
            cell.amountLable.textColor = UIColor.red
        } else {
            cell.amountLable.textColor = APP_GREEN_COLOR
        }
        let value1 = String(format: "%.2f", totalValue)
        
        cell.amountLable.text = "\(priceUnit)\(value1)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ctl = AccountDetailViewController()
        ctl.accountDetail = dataSource[indexPath.row]
        self.navigationController?.pushViewController(ctl, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = scrollView.contentOffset.y/100
        self.navigationView.alpha = alpha
        
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
}
