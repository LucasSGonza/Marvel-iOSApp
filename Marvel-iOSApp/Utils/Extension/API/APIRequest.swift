//
//  APIRequest.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 13/12/23.
//

import UIKit
import Alamofire
import RxAlamofire
import RxSwift

import CryptoKit

//https://developer.marvel.com/documentation/authorization

class APIRequest {
    
    let baseUrl: String = "https://gateway.marvel.com/v1/public"
    let publicKey: String = "d45266d7de590f0008fb57ac7c925be6"
    let privateKey: String = "39c52df0c1a74c0b4e5d635057241a8d09ed23da"
    
//    var headers = [String: String].init()
    
    func getAllCharacters() {
        let timestamp = Int(Date().timeIntervalSince1970)
        
        guard let data = "\(timestamp)\(privateKey)\(publicKey)".data(using: .utf8) else { return }
        let hash = Insecure.MD5.hash(data: data).map{String(format: "%02hhx", $0)}.joined()
        
        let url = baseUrl + "/characters?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)&limit=1"
//        headers["Authorization"] = publicKey
        
        print("url: \(url)")
        
        let observable = RxAlamofire.requestJSON(.get, url, parameters: nil, encoding: JSONEncoding.default, headers: nil).subscribe(
            
            onNext: { valor in
                print(valor)
            },
            
            onError: { error in
                print(error)
            },
            
            onCompleted: {
                print("fim do life cycle")
            },
            
            onDisposed: {
                print("vazou da memoria")
            }
        )
        
    }
    
}
