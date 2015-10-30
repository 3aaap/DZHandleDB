//
//  ViewController.swift
//  DZHandleDB
//
//  Created by 宋得中 on 15/10/29.
//  Copyright © 2015年 song_dzhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: -测试代码
//        testCreateTable()
//        testInsertData()
//        testUpdateData()
        testDeleteData()
    }
}

// MARK: - 测试函数
extension ViewController {
    // 测试使用文件批量建表
    func testCreateTable() {
        
        DZSQLiteManager.sharedManager.createTableBySQLFile("demo.sql")
    }
    
    // 测试插入数据操作
    func testInsertData() {
        let person = Person(dict: ["name": "zhang", "age": 17, "height": 1.8])
        
        if person.insertPerson() {
            print("插入数据成功")
        } else {
            print("插入数据失败")
        }
        
        print(person.id)
    }
    
    // 测试更新数据
    func testUpdateData() {
        let person = Person(dict: ["id": 3, "name": "王五", "age": 13, "height": 1.6])
        
        if person.updatePerson() {
            print("更新数据成功")
        } else {
            print("更新数据失败")
        }
    }
    
    // 测试删除数据
    func testDeleteData() {
        let person = Person(dict: ["id": 3, "name": "王五", "age": 13, "height": 1.6])
        
        if person.deletePerson() {
            print("删除数据成功")
        } else {
            print("删除数据失败")
        }
    }
}

