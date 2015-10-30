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

extension Person {
    // 根据数据模型向数据表中插入一条模型数据
    func insertPerson() -> Bool {
        let sql = "INSERT INTO T_Person\n" +
                    "(name, age, height) VALUES\n" +
                    "('\(name!)', \(age), \(height));"
        
        print(sql)
        
        id = DZSQLiteManager.sharedManager.insertExec(sql)
        
        return id > 0
    }
    // 修改当前对象 id 对应的数据
    func updatePerson() -> Bool {
        let sql = "UPDATE T_Person SET name = '\(name!)', age = \(age), height = \(height) \n" +
        "WHERE id = \(id);"
        
        print(sql)
        
        let rows = DZSQLiteManager.sharedManager.updateOrDelExec(sql)
        
        return rows > 0
    }
    // 删除当前对象 id 对应的数据
    func deletePerson() -> Bool {
        let sql = "DELETE FROM T_Person WHERE id = \(id)"
        
        print(sql)
        
        let rows = DZSQLiteManager.sharedManager.updateOrDelExec(sql)
        
        return rows > 0
    }
}
