//
//  TabBarView.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/10/24.
//

import UIKit

import SnapKit

protocol TabBarDelegate: AnyObject {
    func tapOurToDo()
    func tapMyToDo()
}

final class TabBarView: UIView {

    // MARK: - UI Components
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .gray200)
        return view
    }()
    
    private let tabBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor(resource: .white000)
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    lazy var ourToDoTab: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(resource: .white000)
        btn.setImage(ImageLiterals.TabBar.tabbarOurToDoSelected, for: .normal)
        btn.setImage(ImageLiterals.TabBar.tabbarOurToDoSelected, for: .highlighted)
        btn.addTarget(self, action: #selector(tapOurToDoTabBar), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    lazy var myToDoTab: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(resource: .white000)
        btn.setImage(ImageLiterals.TabBar.tabbarMyToDoUnselected, for: .normal)
        btn.setImage(ImageLiterals.TabBar.tabbarMyToDoUnselected, for: .highlighted)
        btn.addTarget(self, action: #selector(tapMyToDoTabBar), for: .touchUpInside)
        btn.tag = 2
        return btn
    }()
    
    // MARK: - Properties
    
    weak var delegate: TabBarDelegate?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - objc method

    @objc
    func tapOurToDoTabBar() {
        self.delegate?.tapOurToDo()
    }
    
    @objc
    func tapMyToDoTabBar() {
        self.delegate?.tapMyToDo()
    }
}

// MARK: - private method

private extension TabBarView {
    func setHierarchy() {
        self.addSubviews(dividerView, tabBarStackView)
        tabBarStackView.addArrangedSubviews(ourToDoTab, myToDoTab)
    }
    
    func setLayout() {
        dividerView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        tabBarStackView.snp.makeConstraints{
            $0.top.equalTo(dividerView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(76))
            $0.bottom.equalToSuperview()
        }
        for tab in [ourToDoTab, myToDoTab] {
            tab.snp.makeConstraints{
                $0.size.equalTo(ScreenUtils.getHeight(56))
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
    }
}

// MARK: - extensions
