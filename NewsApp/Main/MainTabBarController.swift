//
//  ViewController.swift
//  NewsApp
//
//  Created by Leyla Nyssanbayeva on 09.03.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().isTranslucent = false
        
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor.black.cgColor
        
        tabBar.tintColor = Colors.emerald
        
        setupViewControllers()
    }
    
    func setupViewControllers() {
        // настраивает размер иконок
        let configuration = UIImage.SymbolConfiguration(pointSize: 18)
        
        viewControllers = [
            wrapNavigationController(
                with: TopHeadlinesViewController(),
                tabTitle: "Top",
                tabImage: UIImage(systemName: "heart.text.square", withConfiguration: configuration)!
            ),
            wrapNavigationController(
                with: AllNewsViewController(),
                tabTitle: "All",
                tabImage: UIImage(systemName: "newspaper", withConfiguration: configuration)!
            ),
            wrapNavigationController(
                with: SavedNewsViewController(),
                tabTitle: "Saved",
                tabImage: UIImage(systemName: "bookmark", withConfiguration: configuration)!
            )
        ]
    }

    func wrapNavigationController(with rootViewController: UIViewController,
                                  tabTitle: String,
                                  tabImage: UIImage) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = tabTitle
        navigationController.tabBarItem.image = tabImage
        return navigationController
    }

}

