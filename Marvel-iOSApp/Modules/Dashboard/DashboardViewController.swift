//
//  ViewController.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 13/12/23.
//

import UIKit
import RxSwift

class DashboardViewController: HelperController {

    @IBOutlet weak var barForPagination: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    private var currentPage = 0
    
    private var apiRequest = APIRequest()
    private var limit = 100
    private var offset = 0
    private var total = 1563

    private var heroesArray: [Hero] = []
    private var customHeroesArray: [Hero] = []
    
    //referencia da tabBar --> para enviar a array populada
    private weak var delegateTabBar: TabBarDelegate?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromAPI(offset: offset)
        startAllSetupFunctions()
    }
    
    //removi a array
    func initView(delegate: TabBarDelegate) {
        self.delegateTabBar = delegate
    }
    
    private func startAllSetupFunctions() {
        setupSearchBar()
        setupCollectionView()
        setupLoadingAlert()
        pageControl.numberOfPages = 16 //1563 heroes total, vem 100 por req ...
        updatePageControl()
    }
    
    private func getDataFromAPI(offset: Int) {
        //max 100 heroes por requisição
        //se nao passar limite ele vai por padrão 20
        //ADICIONAR PARAMETRO 'offset' (procura a partir de um num)
        
        if self.offset < self.total {
            showLoadingAlert()
            
            customHeroesArray.removeAll()
            
            apiRequest.getAllCharacters(heroesToSearch: limit, heroesToSkip: offset)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { response in
                    response.data.results.forEach {
                        let imgUrl = ($0.thumbnail.path + "." + $0.thumbnail.extension_).replacingOccurrences(of: "http", with: "https")
                        
                        let hero: Hero = Hero(id: $0.id, name: $0.name, description: $0.description, img: imgUrl, comicsAvailables: $0.comics.available)
                        self.heroesArray.append(hero)
                        self.customHeroesArray.append(hero)
                    }
                    
//                    self.offset = self.limit + self.offset
                    
//                    self.setupCustomHeroesArrayToDefault()
                    
                    //envia a referencia do objeto que sera manipulado para a TabBar
                    self.delegateTabBar?.setHeroesArray(self.heroesArray)
                    
                    self.collectionView.reloadData()
                    self.dismissLoadingAlert()
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag) //evitar memory leak --> liberar recurso
        }
        
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
    
//    private func setupCustomHeroesArrayToDefault() {
//        customHeroesArray.removeAll()
//        customHeroesArray.append(contentsOf: heroesArray)
//    }

    private func updatePageControl() {
        if currentPage == 0 {
            leftButton.isHidden = true
        } else if currentPage == pageControl.numberOfPages {
            rightButton.isHidden = true
        } else {
            leftButton.isHidden = false
            rightButton.isHidden = false
        }
        pageControl.currentPage = currentPage
    }
    
    @IBAction func goToNextPage(_ sender: Any) {
        if currentPage < pageControl.numberOfPages {
            currentPage += 1
            updatePageControl()
            self.offset = self.limit + self.offset
            getDataFromAPI(offset: self.offset)
        }
    }
    
    @IBAction func backToPreviousPage(_ sender: Any) {
        if currentPage > 0 {
            currentPage -= 1
            updatePageControl()
            self.offset = self.offset - limit
            getDataFromAPI(offset: self.offset)
        }
    }
    
}

extension DashboardViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        setupCustomHeroesArrayToDefault()
        
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
//        setupCustomHeroesArrayToDefault()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleHeroVC = UIStoryboard(name: "SingleHero", bundle: nil).instantiateViewController(withIdentifier: "SingleHero") as! SingleHeroViewController
        singleHeroVC.initView(hero: customHeroesArray[indexPath.row])
        navigationController?.pushViewController(singleHeroVC, animated: true)
    }
    
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 2.0
        return CGSize(width: width, height: width)
    }
    
}
