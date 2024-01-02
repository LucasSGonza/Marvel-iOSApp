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
    
    //MARK: Create URL to send to API
    //esses parametros são para serem usados na Dashboard, definindo limit e offset de cada req
    func validateRequestFromAPI(limit: Int, offset: Int) -> Observable<DataRequest> {
        let timestamp = Int(Date().timeIntervalSince1970)
        let hashData = "\(timestamp)\(privateKey)\(publicKey)".data(using: .utf8)!
        let hash = Insecure.MD5.hash(data: hashData).map{String(format: "%02hhx", $0)}.joined()
        
        let url = baseUrl +  "/characters?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)&limit=\(limit)&offset=\(offset)"
        
        return RxAlamofire.request(.get, url, parameters: nil, encoding: JSONEncoding.default, headers: nil)
    }
    
    //MARK: Create the Observable to send to Dashboard
    func createObservableForTheRequisition(heroesToSearch: Int = 100, heroesToSkip: Int) -> Observable<Data> {
        return validateRequestFromAPI(limit: heroesToSearch, offset: heroesToSkip)
            .responseData()
            .flatMap({ response -> Observable<Data> in
                let data = try JSONDecoder().decode(Data.self, from: response.1)
                return Observable.just(data)
            })
    }

}
