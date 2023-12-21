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
    
    func validateResponseFromAPI(limit: Int) -> Observable<DataRequest> {
        let timestamp = Int(Date().timeIntervalSince1970)
        let hashData = "\(timestamp)\(privateKey)\(publicKey)".data(using: .utf8)!
        let hash = Insecure.MD5.hash(data: hashData).map{String(format: "%02hhx", $0)}.joined()
        
        let url = baseUrl +  "/characters?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)&limit=\(limit)"
        
        return RxAlamofire.request(.get, url, parameters: nil, encoding: JSONEncoding.default, headers: nil)
    }
    
    //usando Single<> ao inves de Observable pq Singles tbm é um emissor, mas so tem 2 metodos: onSucess e onError
    func getAllCharacters(numberOfHeroesToSearch: Int) -> Single<Data> {
        return validateResponseFromAPI(limit: numberOfHeroesToSearch)
            .responseData()
            .flatMap({ response -> Single<Data> in
                let data = try JSONDecoder().decode(Data.self, from: response.1)
                return Single.just(data)
            })
            .asSingle()
    }
    
//    func getAllCharacters2() -> Single<Hero>? {
//        let timestamp = Int(Date().timeIntervalSince1970)
//        let hashData = "\(timestamp)\(privateKey)\(publicKey)".data(using: .utf8)!
//        let hash = Insecure.MD5.hash(data: hashData).map{String(format: "%02hhx", $0)}.joined()
//        let url = baseUrl + "/characters?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)&limit=1"
//
//        return RxAlamofire.request(.get, url, encoding: JSONEncoding.default)
//            .responseData()
//            .flatMap({ response -> Single<Hero> in
//                let data = try JSONDecoder().decode(Hero.self, from: response.1)
//                return Single.just(data)
//            })
//            .asSingle()
//    }

}

//extension DataRequest {
//    func validateResponse() -> Single<Data> {
//        return Single.create { observer in
//            self.responseData(completionHandler: { response in
//                switch response.result {
//                case .success(let data):
//                    observer(.success(data))
//                case .failure(let error):
//                    observer(.error(error))
//                }
//            })
//            return Disposables.create()
//        }
//    }
//}
