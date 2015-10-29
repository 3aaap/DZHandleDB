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
        createTable()
    }
}

// MARK: - 测试函数
extension ViewController {
    // 测试使用文件批量建表
    func createTable() {
        
        DZSQLiteManager.sharedManager.createTableBySQLFile("demo.sql")
    }
}

