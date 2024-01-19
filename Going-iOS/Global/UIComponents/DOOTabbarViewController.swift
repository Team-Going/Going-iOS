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
    
    private let divideLineView = UIView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = ScreenUtils.getHeight(90)
        tabBar.frame.origin.y = view.frame.height - ScreenUtils.getHeight(90)
    }
    
    func setHierarchy() {
        self.tabBar.addSubview(divideLineView)

    }
    
    func setStyle() {
        self.tabBar.tintColor = .red500
        ourTODoVC.tabBarItem = UITabBarItem(title: nil, image: ImageLiterals.TabBar.tabbarOurToDoUnselected.withRenderingMode(.alwaysTemplate), selectedImage: ImageLiterals.TabBar.tabbarOurToDoSelected.withRenderingMode(.alwaysTemplate))
        ourTODoVC.tabBarItem.imageInsets = UIEdgeInsets(top: ScreenUtils.getHeight(12), left: 0, bottom: ScreenUtils.getHeight(-12), right: ScreenUtils.getWidth(-15))
        
        myToDoVC.tabBarItem = UITabBarItem(title: nil, image: ImageLiterals.TabBar.tabbarMyToDoUnselected.withRenderingMode(.alwaysTemplate), selectedImage: ImageLiterals.TabBar.tabbarMyToDoSelected.withRenderingMode(.alwaysTemplate))
        myToDoVC.tabBarItem.imageInsets = UIEdgeInsets(top: ScreenUtils.getHeight(12), left: ScreenUtils.getWidth(-15), bottom: ScreenUtils.getHeight(-12), right: 0)
        
        
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
    
    func setLayout() {
        divideLineView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
}
