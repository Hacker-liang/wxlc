
//  StockDetail.swift
//  WXLC
//
//  Created by liangpengshuai on 25/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class StockDetail: NSObject {
    
    var id: String!
    var number: String!
    var name: String!
    var type: Int!
    var amountPerInBuy: Double!
    var currentPrice: Double!
    var associatedAccountId: String!
    var actionList: [StockAction]!
    
    override init() {
        id = ""
        number = ""
        name = ""
        type = 0
        amountPerInBuy = 0
        currentPrice = 0
        associatedAccountId = ""
        actionList = []
    }
    
    func stockCount() -> Int {
        var count = 0
        for action in self.actionList {
            if action.actionType == 0 {
                count += action.count
            } else {
                count -= action.count
            }
        }
        return count
    }
    
    func stockTotalFee() -> Double {
        var totalPrice = 0.0
        for action in self.actionList {
            if action.actionType == 2 {
                totalPrice += action.price
            }
        }
        return totalPrice
    }
    
    func getTotalProfit() -> Double {
        
        var totalPrice = 0.0
        var totalPrice1 = 0.0
        var totalPrice2 = 0.0
        var totalPrice3 = 0.0

        var count = 0
        for action in self.actionList {
            if action.actionType == 0 {
                count += action.count
                totalPrice -= Double(action.count) * action.price
                totalPrice1 -= Double(action.count) * action.price
            } else if action.actionType == 1 {
                count -= action.count
                totalPrice += Double(action.count) * action.price
                totalPrice2 += Double(action.count) * action.price
            } else {
                totalPrice += action.price
                totalPrice3 += action.price
            }
        }
        print("price1: \(totalPrice1) price2: \(totalPrice2) price3: \(totalPrice3)")
        totalPrice += self.currentPrice * Double(count)
        return totalPrice
    }
}

struct StockAction {
    var actionType: Int!    //0买入   1卖出    2其他
    var memo: String?
    var actionId: String!
    var date: NSString!
    var price: Double!
    var count: Int!
}
