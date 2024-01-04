import UIKit

import SnapKit

// TODO: - 네비바 & 탭바 추후 변경

class OurToDoViewController: UIViewController {

    // MARK: - UI Property

    private lazy var contentView: UIView = UIView()
    private var navigationBarview = NavigationBarView()
    private var tripHeaderView: TripHeaderView = TripHeaderView()
    private var tripMiddleView: TripMiddleView = TripMiddleView()
    private let ourToDoHeaderView: OurToDoHeaderView = OurToDoHeaderView()
    private var scrollView: UIScrollView = {
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
    private var addToDoView: UIView = {
        let view = UIView()
        view.backgroundColor = .red700
        return view
    }()
    private var addToDoImageView: UIImageView = UIImageView()
    private var addToDoLabel: UILabel = {
        let label = UILabel()
        label.text = "같이 할일"
        label.font = .pretendard(.body1_bold)
        label.textColor = .white000
        return label
    }()
    
    // MARK: - Property
    
    let absoluteWidth = UIScreen.main.bounds.width / 375
    let absoluteHeight = UIScreen.main.bounds.height / 812
    
    var ourToDoData: OurToDoData?
    var incompletedData: [OurToDo] = []
    var completedData: [OurToDo] = []

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        setHierachy()
        setDelegate()
        setData()
        registerCell()
        setAddTarget()
        setLayout()
        setStyle()
        self.didChangeValue(segment: self.ourToDoHeaderView.segmentedControl)
        self.didChangeValue(segment: self.stickyOurToDoHeaderView.segmentedControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        tripMiddleView.gradientView.setGradient(color1: UIColor(red: 1, green: 1, blue: 1, alpha: 1), color2: UIColor(red: 1, green: 1, blue: 1, alpha: 0))
    }
        
    @objc
    func popToDashBoardView(_ sender: UITapGestureRecognizer) {
        print("popToDashBoardView")
    }
    
    // TODO: - '할일 추가' 뷰 연결
    @objc
    func pushToAddToDoView(_ sender: UITapGestureRecognizer) {
        print("pushToAddToDoView")
        
    }

    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.ourToDoCollectionView.reloadData()
    }
}

// MARK: - Private method

private extension OurToDoViewController {
    
    func setHierachy() {
        self.view.addSubviews(navigationBarview, scrollView, addToDoView)
        addToDoView.addSubviews(addToDoImageView, addToDoLabel)
        scrollView.addSubviews(contentView, stickyOurToDoHeaderView)
        contentView.addSubviews(tripHeaderView, tripMiddleView, ourToDoHeaderView, ourToDoCollectionView)
    }
    
