//
//  Array+identifiable.swift
//  Memo
//
//  Created by ehco on 2021/3/4.
//

import Foundation


extension Array where Element: Identifiable {

    func firstIndex(matching: Element) -> Int? {
        for idx in 0..<self.count {
            if self[idx].id == matching.id {
                return idx
            }
        }
        return nil
    }
}

