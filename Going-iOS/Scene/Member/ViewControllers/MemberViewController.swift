//
//  MemberViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/14/24.
//

import UIKit

import SnapKit

class MemberViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("여행 친구들"))
    private let navigationUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let memeberTitleLabel = DOOLabel(font: .pretendard(.body3_bold), color: .gray700, text: "멤버")
    private lazy var tripFriendsCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        view.backgroundColor = UIColor.white000
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        return view
    }()
    
    private let ourTasteTitleLabel = DOOLabel(font: .pretendard(.body3_bold), color: .gray700, text: "우리의 이번 여행은!")
    
    private let ourTestResultView = MemberTestResultView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setHierarchy()
        setLayout()
        registerCell()
        setDelegate()
    }
}

// MARK: - Private Extension

private extension MemberViewController {
    func setStyle() {
        self.view.backgroundColor = .white000
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         navigationUnderLineView,
                         memeberTitleLabel,
                         tripFriendsCollectionView,
                         ourTasteTitleLabel,
                         ourTestResultView)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        navigationUnderLineView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        memeberTitleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        tripFriendsCollectionView.snp.makeConstraints {
            $0.top.equalTo(memeberTitleLabel.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(67))
        }
        
        ourTasteTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tripFriendsCollectionView.snp.bottom).offset(26)
            $0.leading.equalToSuperview().inset(24)
        }
        
        ourTestResultView.snp.makeConstraints {
            $0.top.equalTo(ourTasteTitleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(ScreenUtils.getHeight(505))
        }
    }
    
    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.itemSize = CGSize(width: ScreenUtils.getHeight(48) , height: ScreenUtils.getHeight(67))
        return flowLayout
    }
    
    func registerCell() {
        tripFriendsCollectionView.register(TripFriendsCollectionViewCell.self, forCellWithReuseIdentifier: TripFriendsCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        tripFriendsCollectionView.delegate = self
        tripFriendsCollectionView.dataSource = self
    }
}

extension MemberViewController: UICollectionViewDelegateFlowLayout { }

extension MemberViewController: UICollectionViewDelegate { }

extension MemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tripFriendsCollectionView.dequeueReusableCell(withReuseIdentifier: TripFriendsCollectionViewCell.cellIdentifier, for: indexPath) as? TripFriendsCollectionViewCell else { return UICollectionViewCell() }
//        cell.bindData(data: Friend.friendData[indexPath.row])
        return cell
    }
}
