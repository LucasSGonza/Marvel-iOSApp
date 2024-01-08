//
//  FavoriteScreenViewController.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 14/12/23.
//

import UIKit

class FavoriteScreenViewController: HelperController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var heroesArray: [Hero] = []
    private var customHeroesArray: [Hero] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        startAllSetupFunctions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupCustomHeroesArrayToDefault()
        tableView.reloadData()
    }
    
    private func startAllSetupFunctions() {
//        setupLoadingAlert()
        setupTableView()
        setupSearchBar()
        setupCustomHeroesArrayToDefault()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCellHeroCell", bundle: nil), forCellReuseIdentifier: "TableHeroCell")
    }
    
    private func setupSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.searchTextField.font = .systemFont(ofSize: 13.0)
        searchBar.delegate = self
        searchBar.keyboardType = .default
    }
    
    private func setupCustomHeroesArrayToDefault() {
        customHeroesArray.removeAll()
        customHeroesArray.append(contentsOf: heroesArray.filter{$0.isFavorite})
    }
    
}

//espaçamento entre table view cells: https://stackoverflow.com/questions/6216839/how-to-add-spacing-between-uitableviewcell

extension FavoriteScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return customHeroesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableHeroCell", for: indexPath) as! TableViewCellHeroCell
        cell.bind(hero: customHeroesArray[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.width / 2)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleHeroVC = UIStoryboard(name: "SingleHero", bundle: nil).instantiateViewController(withIdentifier: "SingleHero") as! SingleHeroViewController
        singleHeroVC.initView(hero: customHeroesArray[indexPath.section])
        navigationController?.pushViewController(singleHeroVC, animated: true)
    }
    
}

extension FavoriteScreenViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setupCustomHeroesArrayToDefault()
        
        if !searchText.isEmpty {
            customHeroesArray = customHeroesArray.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        setupCustomHeroesArrayToDefault()
        tableView.reloadData()
        self.view.endEditing(true)
    }
    
}

extension FavoriteScreenViewController: FavoriteScreenDelegate {
    func setHeroesArray(_ heroesArray: [Hero]) {
        self.heroesArray = heroesArray
    }
}
