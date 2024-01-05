//
//  TravelTestViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/6/24.
//

import UIKit

import SnapKit

final class TravelTestViewController: UIViewController {
    
    // MARK: - Properties
    
    let travelTestDummy = TravelTestQuestionStruct.travelTestDummy
    
    // MARK: - UI Properties
    
    private let navigationBar: NavigationView = {
        let nav = NavigationView()
        nav.titleLabel.text = "이번 여행은!"
        return nav
    }()
    
    private let layout = UICollectionViewFlowLayout()
    
    private lazy var travelTestCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    private lazy var nextButton: DOOButton = {
        let btn = DOOButton(type: .unabled, title: "다음")
        btn.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierachy()
        setLayout()
        setCollectionView()
        setDelegate()
    }

    
    // MARK: - @objc Methods
    
    // TODO: - 분기처리 필요
    
    @objc
    func nextButtonTapped() {
        let vc = JoiningSuccessViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Private Extension

private extension TravelTestViewController {
    func setStyle() {
        view.backgroundColor = .white000
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierachy() {
        view.addSubviews(navigationBar,
                         travelTestCollectionView,
                         nextButton)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        travelTestCollectionView.snp.makeConstraints {
            // TODO: - DOONav로 바꾸고나서 top 레이아웃 수정
            $0.top.equalTo(navigationBar.snp.bottom).offset(3)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-28)
        }

        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
    }
    
    func setCollectionView() {
        travelTestCollectionView.collectionViewLayout = layout
        travelTestCollectionView.backgroundColor = .gray200
        travelTestCollectionView.showsVerticalScrollIndicator = false
        travelTestCollectionView.delegate = self
        travelTestCollectionView.dataSource = self
        travelTestCollectionView.register(TravelTestCollectionViewCell.self,
                                          forCellWithReuseIdentifier: TravelTestCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        
    }
}

// MARK: - Extensions

extension TravelTestViewController: UICollectionViewDelegate { }

extension TravelTestViewController: UICollectionViewDelegateFlowLayout {
    /// minimun item spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 12
    }
    
    /// cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ScreenUtils.getWidth(327)
        let height = ScreenUtils.getHeight(133)
        return CGSize(width: width, height: height)
    }
    
    /// content margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
    }
}
