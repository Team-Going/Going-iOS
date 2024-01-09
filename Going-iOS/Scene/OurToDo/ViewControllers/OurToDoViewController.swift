import UIKit

import SnapKit

// TODO: - 네비바 & 탭바 추후 변경

final class OurToDoViewController: UIViewController {

    // MARK: - UI Property

    private lazy var contentView: UIView = UIView()
    private lazy var navigationBarview = DOONavigationBar(self, type: .backButtonOnly, backgroundColor: .gray50)
    private let tripHeaderView: TripHeaderView = TripHeaderView()
    private let tripMiddleView: TripMiddleView = TripMiddleView()
    private let ourToDoHeaderView: OurToDoHeaderView = OurToDoHeaderView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white000
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    private let stickyOurToDoHeaderView: OurToDoHeaderView = {
        let headerView = OurToDoHeaderView()
        headerView.isHidden = true
        headerView.backgroundColor = .white000
        return headerView
    }()
    private lazy var ourToDoCollectionView: UICollectionView = {setCollectionView()}()
    private let tabBarView: TabBarView = TabBarView()
    private lazy var addToDoButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red700
        btn.setTitle(" 같이 할일", for: .normal)
        btn.setTitleColor(.white000, for: .normal)
        btn.titleLabel?.font = .pretendard(.body1_bold)
        btn.setImage(ImageLiterals.OurToDo.btnPlusOurToDo, for: .normal)
        btn.imageView?.tintColor = .white000
        btn.addTarget(self, action: #selector(pushToAddToDoView), for: .touchUpInside)
        btn.semanticContentAttribute = .forceLeftToRight
        btn.layer.cornerRadius = ScreenUtils.getHeight(26)
        btn.isHighlighted = false
        return btn
    }()
    
    // MARK: - Property
    
    var ourToDoData: OurToDoData?
    var incompletedData: [OurToDo] = []
    var completedData: [OurToDo] = []

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        setHierarchy()
        setDelegate()
        setData()
        registerCell()
        setLayout()
        setStyle()
        setTapBarImage()
        self.didChangeValue(segment: self.ourToDoHeaderView.segmentedControl)
        self.didChangeValue(segment: self.stickyOurToDoHeaderView.segmentedControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        setGradient()
    }
    
    override func viewDidLayoutSubviews() {
        setGradient()
    }
}

// MARK: - Private method

private extension OurToDoViewController {
    
    func setHierarchy() {
        self.view.addSubviews(navigationBarview, tabBarView, scrollView, addToDoButton)
        scrollView.addSubviews(contentView, stickyOurToDoHeaderView)
        contentView.addSubviews(tripHeaderView, tripMiddleView, ourToDoHeaderView, ourToDoCollectionView)
    }
    
