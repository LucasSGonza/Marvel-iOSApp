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
        getDataFromAPI()
        setupSearchBar()
        setupCollectionView()
    }
    
    private func getDataFromAPI() {
        //max 100 heroes por requisição
        //se nao passar limite ele vai por padrão 20
        apiRequest.getAllCharacters(numberOfHeroesToSearch: 100)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { hero in
//                print(hero)
                hero.data.results.forEach {
                    let imgUrl = ($0.thumbnail.path + "." + $0.thumbnail.extension_).replacingOccurrences(of: "http", with: "https")
                    
                    let hero: Hero = Hero(id: $0.id, name: $0.name, description: $0.description, img: imgUrl)
                    self.heroesArray.append(hero)
                }
                self.collectionView.reloadData()
            }, onError: { erro in
                print(erro)
            }, onCompleted: {
                print("terminou")
            }, onDisposed: {
                print("saiu da memoria")
            })
            .disposed(by: disposeBag)
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
        collectionView.register(UINib(nibName: "CollectionViewCellHeroCell", bundle: nil), forCellWithReuseIdentifier: "HeroCell")
    }
    
    private func setupSearchBar() {
        searchBar.searchTextField.font = .systemFont(ofSize: 13.0)
    }

}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath) as! CollectionViewCellHeroCell
        cell.bind(hero: heroesArray[indexPath.row])
        return cell
    }
    
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 2.0
        return CGSize(width: width, height: 140)
    }
    
}

