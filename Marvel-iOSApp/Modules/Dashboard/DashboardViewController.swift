//
//  ViewController.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 13/12/23.
//

import UIKit
import RxSwift

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var apiRequest = APIRequest()
    private var heroesArray: [Hero] = []
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        getDataFromAPI()
    }
    
    private func getDataFromAPI(){
        apiRequest.getResponseFromAPI()
    }
    
//    private func getDataFromAPI() {
//        apiRequest.getAllCharacters()?
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
//            .observeOn(MainScheduler.instance)
//            .subscribe(onSuccess: { hero in
//                print("ESTOU AQUI \(hero.data.results.first?.name)")
//            }, onError: { error in
//                print(error)
//            })
//            .disposed(by: disposeBag)
//    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupSearchBar(){
        searchBar.searchTextField.font = .systemFont(ofSize: 13.0)
    }

}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath)
        return cell
    }
    
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) / 3.0
        return CGSize(width: width, height: 100)
    }
    
}

