import UIKit

import SnapKit

// TODO: - 네비바 & 탭바 추후 변경

final class OurToDoViewController: UIViewController {
    
    // MARK: - UI Property

    var tripId: Int = 0
    var todoId: Int = 0
    private lazy var contentView: UIView = UIView()
    private lazy var navigationBarview = DOONavigationBar(self, type: .ourToDo, backgroundColor: .gray50)
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
    private lazy var ourToDoCollectionView: UICollectionView = {
        setCollectionView()
    }()
    
    private let tabBarView: TabBarView = TabBarView()
    
    private lazy var addToDoButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red700
        btn.setTitle(StringLiterals.OurToDo.ourtodo, for: .normal)
        btn.setTitleColor(.white000, for: .normal)
        btn.titleLabel?.font = .pretendard(.body1_bold)
        btn.setImage(ImageLiterals.OurToDo.btnPlusOurToDo, for: .normal)
        btn.setImage(ImageLiterals.OurToDo.btnPlusOurToDo, for: .highlighted)
        btn.imageView?.tintColor = .white000
        btn.addTarget(self, action: #selector(pushToAddToDoView), for: .touchUpInside)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.layer.cornerRadius = ScreenUtils.getHeight(26)
        return btn
    }()
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let emptyViewIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.MyToDo.emptyViewIcon
        imageView.tintColor = .gray100
        return imageView
    }()
    private let emptyViewLabel: UILabel = DOOLabel(font: .pretendard(.body3_medi),
                                                   color: .gray200,
                                                   text: StringLiterals.OurToDo.pleaseAddToDo,
                                                   alignment: .center)
    
    private let ourToDoMainImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = ImageLiterals.OurToDo.mainViewIcon
        return imgView
    }()
    
    // MARK: - Property
    
    private var progress: String = "incomplete"
    private var headerData: OurToDoHeaderAppData? {
        didSet {
            guard let data = headerData else { return }
            let splitStartDate = data.startDate.split(separator: ".")
            let newStartDate = "\(splitStartDate[1])월 \(splitStartDate[2])일"
            let splitEndDate = data.endDate.split(separator: ".")
            let newEndDate = "\(splitEndDate[1])월 \(splitEndDate[2])일"
            self.tripHeaderView.tripData = [data.title, "\(data.day)", newStartDate, newEndDate]
            tripMiddleView.participants = data.participants
            self.tripMiddleView.progress = data.progress
        }
    }
    
    var initializeCode: Bool = false
    var ourToDoData: [ToDoAppData]? {
        didSet {
            ourToDoCollectionView.reloadData()
            loadData()
        }
    }
    
    var detailToDoData = GetDetailToDoResponseStuct(title: "", endDate: "", allocators: [], memo: "", secret: false)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyViewLabel.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        setHierarchy()
        setLayout()
        setDelegate()
        registerCell()
        setStyle()
        getOurToDoHeaderData()
        getToDoData(progress: progress)
        setTapBarImage()
        self.didChangeValue(segment: self.ourToDoHeaderView.segmentedControl)
        self.didChangeValue(segment: self.stickyOurToDoHeaderView.segmentedControl)
        self.initializeCode = true
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
        contentView.addSubviews(tripHeaderView, tripMiddleView, ourToDoMainImageView, ourToDoHeaderView, ourToDoCollectionView, emptyView)
        emptyView.addSubviews(emptyViewIconImageView, emptyViewLabel)
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
            $0.height.greaterThanOrEqualTo(ourToDoCollectionView.contentSize.height)
            $0.edges.width.equalTo(scrollView.contentLayoutGuide)
        }
        tripHeaderView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(95))
        }
        tripMiddleView.snp.makeConstraints{
            $0.top.equalTo(tripHeaderView.snp.bottom).offset(ScreenUtils.getHeight(20))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(235))
        }
        ourToDoMainImageView.snp.makeConstraints {
            $0.top.equalTo(tripHeaderView)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(112))
            $0.height.equalTo(ScreenUtils.getHeight(135))
        }
        ourToDoHeaderView.snp.makeConstraints{
            $0.top.equalTo(tripMiddleView.snp.bottom).offset(ScreenUtils.getHeight(28))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(49))
        }
        emptyView.snp.makeConstraints {
            $0.top.equalTo(ourToDoHeaderView.snp.bottom)
            $0.bottom.equalTo(contentView)
            $0.leading.trailing.equalToSuperview()
        }
        emptyViewIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(40))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(100))
        }
        emptyViewLabel.snp.makeConstraints {
            $0.top.equalTo(emptyViewIconImageView.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(129))
        }
        ourToDoCollectionView.snp.makeConstraints {
            $0.top.equalTo(ourToDoHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(ourToDoCollectionView.contentSize.height)
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
        self.setEmptyView()
        // Update the constraint based on the new content size
        DispatchQueue.main.async {
            let conetentHeight = CGFloat(self.ourToDoData?.count ?? 0) * ScreenUtils.getHeight(99)
            self.ourToDoCollectionView.snp.remakeConstraints {
                $0.top.equalTo(self.ourToDoHeaderView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(self.contentView)
                $0.height.equalTo(conetentHeight)
             }
            self.ourToDoCollectionView.layoutIfNeeded()
        }
    }
    
    func setStyle() {
        self.view.backgroundColor = .gray50
        self.navigationController?.navigationBar.barTintColor = .white000
        scrollView.backgroundColor = .white000
        contentView.backgroundColor = .gray50
        tripHeaderView.isUserInteractionEnabled = true
        tripMiddleView.isUserInteractionEnabled = true
        emptyView.backgroundColor = .white000
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
        flowLayout.sectionInset = UIEdgeInsets(top: ScreenUtils.getHeight(18), left: 0, bottom: 0, right: 0)
        return flowLayout
    }
    
    func registerCell() {
        self.ourToDoCollectionView.register(OurToDoCollectionViewCell.self, forCellWithReuseIdentifier: OurToDoCollectionViewCell.identifier)
    }
    
   
    
    func setDelegate() {
        self.scrollView.delegate = self
        self.ourToDoCollectionView.dataSource = self
        self.ourToDoCollectionView.delegate = self
        self.tabBarView.delegate = self
        self.tripMiddleView.delegate = self
    }
    
    /// 미완료/완료에 따라 todo cell style 설정해주는 메소드
    func setCellStyle(cell: OurToDoCollectionViewCell, data: ToDoAppData, textColor: UIColor, isUserInteractionEnabled: Bool) {
        cell.ourToDoData = data
        cell.todoTitleLabel.textColor = textColor
        cell.managerCollectionView.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    /// 할일 추가/ 할일  조회 뷰에 데이터 세팅하고 이동하는 메소드
    func setToDoView(before: String , naviBarTitle: String, isActivate: Bool) {
        //        var manager: [Allocators] = []
        //        for friendProfile in self.tripMiddleView.friendProfile {
        //            manager.append(Manager(name: friendProfile.name, isManager: false))
        //        }
        //
//        detailToDoData = toDetailAppData()
        let todoVC = ToDoViewController()
        todoVC.navigationBarTitle = naviBarTitle
        todoVC.data = detailToDoData
        todoVC.manager = detailToDoData.allocators
        todoVC.isActivateView = isActivate
        todoVC.beforeVC = before
//        todoVC.setDefaultValue = []
        self.navigationController?.pushViewController(todoVC, animated: false)
    }
    
    func setGradient() {
        tripMiddleView.gradientView.setGradient(
            firstColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0),
            secondColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
            axis: .horizontal)
    }
    
    func setTapBarImage() {
        self.tabBarView.ourToDoTab.setImage(ImageLiterals.TabBar.tabbarOurToDoSelected, for: .normal)
        self.tabBarView.myToDoTab.setImage(ImageLiterals.TabBar.tabbarMyToDoUnselected, for: .normal)
    }
    
    /// 투두 없는 경우 empty view 띄워주는 메소드
    func setEmptyView() {
        if self.ourToDoData?.count != 0 {
            self.emptyView.isHidden = true
            self.emptyViewIconImageView.isHidden = true
            self.emptyViewLabel.isHidden = true
            self.ourToDoCollectionView.isHidden = false
        }else {
            self.emptyView.isHidden = false
            self.emptyViewIconImageView.isHidden = false
            self.emptyViewLabel.isHidden = false
            self.ourToDoCollectionView.isHidden = true
        }
    }
    
    // MARK: - objc method
    
    @objc
    func popToDashBoardView(_ sender: UITapGestureRecognizer) {
        print("popToDashBoardView")
    }
    
    // TODO: - 아이디 값으로 본인 확인 필요
    @objc
    func pushToAddToDoView() {
        setToDoView(before: "our" , naviBarTitle: "추가", isActivate: true)
    }
    
    @objc
    func pushToInquiryToDoVC() {
        getDetailToDoData(todoId: self.todoId)
    }
    
    @objc
    func didChangeValue(segment: UISegmentedControl) {
        if initializeCode {
            if segment.selectedSegmentIndex == 0 {
                getToDoData(progress: "incomplete")
            } else {
                getToDoData(progress: "complete")
            }

            if stickyOurToDoHeaderView.isHidden {
                stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex = ourToDoHeaderView.segmentedControl.selectedSegmentIndex
            } else {
                ourToDoHeaderView.segmentedControl.selectedSegmentIndex = stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex
            }
        }
    }
}

extension OurToDoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // contentOffset.y: 손가락을 위로 올리면 + 값, 손가락을 아래로 내리면 - 값
        let topPadding = scrollView.safeAreaInsets.top
        
        let shouldShowSticky = topPadding + scrollView.contentOffset.y > ourToDoHeaderView.frame.minY
        stickyOurToDoHeaderView.isHidden = !shouldShowSticky
        
        if !shouldShowSticky {
            if stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex != ourToDoHeaderView.segmentedControl.selectedSegmentIndex {
                stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex = ourToDoHeaderView.segmentedControl.selectedSegmentIndex
            }
            self.view.backgroundColor = .gray50
            self.navigationBarview.backgroundColor = .gray50
        } else {
            if stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex != ourToDoHeaderView.segmentedControl.selectedSegmentIndex {
                ourToDoHeaderView.segmentedControl.selectedSegmentIndex = stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex
            }
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
        setToDoView(before: "our" , naviBarTitle: "조회", isActivate: false)
    }
}

