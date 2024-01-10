//
//  Result.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 10/01/24.
//

struct Result: Decodable {
    var results: [HeroInformation]
    var count: Int
    var total: Int
    var offset: Int
}
