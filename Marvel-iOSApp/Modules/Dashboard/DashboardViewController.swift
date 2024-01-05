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
    
    private var offsetsArray: [Int] = []
    private var offset: Int = 0
    private var total: Int = 0

    private var heroesArray: [Hero] = []
    private var customHeroesArray: [Hero] = []
    
    //referencia da tabBar --> para enviar a array populada
    private weak var delegateTabBar: TabBarDelegate?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromAPI()
        startAllSetupFunctions()
    }
    
    //MARK: Init functions
    func initView(delegate: TabBarDelegate) {
        self.delegateTabBar = delegate
    }
    
    private func startAllSetupFunctions() {
        setupSearchBar()
        setupCollectionView()
        setupLoadingAlert()
        updateVisualOfPageControl()
    }
    
    //MARK: Get Data from API
    private func getDataFromAPI() {
        showLoadingAlert()
       
        apiRequest.createObservableForTheAllCharactersRequisition()
            .flatMap { result -> Observable<Data> in
                
                /*
                 1° pegar o total e construir os offsets necessários para pegar todos os heroes
                 2º criar uma array com esses offsets, para utilizar o Observable.from()
                 3° retornar esse Obsersable no flatMap
                */
                
                self.total = result.data.total
                let requestsToDo = (self.total / 100) + 1 //1563 / 100 =~ 15
                print("Requests to do: \(requestsToDo)")
                
                for _ in 0..<requestsToDo {
                    //offset começa em 0
                    print(self.offset)
                    self.offsetsArray.append(self.offset)
                    self.offset += 100
                }
                
                print("Numero de offsets: \(self.offsetsArray.count)")
                
                let offsetArrayTesteRapidao = [0]
                
                return Observable.from(offsetArrayTesteRapidao)
                    .flatMap { offset -> Observable<Data> in
                        return self.apiRequest.createObservableForTheAllCharactersRequisition(heroesToSearch: 5, heroesToSkip: offset)
                            .asObservable()
                    }
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                print("Count offset \(response.data.offset): \(response.data.count)")
                response.data.results.forEach {
                    //create a obj Hero
                    let imgUrl = ($0.thumbnail.path + "." + $0.thumbnail.extension_).replacingOccurrences(of: "http", with: "https")
                    let hero: Hero = Hero(id: $0.id, name: $0.name, description: $0.description, img: imgUrl, reqOffset: response.data.offset)
                    self.heroesArray.append(hero)
                }
            }, onError: { error in
                print("Error: \(error)")
            }, onCompleted: {
                //envia a referencia do objeto que sera manipulado para a TabBar
                self.delegateTabBar?.setHeroesArray(self.heroesArray)
                //ordena os personagens em ordem alfabetica
                self.heroesArray = self.heroesArray.sorted { $0.name < $1.name }
                //popula a array custom
                self.setupCustomHeroesArrayToDefault()
                //define os heroes a serem exibidos na tela inicial (inicial = pagina '0')
                self.setHeroesBasedOnActualPage()
                //da reload, define o numero de paginas e tira o alerta
                self.collectionView.reloadData()
                self.pageControl.numberOfPages = (self.total / 100) //1563 heroes total, limit 100 por req
                self.dismissLoadingAlert()
            })
            .disposed(by: disposeBag) //evitar memory leak --> liberar recurso
    }
    
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

    private func updateVisualOfPageControl() {
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
    
    private func setHeroesBasedOnActualPage() {
//        print(combinePageAndOffsetAndReturnIt(currentPage: self.currentPage))
        setupCustomHeroesArrayToDefault()
        customHeroesArray = customHeroesArray.filter{
            $0.reqOffset == (currentPage * 100)
        }
        collectionView.reloadData()
    }
    
    @IBAction func goToNextPage(_ sender: Any) {
        if currentPage < pageControl.numberOfPages {
            currentPage += 1
            updateVisualOfPageControl()
            setHeroesBasedOnActualPage()
        }
    }
    
    @IBAction func backToPreviousPage(_ sender: Any) {
        if currentPage > 0 {
            currentPage -= 1
            updateVisualOfPageControl()
            setHeroesBasedOnActualPage()
        }
    }
    
}

//MARK: Searchbar
extension DashboardViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setHeroesBasedOnActualPage()
        if !searchText.isEmpty {
            customHeroesArray = heroesArray.filter {
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
        setHeroesBasedOnActualPage()
        collectionView.reloadData()
        self.view.endEditing(true)
    }
        
}

//MARK: Collection View
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
        let hero = customHeroesArray[indexPath.row]
        let singleHeroVC = UIStoryboard(name: "SingleHero", bundle: nil).instantiateViewController(withIdentifier: "SingleHero") as! SingleHeroViewController
        
        apiRequest.createSingleToSingleHeroRequisition(characterId: hero.id)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { response in
                
                hero.comicsAvailables = response.data.results.first?.comics.available
                hero.seriesAvailables = response.data.results.first?.series.available
                hero.storiesAvailables = response.data.results.first?.stories.available
                hero.eventsAvailables = response.data.results.first?.events.available
                
                singleHeroVC.initView(hero: hero)
                print("Single Hero req = success")
                self.navigationController?.pushViewController(singleHeroVC, animated: true)
            }, onError: { error in
                print("Error in DashboardVC when trying to select a row:\n\(error)")
            })
            .disposed(by: disposeBag)
    }
    
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 2.0
        return CGSize(width: width, height: width)
    }
    
}
