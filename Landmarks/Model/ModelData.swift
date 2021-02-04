//
//  ModelData.swift
//  Landmarks
//
//  Created by ehco on 2021/2/4.
//

import Foundation



var landmarks: [Landmark] = load("landmarkData.json")

func load<T:Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("不能加载文件")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("不能加载文件")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("不能加载文件(filename) as (T.self) err:(error)")
    }
}