    func setLayout() {
        navigationBarview.snp.makeConstraints{
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(44))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(60))
        }
        tabBarView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(90))
        }
        scrollView.snp.makeConstraints{
            $0.top.equalTo(navigationBarview.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabBarView.snp.top)
        }
        contentView.snp.makeConstraints{
            $0.height.greaterThanOrEqualTo(ourToDoCollectionView.contentSize.height).priority(.low)
            $0.edges.width.equalTo(scrollView)
        }
        tripHeaderView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(ScreenUtils.getHeight(8))
            $0.height.equalTo(ScreenUtils.getHeight(95))
        }
        tripMiddleView.snp.makeConstraints{
            $0.top.equalTo(tripHeaderView.snp.bottom).offset(ScreenUtils.getHeight(20))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(235))
        }
        ourToDoHeaderView.snp.makeConstraints{
            $0.top.equalTo(tripMiddleView.snp.bottom).offset(ScreenUtils.getHeight(28))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(49))
        }
        ourToDoCollectionView.snp.makeConstraints{
            $0.top.equalTo(ourToDoHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(ourToDoCollectionView.contentSize.height).priority(.low)
        }
        stickyOurToDoHeaderView.snp.makeConstraints{
            $0.top.equalTo(navigationBarview.snp.bottom)
            $0.leading.trailing.width.equalTo(scrollView)
            $0.height.equalTo(ScreenUtils.getHeight(49))
        }
        addToDoButton.snp.makeConstraints{
            $0.width.equalTo(ScreenUtils.getWidth(117))
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.bottom.equalTo(scrollView).inset(ScreenUtils.getHeight(24))
        }
    }
    
    func loadData() {
        ourToDoCollectionView.reloadData()
        ourToDoCollectionView.layoutIfNeeded()
        
        // Update the constraint based on the new content size
        ourToDoCollectionView.snp.updateConstraints {
            $0.height.equalTo(ourToDoCollectionView.contentSize.height).priority(.low)
        }
    }
    
    func setStyle() {
        self.view.backgroundColor = .gray50
        self.navigationController?.navigationBar.barTintColor = .white000
        contentView.backgroundColor = .gray50
        tripHeaderView.isUserInteractionEnabled = true
        tripMiddleView.isUserInteractionEnabled = true
        ourToDoHeaderView.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        stickyOurToDoHeaderView.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
    }
    
    func setCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        collectionView.backgroundColor = .white000
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }
    
    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: ScreenUtils.getWidth(331) , height: ScreenUtils.getHeight(81))
        flowLayout.sectionInset = UIEdgeInsets(top: ScreenUtils.getHeight(18), left: 1.0, bottom: 1.0, right: 1.0)
        return flowLayout
    }
    
    func registerCell() {
        self.ourToDoCollectionView.register(OurToDoCollectionViewCell.self, forCellWithReuseIdentifier: OurToDoCollectionViewCell.identifier)
    }
    
    func setData() {
        self.ourToDoData = OurToDoData.ourToDoData
    
        for i in ourToDoData?.ourToDo ?? [] {
            i.isComplete ? completedData.append(i) : incompletedData.append(i)
        }
        
        tripHeaderView.tripData = [ourToDoData?.tripTitle ?? "", ourToDoData?.tripDeadline ?? "", ourToDoData?.tripStartDate ?? "", ourToDoData?.tripEndDate ?? ""]
        tripMiddleView.bindData(percentage: ourToDoData?.percentage ?? 0, friends: ourToDoData?.friends ?? [])
    }
    
    func setDelegate() {
        self.scrollView.delegate = self
        self.ourToDoCollectionView.dataSource = self
        self.ourToDoCollectionView.delegate = self
        self.tabBarView.delegate = self
    }
    
    /// 미완료/완료에 따라 todo cell style 설정해주는 메소드
    func setCellStyle(cell: OurToDoCollectionViewCell, data: OurToDo, textColor: UIColor, isUserInteractionEnabled: Bool) {
        cell.ourToDoData = data
        cell.todoTitleLabel.textColor = textColor
        cell.managerCollectionView.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    /// 할일 추가/ 할일  조회 뷰에 데이터 세팅하고 이동하는 메소드
    func setToDoView(naviBarTitle: String, isActivate: Bool) {
        var manager: [Manager] = []
        for friendProfile in self.tripMiddleView.friendProfile {
            manager.append(Manager(name: friendProfile.name, isManager: false))
        }
        
        let todoVC = ToDoViewController()
        todoVC.navigationBarTitle = naviBarTitle
        todoVC.manager = manager
        todoVC.isActivateView = isActivate
        self.navigationController?.pushViewController(todoVC, animated: false)
    }
    
    func setGradient() {
        tripMiddleView.gradientView.setGradient(
            firstColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0),
            secondColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
            axis: .horizontal)
    }
    
    func setTapBarImage() {
        self.tabBarView.ourToDoTab.imageView?.tintColor = .red500
        self.tabBarView.myToDoTab.imageView?.tintColor = .gray200
    }
    
    // MARK: - objc method
    
    @objc
    func popToDashBoardView(_ sender: UITapGestureRecognizer) {
        print("popToDashBoardView")
    }

    // TODO: - 아이디 값으로 본인 확인 필요
    @objc
    func pushToAddToDoView() {
        setToDoView(naviBarTitle: "추가", isActivate: true)
    }

    @objc
    func pushToInquiryToDo() {
        setToDoView(naviBarTitle: "조회", isActivate: false)
    }

    @objc
    func didChangeValue(segment: UISegmentedControl) {
        self.ourToDoCollectionView.reloadData()
    }
}

