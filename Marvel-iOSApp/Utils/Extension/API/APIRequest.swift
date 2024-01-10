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
    
    let publicKey: String = "d45266d7de590f0008fb57ac7c925be6"
    let privateKey: String = ""
    
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
        
        let url = Constants.shared.baseUrl("characters")
        
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

}
