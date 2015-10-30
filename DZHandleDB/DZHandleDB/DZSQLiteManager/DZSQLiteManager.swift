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
        // TODO: -- 后续尝试将路径进行封装，供调用方选择
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

// MARK: - 查询语句执行
extension DZSQLiteManager {
    /// 执行查询 sql 语句
    ///
    /// - parameter sql: sql 语句
    ///
    /// - returns: 语句执行结果集合 --- 语句执行错误会返回 nil
    func queryExec(sql: String) -> [[String : AnyObject]]? {
        // 创建结果集合
        var result = [[String : AnyObject]]()
        // 创建预编译指令操作句柄
        var stmt: COpaquePointer = nil
        
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("预编译失败")
            sqlite3_finalize(stmt)
            return nil
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            result.append(getRecord(stmt))
        }
        
        return result
    }
    
    /// 根据预编译操作句柄获得单条结果字典
    ///
    /// - parameter stmt: stmt
    ///
    /// - returns: 结果字典
    private func getRecord(stmt: COpaquePointer) -> [String : AnyObject] {
        // 创建单条结果字典
        var rowResult = [String : AnyObject]()
        // 执行结果中字段数
        let columnsCount = sqlite3_column_count(stmt)
        
        var value: AnyObject?
        for col in 0..<columnsCount {
            // 字段名
            let cColumnName = sqlite3_column_name(stmt, col)
            let columnName = String(CString: cColumnName, encoding: NSUTF8StringEncoding)
            // 字段类型
            let columnType = sqlite3_column_type(stmt, col)
            // TODO: -- 未处理 blob 类型
            switch columnType {
            case SQLITE_INTEGER:
                value = Int(sqlite3_column_int64(stmt, col))
            case SQLITE_FLOAT:
                value = sqlite3_column_double(stmt, col)
            case SQLITE_TEXT:
                let cText = UnsafePointer<Int8>(sqlite3_column_text(stmt, col))
                value = String(CString: cText, encoding: NSUTF8StringEncoding)
            case SQLITE_NULL:
                value = NSNull()
            default: print("不识别的字段类型")
            }
            rowResult[columnName!] = value
        }
        
        return rowResult
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
// TODO: -- 对于批量操作的语句未进行处理
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