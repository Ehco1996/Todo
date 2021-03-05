//
//  Array+Only.swift
//  Memo
//
//  Created by ehco on 2021/3/5.
//

import Foundation

// 作用域是本模块里所有的Array,给Array加上了一个`only`的propetry：如果数组里只有一个元素就将其返回，否则就返回nil
extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