    func setLayout() {
        navigationBarview.snp.makeConstraints{
            $0.top.equalToSuperview().inset(absoluteHeight * 44)
            $0.leading.trailing.equalToSuperview().inset(absoluteWidth * 10)
            $0.height.equalTo(absoluteHeight * 60)
        }
        scrollView.snp.makeConstraints{
            $0.top.equalTo(navigationBarview.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints{
            $0.height.greaterThanOrEqualTo(ourToDoCollectionView.contentSize.height).priority(.low)
            $0.edges.width.equalTo(scrollView)
        }
        tripHeaderView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(absoluteHeight * 8)
            $0.height.equalTo(absoluteHeight * 95)
        }
        tripMiddleView.snp.makeConstraints{
            $0.top.equalTo(tripHeaderView.snp.bottom).offset(absoluteHeight * 20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(absoluteHeight * 235)
        }
        ourToDoHeaderView.snp.makeConstraints{
            $0.top.equalTo(tripMiddleView.snp.bottom).offset(absoluteHeight * 28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(absoluteHeight * 49)
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
            $0.height.equalTo(absoluteHeight * 49)
        }
        addToDoView.snp.makeConstraints{
            $0.width.equalTo(absoluteWidth * 117)
            $0.height.equalTo(absoluteHeight * 50)
            $0.trailing.equalToSuperview().inset(absoluteWidth * 16)
            $0.bottom.equalTo(scrollView).inset(absoluteHeight * 24)
        }
        addToDoLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(absoluteHeight * 18)
            $0.height.equalTo(absoluteHeight * 22)
        }
        addToDoImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(absoluteHeight * 18)
            $0.height.equalTo(absoluteHeight * 14)
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
        addToDoView.layer.cornerRadius = absoluteHeight * 26
        addToDoImageView.image = ImageLiterals.OurToDo.btnPlusOurToDo
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
        flowLayout.itemSize = CGSize(width: absoluteWidth * 331 , height: absoluteHeight * 81)
        flowLayout.sectionInset = UIEdgeInsets(top: absoluteHeight * 18, left: 1.0, bottom: 1.0, right: 1.0)
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
        
        tripHeaderView.data = [ourToDoData?.tripTitle ?? "", ourToDoData?.tripDeadline ?? "", ourToDoData?.tripStartDate ?? "", ourToDoData?.tripEndDate ?? ""]
        
        tripMiddleView.bindData(percentage: ourToDoData?.percentage ?? 0, friends: ourToDoData?.friends ?? [])
        
    }
    
    func setDelegate() {
        self.scrollView.delegate = self
        self.ourToDoCollectionView.dataSource = self
        self.ourToDoCollectionView.delegate = self
    }
    
    func setAddTarget() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pushToAddToDoView(_ : )))
        self.ourToDoHeaderView.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        self.stickyOurToDoHeaderView.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        self.addToDoView.addGestureRecognizer(gesture)
    }
    
    /// 미완료/완료에 따라 todo cell style 설정해주는 메소드
    func setCellStyle(cell: OurToDoCollectionViewCell, data: OurToDo, textColor: UIColor, isUserInteractionEnabled: Bool) {
        cell.data = data
        cell.todoTitleLabel.textColor = textColor
        cell.managerCollectionView.isUserInteractionEnabled = isUserInteractionEnabled
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

extension OurToDoViewController: UICollectionViewDelegate{}

extension OurToDoViewController: UICollectionViewDataSource{
    
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
        
        let ourToDoHeaderIndex = self.ourToDoHeaderView.segmentedControl.selectedSegmentIndex
        let stickHeaderIndex = self.stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex

        if stickyOurToDoHeaderView.isHidden {
            if (ourToDoHeaderIndex == 0 && stickHeaderIndex == 0) || (ourToDoHeaderIndex == 0 && stickHeaderIndex == 1){
                setCellStyle(cell: ourToDoCell, data: self.incompletedData[indexPath.row], textColor: UIColor.gray400, isUserInteractionEnabled: true)
            }else if (ourToDoHeaderIndex == 1 && stickHeaderIndex == 1) || (ourToDoHeaderIndex == 1 && stickHeaderIndex == 0) {
                setCellStyle(cell: ourToDoCell, data: self.completedData[indexPath.row], textColor: UIColor.gray300, isUserInteractionEnabled: false)
            }else {}
        }else {
            if (ourToDoHeaderIndex == 1 && stickHeaderIndex == 0) || (ourToDoHeaderIndex == 0 && stickHeaderIndex == 0){
                setCellStyle(cell: ourToDoCell, data: self.incompletedData[indexPath.row], textColor: UIColor.gray400, isUserInteractionEnabled: true)
            }else if (ourToDoHeaderIndex == 1 && stickHeaderIndex == 1) || (ourToDoHeaderIndex == 0 && stickHeaderIndex == 1) {
                setCellStyle(cell: ourToDoCell, data: self.completedData[indexPath.row], textColor: UIColor.gray300, isUserInteractionEnabled: false)

            }else {}
        }
        return ourToDoCell
    }
    
    // TODO: - '할일 조회' 뷰 연결
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("pushToInquiryToDoView")
    }
    
}

