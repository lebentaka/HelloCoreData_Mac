//
//  Price.swift
//  HelloCoreData_Mac
//
//  Created by taka2018 on 2018/12/24.
//  Copyright © 2018 taka2018. All rights reserved.
//

import Cocoa

class Price: NSObject {
    var name:String
    var date:String
    var begin:String
    var high:String
    var low:String
    var end:String
//    var volume:String
//    var end2:String
    
    init(name:String, date:String, begin:String, high:String, low:String, end:String) {
        self.name = name
        self.date = date
        self.begin = begin
        self.high = high
        self.low = low
        self.end = end
//        self.volume = volume
//        self.end2 = end2
    }
}
