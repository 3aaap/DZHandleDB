//
//  DZSQLiteManager.swift
//  DZHandleDB
//
//  Created by 宋得中 on 15/10/29.
//  Copyright © 2015年 song_dzhong. All rights reserved.
//

import Foundation

/// sql 执行失败标志
let SQLExecFailed: Int = -1

// MARK: SQLite 操作核心类
class DZSQLiteManager {
    /// 创建单例对象
    static let sharedManager = DZSQLiteManager()
    /// 创建全局数据库操作句柄
    private var db: COpaquePointer = nil
    
    /// 打开数据库
    ///
    /// - parameter dbName: 数据库名称
    func openDB(dbName: String) {
        // 默认将数据库创建在沙盒 document 路径下
        // TODO: --后续尝试将路径进行封装，供调用方选择
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        path = (path as NSString).stringByAppendingPathComponent(dbName)
        
        print(path)
        
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("打开数据库失败！")
            return
        }
    }
    
    /// 执行 sql 语句函数
    ///
    /// - parameter sql:  sql 语句
    ///
    /// - returns:  true 执行成功 --- false 执行失败
    func execSQL(sql: String) -> Bool {
        
        return sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
    }
}

// MARK: - 建表语句执行
extension DZSQLiteManager {
    
    /// 通过建表语句文件来批量创建数据表
    ///
    /// - parameter fileName: 建表语句文件(1、需要在 bundle 中; 2、需要有文件后缀名)
    ///
    /// - returns: true 执行成功 --- false 执行失败
    func createTableBySQLFile(fileName: String) -> Bool {
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil)
        
        guard let filePath = path else {
            print("无法正确获得文件路径!")
            return false
        }
        
        let sql = try! String(contentsOfFile: filePath)
        
        return execSQL(sql)
    }
}

// MARK: - 数据修改操作语句执行
extension DZSQLiteManager {
    
    /// 执行 SQL 插入数据
    ///
    /// - parameter sql:  sql 语句
    ///
    /// - returns:  最后一条插入数据的自增长 id / 失败后返回 SQLExecFailed
    func insertExec(sql: String) -> Int {
        if !execSQL(sql) {
            // 操作失败返回
            return SQLExecFailed
        }
        
        return Int(sqlite3_last_insert_rowid(db))
    }
    
    /// 执行修改和删除数据操作
    ///
    /// - parameter sql:  sql 语句
    ///
    /// - returns: 修改/删除 的数据行数 / 失败后返回 SQLExecFailed
    func updateOrDelExec(sql: String) -> Int {
        if !execSQL(sql) {
            // 操作失败返回
            return SQLExecFailed
        }
        
        return Int(sqlite3_changes(db))
    }
}