//
//  WXStockManager.swift
//  WXLC
//
//  Created by liangpengshuai on 25/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class WXStockManager: NSObject {
    

    class func createStockAccount(userId: String?, accountName: String, type: Int, amount: Double, completionBlock:@escaping (_ success: Bool) -> ()) {
        let account = AVObject(className: "StockAccount")
        let acl = AVACL()
        acl.setPublicReadAccess(true)
        acl.setPublicWriteAccess(true)
        account.acl = acl
        if let id = userId {
            account.setObject(id, forKey: "userId")
        }
        account.setObject(accountName, forKey: "name")
        account.setObject(type, forKey: "type")
        account.setObject(amount, forKey: "cashpool")
        account.saveInBackground { (isSucces, error) in
            completionBlock(isSucces)
        }
    }
    
    class func loadUserAccountList(userId: String?, completionBlock:@escaping (_ success: Bool, _ accountList: [StockAccount]?) -> ()) {
        let query = AVQuery(className: "StockAccount")

        if let id = userId {
            query.whereKey("userId", equalTo: id)
        }
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                var retList: [StockAccount] = []
                for item in objects! {
                    let account = StockAccount()
                    account.id = (item as! AVObject).objectId
                    account.name = (item as! AVObject).object(forKey: "name") as! String
                    account.type = (item as! AVObject).object(forKey: "type") as! Int
                    account.cashpool = (item as! AVObject).object(forKey: "cashpool") as! Double
                    retList.append(account)
                }
                completionBlock(true, retList)
                
            } else {
                completionBlock(false, nil)

            }
        }
    }
    
    class func loadStockListInAccount(accountId: String, completionBlock:@escaping (_ success: Bool, _ stockList: [StockDetail]?) -> ()) {
        let query = AVQuery(className: "StockDetail")
        query.whereKey("associatedAccountId", equalTo: accountId)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                var retList: [StockDetail] = []
                for item in objects! {
                    let stock = StockDetail()
                    stock.id = (item as! AVObject).objectId
                    stock.name = (item as! AVObject).object(forKey: "name") as! String
                    stock.type = (item as! AVObject).object(forKey: "type") as! Int
                    stock.number = (item as! AVObject).object(forKey: "number") as! String
                    stock.amountPerInBuy = (item as! AVObject).object(forKey: "type") as! Double
                    stock.associatedAccountId = (item as! AVObject).object(forKey: "associatedAccountId") as! String

                    retList.append(stock)
                }
                completionBlock(true, retList)
                
            } else {
                completionBlock(false, nil)
                
            }
            
        }
    }
    
    class func createStock(accountId: String, type: Int, number: String, stockName: String, completionBlock:@escaping (_ success: Bool) -> ()) {
        let account = AVObject(className: "StockDetail")
        account.setObject(stockName, forKey: "name")
        account.setObject(type, forKey: "type")
        account.setObject(number, forKey: "number")

        account.setObject(accountId, forKey: "associatedAccountId")
        let acl = AVACL()
        acl.setPublicReadAccess(true)
        acl.setPublicWriteAccess(true)
        account.acl = acl
        account.saveInBackground { (isSucces, error) in

            completionBlock(isSucces)
        }
    }
    
    class func updateStockInstantInfo(stockInfo: StockDetail, completionBlock:@escaping (_ isSuccess: Bool) -> ()) {
        var url = ""
        let param = NSMutableDictionary()
        param.setObject("ae1a6874117f1337db696f385834e5f2", forKey: "key" as NSCopying)
        if stockInfo.type == 0 {
            url = "http://web.juhe.cn:8080/finance/stock/hs"
            param.setObject(stockInfo.number, forKey: "gid" as NSCopying)
        }
        if stockInfo.type == 1 {
            url = "http://web.juhe.cn:8080/finance/stock/hk"
            param.setObject(stockInfo.number, forKey: "num" as NSCopying)
        }
        if stockInfo.type == 2 {
            url = "http://web.juhe.cn:8080/finance/stock/usa"
            param.setObject(stockInfo.number, forKey: "gid" as NSCopying)
        }
        
        Thread.sleep(forTimeInterval: 0.1)

        WXNetworkingAPI.get(url, params: param) { (responseObject, error) in
            if let dic = responseObject as? NSDictionary {
                if let array = dic.object(forKey: "result") as? NSArray {
                    if let result = array.firstObject as? NSDictionary {
                        
                        if stockInfo.type == 0 {
                            stockInfo.currentPrice = Double(((result.object(forKey: "data") as! NSDictionary).object(forKey: "nowPri")) as! String)
                            self.loadStockAction(stockId: stockInfo.id, completionBlock: { (isSuccess, actionList) in
                                if isSuccess {
                                    stockInfo.actionList = actionList
                                    completionBlock(true)
                                } else {
                                    completionBlock(false)
                                }
                            })
                        } else {
                            stockInfo.currentPrice = Double(((result.object(forKey: "data") as! NSDictionary).object(forKey: "lastestpri")) as! String)
                            self.loadStockAction(stockId: stockInfo.id, completionBlock: { (isSuccess, actionList) in
                                if isSuccess {
                                    stockInfo.actionList = actionList
                                    completionBlock(true)
                                } else {
                                    completionBlock(false)
                                }
                            })
                        }

                       
                    } else {
                        completionBlock(false)
                    }
                    
                } else {
                    completionBlock(false)
                }
            } else {
                completionBlock(false)
            }
            
        }
    }
    
    class func loadStockAction(stockId: String, completionBlock:@escaping (_ isSuccess: Bool, _ actionList: [StockAction]) -> ()) {
        let query = AVQuery(className: "StockAction")
        query.whereKey("stockId", equalTo: stockId)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                var retList: [StockAction] = []
                for item in objects! {
                    var action = StockAction()
                    action.actionId = (item as! AVObject).objectId
                    action.actionType = (item as! AVObject).object(forKey: "actionType") as! Int
                    action.price = NSDecimalNumber(decimal: ((item as! AVObject).object(forKey: "price") as! NSNumber).decimalValue).doubleValue
                    action.count = (item as! AVObject).object(forKey: "count") as! Int
                    action.memo = (item as! AVObject).object(forKey: "memo") as? String

                    retList.append(action)
                }
                completionBlock(true, retList)
                
            } else {
                completionBlock(false, [])
                
            }
            
        }
    }
    
    class func addStockAction(stockInfo: StockDetail, action: StockAction, completionBlock:@escaping (_ isSuccess: Bool) -> ()) {
        let actionModel = AVObject(className: "StockAction")
        actionModel.setObject(stockInfo.id, forKey: "stockId")
        actionModel.setObject(action.actionType, forKey: "actionType")
        actionModel.setObject(action.count, forKey: "count")
        actionModel.setObject(action.price, forKey: "price")
        if let memo = action.memo {
            actionModel.setObject(memo, forKey: "memo")
        }

        let acl = AVACL()
        acl.setPublicReadAccess(true)
        acl.setPublicWriteAccess(true)
        actionModel.acl = acl
        actionModel.saveInBackground { (isSucces, error) in
            completionBlock(isSucces)
        }
    }
}













