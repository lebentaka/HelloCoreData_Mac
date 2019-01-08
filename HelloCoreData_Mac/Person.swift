//
//  Person.swift
//  HelloCoreData_Mac
//
//  Created by taka2018 on 2018/12/24.
//  Copyright © 2018 taka2018. All rights reserved.
//

import Cocoa

class Person: NSObject {
    var name:String
    var age:Int
    
    init(name:String, age:Int) {
        self.name = name
        self.age = age
    }
}
