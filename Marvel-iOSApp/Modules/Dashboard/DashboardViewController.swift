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
    
    private var delegate: FavoriteListDelegate?
    private var apiRequest = APIRequest()
    private var heroesArray: [Hero] = []
    private var customHeroesArray: [Hero] = []
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromAPI()
        startAllSetupFunctions()
    }
    
    private func startAllSetupFunctions() {
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
                self.setupCustomHeroesArrayToDefault()
                //passar info pra favoriteScreen
                self.delegate?.setHeroesArray(self.heroesArray)
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
        collectionView.register(UINib(nibName: "CollectionViewCellHeroCell", bundle: nil), forCellWithReuseIdentifier: "CollectionHeroCell")
    }
    
    private func setupSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.searchTextField.font = .systemFont(ofSize: 13.0)
        searchBar.delegate = self
        searchBar.keyboardType = .default
    }
    
    private func setupCustomHeroesArrayToDefault() {
        customHeroesArray.removeAll()
        customHeroesArray.append(contentsOf: heroesArray)
    }

}

extension DashboardViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setupCustomHeroesArrayToDefault()
        
        if !searchText.isEmpty {
            customHeroesArray = customHeroesArray.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        setupCustomHeroesArrayToDefault()
        collectionView.reloadData()
        self.view.endEditing(true)
    }
        
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customHeroesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionHeroCell", for: indexPath) as! CollectionViewCellHeroCell
        cell.bind(hero: customHeroesArray[indexPath.row])
        return cell
    }
    
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 2.0
        return CGSize(width: width, height: width)
    }
    
}

