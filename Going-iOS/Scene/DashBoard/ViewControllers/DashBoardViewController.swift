//
//  DashBoardViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/7/24.
//

import UIKit

class DashBoardViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var travelListDummy = TravelInfoStruct.travelInfoDummy
    private lazy var filteredTravelList: [TravelDetailStruct] = []
    
    // MARK: - UI Properties
    
    private let dashBoardNavigationBar: UIView = {
        let nav = UIView()
        nav.backgroundColor = .white000
        return nav
    }()
    
    private var navigationTitle = DOOLabel(font: .pretendard(.head1), color: .gray700)
    
    // TODO: - 뷰 연결
    private lazy var settingsButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.DashBoard.btnSetting, for: .normal)
        btn.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let dashBoardHeaderView = DashBoardHeaderView()
    
    private let dashBoardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var createTravelButton: DOOButton = {
        let btn = DOOButton(type: .enabled, title: "여행 생성하기")
        btn.addTarget(self, action: #selector(createTravelButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let gradientView =  UIView()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.didChangeValue(sender: self.dashBoardHeaderView.segmentedControl)
        
        setStyle()
        setHierarchy()
        setLayout()
        setDelegate()
        registerCell()
        setCollectionView()
        setSegment()
        setNaviTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setGradient()
    }
}

// MARK: - Private Extension

private extension DashBoardViewController {
    
    func setStyle() {
        self.view.backgroundColor = .white000
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        self.view.addSubviews(dashBoardNavigationBar, 
                              dashBoardHeaderView,
                              dashBoardCollectionView,
                              gradientView,
                              createTravelButton)
        dashBoardNavigationBar.addSubviews(navigationTitle, settingsButton)
    }
    
    func setLayout() {
        dashBoardNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(ScreenUtils.getHeight(68))
            $0.width.equalToSuperview()
        }
        
        navigationTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        settingsButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        dashBoardHeaderView.snp.makeConstraints {
            $0.top.equalTo(dashBoardNavigationBar.snp.bottom)
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalToSuperview()
        }
        
        dashBoardCollectionView.snp.makeConstraints {
            $0.top.equalTo(dashBoardHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(createTravelButton.snp.top)
        }
        
        createTravelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
        
        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(createTravelButton.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(40))
        }
    }
    
    func setDelegate() {
        dashBoardCollectionView.delegate = self
        dashBoardCollectionView.dataSource = self
    }
    
    func registerCell() {
        dashBoardCollectionView.register(DashBoardCollectionViewCell.self,
                                         forCellWithReuseIdentifier: DashBoardCollectionViewCell.cellIdentifier)
    }
    
    func setNaviTitle() {
        self.navigationTitle.text = travelListDummy.userName + "님의 여행"
    }
    
    func setCollectionView() {
        dashBoardCollectionView.backgroundColor = .gray50
        dashBoardCollectionView.showsVerticalScrollIndicator = false
    }
    
    func setSegment() {
        dashBoardHeaderView.segmentedControl.addTarget(self,
                                                       action: #selector(didChangeValue(sender:)),
                                                       for: .valueChanged)
    }
    
    func setGradient() {
        gradientView.setGradient(firstColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0), secondColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), axis: .vertical)
    }
    
    // MARK: - @objc Methods
    
    @objc
    func createTravelButtonTapped() {
        let vc = CreateTravelViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func didChangeValue(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // 진행 중인 여행 필터링
            filteredTravelList = travelListDummy.detailInfos.filter { $0.dueDate >= 0}
        } else {
            // 완료된 여행 필터링
            filteredTravelList = travelListDummy.detailInfos.filter { $0.dueDate < 0}
        }
        dashBoardCollectionView.reloadData()
    }
    
    @objc
    func settingsButtonTapped() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DashBoardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTravelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dashBoardCollectionView.dequeueReusableCell(withReuseIdentifier: DashBoardCollectionViewCell.cellIdentifier, for: indexPath) as? DashBoardCollectionViewCell else { return UICollectionViewCell() }
        
        cell.travelDetailData = filteredTravelList[indexPath.row]
        return cell
    }
}

extension DashBoardViewController: UICollectionViewDelegate { }

extension DashBoardViewController: UICollectionViewDelegateFlowLayout {
    /// minimun item spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    /// cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ScreenUtils.getWidth(327)
        let height = ScreenUtils.getHeight(76)
        return CGSize(width: width, height: height)
    }
    
    /// content margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
    }
}
