import UIKit

import SnapKit

// TODO: - 네비바 & 탭바 추후 변경

final class OurToDoViewController: UIViewController {
    
    
    // MARK: - UI Property
    
    private var isSetDashBoardRoot: Bool = false
    
    private lazy var contentView: UIView = UIView()
    private lazy var navigationBarview = DOONavigationBar(self, type: .ourToDo, backgroundColor: .gray50)
    private let tripHeaderView: TripHeaderView = TripHeaderView()
    private let tripMiddleView: TripMiddleView = TripMiddleView()
    private let ourToDoHeaderView: OurToDoHeaderView = OurToDoHeaderView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white000
        scrollView.showsHorizontalScrollIndicator = false
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
        imageView.image = ImageLiterals.OurToDo.emptyViewIcon
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
    
    var progress: String = "incomplete"
    
    // MARK: - Property
    
    var initializeCode: Bool = false

    var tripId: Int = 0
    
    var segmentIndex: Int = 0

    private var headerData: OurToDoHeaderAppData? {
        didSet {
            guard let data = headerData else { return }
            self.inviteCode = data.code
            
            self.tripHeaderView.tripData = data
            tripMiddleView.participants = data.participants
            self.tripMiddleView.progress = data.progress
        }
    }
    
    private var inviteCode: String?
    
    var todoId: Int = 0
    
    var ourToDoData: [ToDoAppData]? {
        didSet {
            Task {
                ourToDoCollectionView.reloadData()
                await loadData()

            }
//            await loadData()
//            getOurToDoHeaderData()
            
        }
    }
    
    var allocator: [Allocators] = []
    
    var detailToDoData: DetailToDoAppData = DetailToDoAppData(title: "", endDate: "", allocators: [], memo: "", secret: false)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyViewLabel.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        setHierarchy()
        setLayout()
        setDelegate()
        registerCell()
        setStyle()
        self.didChangeValue(segment: self.ourToDoHeaderView.segmentedControl)
        self.didChangeValue(segment: self.stickyOurToDoHeaderView.segmentedControl)
        self.initializeCode = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Task {
            await loadData()
        }
        setGradient()
        
        self.navigationBarview.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        getOurToDoHeaderData()
        getToDoData(progress: self.progress)

    }
    
    override func viewDidLayoutSubviews() {
        setGradient()
        
    }
}

// MARK: - Private method

private extension OurToDoViewController {
    
    func setHierarchy() {
        self.view.addSubviews(navigationBarview, scrollView, addToDoButton)
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
        
        scrollView.snp.makeConstraints{
            $0.top.equalTo(navigationBarview.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(105))
        }
        contentView.snp.makeConstraints{
            $0.height.greaterThanOrEqualTo(ourToDoCollectionView.contentSize.height).priority(.low)
            $0.edges.width.equalTo(scrollView)
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
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(30))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(108))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(95))
        }
        emptyViewLabel.snp.makeConstraints {
            $0.top.equalTo(emptyViewIconImageView.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(129))
        }
        ourToDoCollectionView.snp.makeConstraints {
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
    
    @objc
    func backButtonTapped() {
        if isSetDashBoardRoot == false {
            isSetDashBoardRoot = true
            view.window?.rootViewController = UINavigationController(rootViewController: DashBoardViewController())
            view.window?.makeKeyAndVisible()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
      
    }
    
    
    func loadData() async {
        self.setEmptyView()

        ourToDoCollectionView.reloadData()

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
        collectionView.showsHorizontalScrollIndicator = false
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
    
   
    
    func setDelegate() {
        self.scrollView.delegate = self
        self.ourToDoCollectionView.dataSource = self
        self.ourToDoCollectionView.delegate = self
        self.tripMiddleView.delegate = self
    }
    
    /// 미완료/완료에 따라 todo cell style 설정해주는 메소드
//    func setCellStyle(cell: OurToDoCollectionViewCell, data: ToDoAppData, textColor: UIColor, isUserInteractionEnabled: Bool) {
//        cell.ourToDoData = data
//        cell.todoTitleLabel.textColor = textColor
//        cell.managerCollectionView.isUserInteractionEnabled = isUserInteractionEnabled
//    }
    
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
        guard let header = headerData else { return }
        todoVC.tripId = self.tripId
        todoVC.beforeVC = before
        todoVC.fromOurTodoParticipants = header.participants
        
        todoVC.manager = self.allocator
        
        todoVC.isActivateView = isActivate
        todoVC.todoId = self.todoId
        self.navigationController?.pushViewController(todoVC, animated: false)
    }
    
    func setGradient() {
        tripMiddleView.gradientView.setGradient(
            firstColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0),
            secondColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
            axis: .horizontal)
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
    
//    @objc
//    func pushToInquiryToDoVC() {
//        
//        setToDoView(before: "our" , naviBarTitle: "조회", isActivate: false)
//    }
    
    @objc
    func didChangeValue(segment: UISegmentedControl) {
        if initializeCode {
            if segment.selectedSegmentIndex == 0 {
                self.progress = "incomplete"
                getToDoData(progress: self.progress)
                
            } else {
                self.progress = "complete"
                getToDoData(progress: self.progress)
            }
        }
        
        if stickyOurToDoHeaderView.isHidden {
            stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex = ourToDoHeaderView.segmentedControl.selectedSegmentIndex
            segmentIndex = stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex
        } else {
            ourToDoHeaderView.segmentedControl.selectedSegmentIndex = stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex
            segmentIndex = ourToDoHeaderView.segmentedControl.selectedSegmentIndex

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
//
//extension OurToDoViewController: OurToDoCollectionViewDelegate {
//    func pushToToDo() {
////        setToDoView(before: "our" , naviBarTitle: "조회", isActivate: false)
//    }
//}

//탭바누를때
extension OurToDoViewController: TabBarDelegate {
    func tapOurToDo() {
        let ourToDoVC = OurToDoViewController()
        ourToDoVC.tripId = self.tripId
        self.navigationController?.pushViewController(ourToDoVC, animated: false)
    }
    
    func tapMyToDo() {
        let myToDoVC = MyToDoViewController()
        myToDoVC.tripId = self.tripId
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
        self.allocator =  self.ourToDoData?[indexPath.row].allocators ?? []
        setToDoView(before: "our", naviBarTitle: StringLiterals.ToDo.inquiry, isActivate: false)
    }
}

extension OurToDoViewController: TripMiddleViewDelegate {
    func presentToInviteFriendVC() {
        let inviteFriendVC = InviteFriendPopUpViewController()
        inviteFriendVC.codeLabel.text = self.inviteCode
        self.present(inviteFriendVC, animated: false)
    }
    
    func pushToMemberVC() {
        let vc = MemberViewController()
        vc.tripId = self.tripId
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension OurToDoViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .serverError:
            DOOToast.show(message: "서버오류", insetFromBottom: 80)
        case .unAuthorizedError:
            DOOToast.show(message: "토큰만료, 재로그인필요", insetFromBottom: 80)
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .userState(let code, let message):
            DOOToast.show(message: "\(code) : \(message)", insetFromBottom: 80)
        default:
            DOOToast.show(message: error.description, insetFromBottom: 80)
        }
    }
}


extension OurToDoViewController {
    
    func getOurToDoHeaderData() {
        Task(priority: .high) {
            do {
                self.headerData = try await OurToDoService.shared.getOurToDoHeader(tripId: self.tripId)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
    
    func getToDoData(progress: String) {
        Task {
            do {
                self.ourToDoData = try await ToDoService.shared.getToDoData(tripId: tripId, category: "our", progress: progress)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}