extension OurToDoViewController: TabBarDelegate {
    func tapOurToDo() {
        let ourToDoVC = OurToDoViewController()
        self.navigationController?.pushViewController(ourToDoVC, animated: false)
    }
    
    func tapMyToDo() {
        let myToDoVC = MyToDoViewController()
        self.navigationController?.pushViewController(myToDoVC, animated: false)
    }
}

extension OurToDoViewController: UICollectionViewDelegate {}

extension OurToDoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ourToDoData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let ourToDoCell = collectionView.dequeueReusableCell(withReuseIdentifier: OurToDoCollectionViewCell.identifier, for: indexPath) as? OurToDoCollectionViewCell else {return UICollectionViewCell()}
        
        ourToDoCell.delegate = self
        
        if stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex == 0 {
            ourToDoCell.ourToDoData = self.ourToDoData?[indexPath.row]
            ourToDoCell.todoTitleLabel.textColor = UIColor.gray400
            ourToDoCell.index = indexPath.row
            ourToDoCell.isComplete = false
        } else {
            ourToDoCell.ourToDoData = self.ourToDoData?[indexPath.row]
            ourToDoCell.todoTitleLabel.textColor = UIColor.gray300
            ourToDoCell.index = indexPath.row
            ourToDoCell.isComplete = true
        }
        return ourToDoCell
    }
    
    // TODO: - '할일 조회' 뷰 연결
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.todoId = self.ourToDoData?[indexPath.row].todoId ?? 0
        
        pushToInquiryToDoVC()
    }
}

