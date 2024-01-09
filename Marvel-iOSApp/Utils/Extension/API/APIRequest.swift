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
    
    // MARK: 1 It's better to move all the values that will not change to a single class, and them use all from there (urls in an url class and numbers and informations to one of values constants. Don't forget that you key is private, maybe it's better if you use some kind of criptography or leave it blank to be fill when the tester or someone else use your code.
    let publicKey: String = "d45266d7de590f0008fb57ac7c925be6"
    let privateKey: String = "39c52df0c1a74c0b4e5d635057241a8d09ed23da"
    
    let urlController = UrlClass()
    
    //MARK: Create URL to get All characters from API
    private func validateRequestToGetAllCharacters(limit: Int, offset: Int) -> Observable<DataRequest> {
        
        let timestamp = Int(Date().timeIntervalSince1970)
        let hashData = "\(timestamp)\(privateKey)\(publicKey)".data(using: .utf8)!
        let hash = Insecure.MD5.hash(data: hashData).map{String(format: "%02hhx", $0)}.joined()
        
        let parameters: [String: Any] = [
            "apikey" : publicKey,
            "ts" : "\(timestamp)",
            "hash" : hash,
            "limit": limit,
            "offset": offset
        ]
        
        let url = urlController.baseUrl + "/characters"
        
        return RxAlamofire.request(.get, url, parameters: parameters, encoding: URLEncoding.default, headers: nil)
    }
    
    //MARK: Create Observable to send to Dashboard
    func createObservableForTheAllCharactersRequisition(heroesToSearch: Int = 100, heroesToSkip: Int = 0) -> Observable<Data> {
        return validateRequestToGetAllCharacters(limit: heroesToSearch, offset: heroesToSkip)
            .responseData()
            .flatMap({ response -> Observable<Data> in
                let data = try JSONDecoder().decode(Data.self, from: response.1)
                return Observable.just(data)
            })
    }
    
    //MARK: Create URL to get a Single character from API
    private func validateRequestToGetSingleHero(characterId: Int) -> Observable<DataRequest> {
        let timestamp = Int(Date().timeIntervalSince1970)
        let hashData = "\(timestamp)\(privateKey)\(publicKey)".data(using: .utf8)!
        let hash = Insecure.MD5.hash(data: hashData).map{String(format: "%02hhx", $0)}.joined()
        
        let parameters: [String: Any] = [
            "apikey" : publicKey,
            "ts" : "\(timestamp)",
            "hash" : hash
        ]
        
        let url = urlController.baseUrl + "/characters/\(characterId)"
        
        return RxAlamofire.request(.get, url, parameters: parameters, encoding: URLEncoding.default, headers: nil)
    }
    
    //MARK: create Single for SingleHero Requisition
    func createSingleToSingleHeroRequisition(characterId: Int) -> Single<Data> {
        return validateRequestToGetSingleHero(characterId: characterId)
            .responseData()
            .flatMap { response -> Single<Data> in
                let data = try JSONDecoder().decode(Data.self, from: response.1)
                return Single.just(data)
            }
            .asSingle()
    }

}
