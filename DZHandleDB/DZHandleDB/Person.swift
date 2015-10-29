//
//  Person.swift
//  DZHandleDB
//
//  Created by 宋得中 on 15/10/30.
//  Copyright © 2015年 song_dzhong. All rights reserved.
//

import UIKit

/// 演示并测试数据库管理函数编写的正确性
class Person: NSObject {
    var id = 0
    var name: String?
    var age = 0
    var height: Double = 0
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    // 方便调试
    override var description: String {
        let keys = ["id", "name", "age", "height"]
        
        return dictionaryWithValuesForKeys(keys).description
    }
}