extension OurToDoViewController: TripMiddleViewDelegate {
    func presentToInviteFriendVC() {
        let inviteFriendVC = InviteFriendPopUpViewController()
        self.present(inviteFriendVC, animated: false)
    }
    
}

extension OurToDoViewController {
    func handlingError(_ error: NetworkError) {
        switch error {
        case .clientError(let message):
            DOOToast.show(message: "\(message)", insetFromBottom: 50)
        default:
            DOOToast.show(message: error.description, insetFromBottom: 50)
        }
    }
}


extension OurToDoViewController {
    
    func getOurToDoHeaderData() {
        Task(priority: .high) {
            do {
                self.headerData = try await OurToDoService.shared.getOurToDoHeader(tripId: 53)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handlingError(error)
                print("my header \(error)")
            }
        }
    }
    
    func getToDoData(progress: String) {
        Task {
            do {
                self.ourToDoData = try await ToDoService.shared.getToDoData(tripId: 53, category: "our", progress: progress)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handlingError(error)
                print("our todo \(error)")
            }
        }
    }
    
    func getDetailToDoData(todoId: Int) {
        Task {
            do {
                self.detailToDoData = try await ToDoService.shared.getDetailToDoData(todoId: todoId)
                print("our detailtodo \(self.detailToDoData)")

            }
            catch {
                guard let error = error as? NetworkError else { return }
                handlingError(error)
            }
        }
    }
    
}
