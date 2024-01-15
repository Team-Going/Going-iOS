//
//  DashBoardViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/7/24.
//

import UIKit

class DashBoardViewController: UIViewController {
    
    // MARK: - Properties
    
    var tripId: Int = 0
    
    private var travelListDummy: DashBoardResponseSturct? {
        didSet {
            filterTravels()
            setNaviTitle()
        }
    }
    private lazy var filteredTravelList: [Trip] = []
    
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
        btn.addTarget(self, action: #selector(pushToSettingsVC), for: .touchUpInside)
        return btn
    }()
    
    private let dashBoardHeaderView = DashBoardHeaderView()
    
    private let dashBoardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let noDataview: UIView = {
        let view = UIView()
        view.backgroundColor = .gray50
        return view
    }()
    private let noDataLabel = DOOLabel(font: .pretendard(.body3_medi), color: .gray200, text: "새로운 여행을 시작해 보세요")
    private let characterImage:  UIImageView = {
        let img = UIImageView()
        img.image = ImageLiterals.DashBoard.imgDashBoard
        return img
    }()
    
    private lazy var createTravelButton: DOOButton = {
        let btn = DOOButton(type: .enabled, title: "여행 추가하기")
        btn.addTarget(self, action: #selector(pushToCreateTravelVC), for: .touchUpInside)
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
    
    override func viewWillAppear(_ animated: Bool) {
        getAllData()
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
                              noDataview,
                              gradientView,
                              createTravelButton)
        dashBoardNavigationBar.addSubviews(navigationTitle, settingsButton)
        noDataview.addSubviews(noDataLabel, characterImage)
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
        
        setNoDataView()
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
        guard let travelListDummy else { return }
        self.navigationTitle.text = travelListDummy.name + "님의 여행"
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
    
    func setNoDataView() {
        guard let travelListDummy else { return }
        if travelListDummy.trips.isEmpty {
            noDataview.snp.makeConstraints {
                $0.top.equalTo(dashBoardHeaderView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(createTravelButton.snp.top)
            }
            noDataLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(107)
                $0.leading.equalToSuperview().inset(109)
            }
            characterImage.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.width.equalTo(ScreenUtils.getWidth(236))
                $0.height.equalTo(ScreenUtils.getHeight(364))
                $0.top.equalTo(noDataLabel.snp.top).offset(40)
            }
        } else {
            dashBoardCollectionView.snp.makeConstraints {
                $0.top.equalTo(dashBoardHeaderView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(createTravelButton.snp.top)
            }
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    func pushToCreateTravelVC() {
        let vc = CreateTravelViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func didChangeValue(sender: UISegmentedControl) {
        getAllData()
    }
    
    @objc
    func pushToSettingsVC() {
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

extension DashBoardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = OurToDoViewController()
        tripId = travelListDummy?.trips[indexPath.row].tripID ?? 0
        vc.tripId = self.tripId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

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

// MARK: - Network

private extension DashBoardViewController {
    func handleError(_ error: NetworkError) {
        print(error)
    }
    
    func getAllData() {
        Task {
            do {
                self.travelListDummy = try await TravelService.shared.getAllTravel(status: dashBoardHeaderView.segmentedControl.selectedSegmentIndex == 0 ? "incomplete" : "complete")
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
    
    func filterTravels() {
        guard let travelListDummy else { return }
        if dashBoardHeaderView.segmentedControl.selectedSegmentIndex == 0 {
            // 진행 중인 여행 필터링
            filteredTravelList = travelListDummy.trips.filter { $0.day >= 0}
        } else {
            // 완료된 여행 필터링
            filteredTravelList = travelListDummy.trips.filter { $0.day < 0}
        }
        dashBoardCollectionView.reloadData()
    }
}
