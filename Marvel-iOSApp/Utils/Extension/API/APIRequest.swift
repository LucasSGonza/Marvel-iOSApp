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
    
//    func getResponseFromAPI() {
//        let timestamp = Int(Date().timeIntervalSince1970)
//        if let hashData = "\(timestamp)\(privateKey)\(publicKey)".data(using: .utf8) {
//            let hash = Insecure.MD5.hash(data: hashData).map{String(format: "%02hhx", $0)}.joined()
//            let url = baseUrl + "/characters?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)&limit=1"
//
//            RxAlamofire.request(.get, url, parameters: nil, encoding: JSONEncoding.default, headers: nil)
//                .subscribe { data in
//                    data.responseJSON { response in
//                        switch response.result {
//                            case .success:
//                                if let data = response.data {
//                                    guard let hero: Hero = try? JSONDecoder().decode(Hero.self, from: data) else {return}
//                                    print(hero.data.results.first?.name ?? "não achou nome")
//                                }
//                            case .failure:
//                                print("falhou")
//                        }
//                    }
//                } onError: { error in
//                    print(error)
//                } onCompleted: {
//
//                } onDisposed: {
//
//                }
//
//        }
//    }
    
    func validateResponseFromAPI() -> Observable<DataRequest> {
        let timestamp = Int(Date().timeIntervalSince1970)
        guard let hashData = "\(timestamp)\(privateKey)\(publicKey)".data(using: .utf8) else { return Observable.empty() }
        let hash = Insecure.MD5.hash(data: hashData).map{String(format: "%02hhx", $0)}.joined()
        let url = baseUrl + "/characters?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)&limit=1"
            
        return RxAlamofire.request(.get, url, parameters: nil, encoding: JSONEncoding.default, headers: nil)
    }

    func getResponseFromAPI() {
        validateResponseFromAPI()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                response.responseJSON(completionHandler: { data in
                    if let data = data.data {
                        guard let result: Hero = try? JSONDecoder().decode(Hero.self, from: data) else { return }
                        print(result.data.results.first?.name ?? "nada")
                    }
                })
            }, onError: { error in
                print(error)
            })
    }
    
//    func getAllCharacters() -> Single<Hero>? {
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
//
}

extension DataRequest {
    func validateResponse() -> Single<Data> {
        return Single.create { observer in
            self.responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    observer(.success(data))
                case .failure(let error):
                    observer(.error(error))
                }
            })
            return Disposables.create()
        }
    }
}
