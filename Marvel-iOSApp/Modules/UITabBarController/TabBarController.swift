//
//  TabBarController.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 14/12/23.
//

import UIKit

//https://www.youtube.com/watch?v=AoQb6Dy6l04

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarViewControllers()
        setupTabBarVisual()
    }
    
    //MARK: setup visual of tabBar
    private func setupTabBarVisual() {
        self.tabBar.barTintColor = UIColor(named: "barColor") ?? UIColor.gray
        self.tabBar.tintColor = UIColor(named: "barSelectedItemColor")
        self.tabBar.unselectedItemTintColor = UIColor(named: "barUnselectedItemColor")
        self.tabBar.isTranslucent = true
    }
    
    //MARK: setup VC in TabBar
    private func setupTabBarViewControllers() {
        
        //cria as ViewControllers que irão para a tabBar
        let dashboardVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "Dashboard") as! DashboardViewController
        let favoriteScreenVC = UIStoryboard(name: "FavoriteScreen", bundle: nil).instantiateViewController(withIdentifier: "FavoriteScreen") as! FavoriteScreenViewController
        
        //cria uma navigation para cada viewController
        let dashboard = self.createNav(title: "Dashboard", image: UIImage(systemName: "house.fill"), vc: dashboardVC)
        let favoriteScreen = self.createNav(title: "Favorite", image: UIImage(systemName: "star.fill"), vc: favoriteScreenVC)
        
        self.setViewControllers([dashboard, favoriteScreen], animated: false)
    }
    
    //MARK: Create nav for each VC
    private func createNav(title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
//        nav.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Button", style: .plain, target: nil, action: nil)
        return nav
    }
    
}

extension TabBarController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected: \(item.title!)")
    }
}
