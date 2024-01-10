//
//  Constants.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 10/01/24.
//

import Foundation

class Constants {
    static var shared = Constants()
    
    func baseUrl(_ route: String) -> String {
        return "https://gateway.marvel.com/v1/public/\(route)"
    }
    
    private init () {}
}
