//
//  StockAccount.swift
//  WXLC
//
//  Created by liangpengshuai on 25/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

class StockAccount: NSObject {
    var name: String!
    var id: String!
    var type: Int!
    var cashpool: Double!
    var stockList: [StockDetail] = []

}