extension OurToDoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // contentOffset.y: 손가락을 위로 올리면 + 값, 손가락을 아래로 내리면 - 값
        let topPadding = scrollView.safeAreaInsets.top
        
        let shouldShowSticky = topPadding + scrollView.contentOffset.y > ourToDoHeaderView.frame.minY
        stickyOurToDoHeaderView.isHidden = !shouldShowSticky
        
        if !shouldShowSticky {
            stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex = ourToDoHeaderView.segmentedControl.selectedSegmentIndex
            self.view.backgroundColor = .gray50
            self.navigationBarview.backgroundColor = .gray50
        } else {
            ourToDoHeaderView.segmentedControl.selectedSegmentIndex = stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex
            self.view.backgroundColor = .white000
            self.navigationBarview.backgroundColor = .white000
        }
        
        if topPadding + scrollView.contentOffset.y < 0 {
            scrollView.backgroundColor = .gray50
        }else {
            scrollView.backgroundColor = .white000
        }
    }
}

extension OurToDoViewController: OurToDoCollectionViewDelegate {
    func pushToToDo() {
        setToDoView(naviBarTitle: "조회", isActivate: false)
    }
}

extension OurToDoViewController: TabBarDelegate {
    func tapOurToDo() {
        let ourToDoVC = OurToDoViewController()
        print("ourtodo")
        self.navigationController?.pushViewController(ourToDoVC, animated: false)
    }
    
    func tapMyToDo() {
        let myToDoVC = MyToDoViewController()
        print("mytodo")
        self.tabBarView.ourToDoTab.setImage(UIImage(systemName: "person.fill"), for: .normal)
        self.tabBarView.ourToDoTab.setImage(UIImage(systemName: "pencil"), for: .normal)
        self.navigationController?.pushViewController(myToDoVC, animated: false)
    }
}

extension OurToDoViewController: UICollectionViewDelegate {}

extension OurToDoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let ourToDoHeaderIndex = self.ourToDoHeaderView.segmentedControl.selectedSegmentIndex
        let stickHeaderIndex = self.stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex
        
        if stickyOurToDoHeaderView.isHidden {
            if (ourToDoHeaderIndex == 0 && stickHeaderIndex == 0) || (ourToDoHeaderIndex == 0 && stickHeaderIndex == 1){
                return self.incompletedData.count
            }else if (ourToDoHeaderIndex == 1 && stickHeaderIndex == 1) || (ourToDoHeaderIndex == 1 && stickHeaderIndex == 0) {
                return self.completedData.count
            }else {
                return 0
            }
        }else {
            if (ourToDoHeaderIndex == 1 && stickHeaderIndex == 0) || (ourToDoHeaderIndex == 0 && stickHeaderIndex == 0){
                return self.incompletedData.count
            }else if (ourToDoHeaderIndex == 1 && stickHeaderIndex == 1) || (ourToDoHeaderIndex == 0 && stickHeaderIndex == 1) {
                return self.completedData.count
            }else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let ourToDoCell = collectionView.dequeueReusableCell(withReuseIdentifier: OurToDoCollectionViewCell.identifier, for: indexPath) as? OurToDoCollectionViewCell else {return UICollectionViewCell()}
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pushToInquiryToDo))
        ourToDoCell.addGestureRecognizer(gesture)
        
        if stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex == 0 {
            ourToDoCell.ourToDoData = self.incompletedData[indexPath.row]
            ourToDoCell.textColor = UIColor.gray400
            ourToDoCell.index = indexPath.row
        } else {
            ourToDoCell.ourToDoData = self.completedData[indexPath.row]
            ourToDoCell.textColor = UIColor.gray300
            ourToDoCell.index = indexPath.row
        }
        return ourToDoCell
    }
    
    // TODO: - '할일 조회' 뷰 연결
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("pushToInquiryToDoView")
    }
}

