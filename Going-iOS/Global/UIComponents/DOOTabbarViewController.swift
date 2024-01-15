//
//  DOOTabbarViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/15/24.
//

import UIKit

import SnapKit

final class DOOTabbarViewController: UITabBarController {
        
    let ourTODoVC = UINavigationController(rootViewController: OurToDoViewController())
    let myToDoVC = UINavigationController(rootViewController: MyToDoViewController())
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        ourTODoVC.tabBarItem = UITabBarItem(title: nil, image: ImageLiterals.TabBar.tabbarOurToDoUnselected, tag: 0)
        
        myToDoVC.tabBarItem = UITabBarItem(title: nil, image: ImageLiterals.TabBar.tabbarMyToDoUnselected, tag: 1)
        
        self.viewControllers = [ourTODoVC, myToDoVC]
        
        self.selectedIndex = 0
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white000
        tabBarAppearance.stackedItemSpacing = 110
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarAppearance.inlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = tabBarItemAppearance
        
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = ScreenUtils.getHeight(90)
        tabBar.frame.origin.y = view.frame.height - 90
    }
}
