import UIKit

import SnapKit

final class OurToDoViewController: UIViewController {
    
    // MARK: - UI Property
    
    private lazy var contentView: UIView = UIView()

    private lazy var navigationBarview = DOONavigationBar(self, type: .ourToDo, backgroundColor: UIColor(resource: .gray50))

    private let tripHeaderView: TripHeaderView = TripHeaderView()
    
    private let tripMiddleView: TripMiddleView = TripMiddleView()
    
    private let ourToDoHeaderView: OurToDoHeaderView = OurToDoHeaderView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(resource: .white000)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let stickyOurToDoHeaderView: OurToDoHeaderView = {
        let headerView = OurToDoHeaderView()
        headerView.isHidden = true
        headerView.backgroundColor = UIColor(resource: .white000)
        return headerView
    }()
    
    private lazy var ourToDoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor(resource: .white000)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var addToDoButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(resource: .red600)
        btn.setTitle(StringLiterals.OurToDo.ourtodo, for: .normal)
        btn.setTitleColor(UIColor(resource: .white000), for: .normal)
        btn.titleLabel?.font = .pretendard(.body1_bold)
        btn.setImage(UIImage(resource: .btnPlusOurtodo), for: .normal)
        btn.setImage(UIImage(resource: .btnPlusOurtodo), for: .highlighted)
        btn.imageView?.tintColor = UIColor(resource: .white000)
        btn.addTarget(self, action: #selector(pushToAddToDoView), for: .touchUpInside)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.layer.cornerRadius = ScreenUtils.getHeight(26)
        return btn
    }()
    
    private let emptyView: UIView = UIView()
    
    private let emptyViewIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .imgOurtodoEmpty)
        imageView.tintColor = UIColor(resource: .gray100)
        return imageView
    }()
    
    private let emptyViewLabel: UILabel = DOOLabel(
        font: .pretendard(.body3_medi),
        color: UIColor(resource: .gray200),
        text: StringLiterals.OurToDo.pleaseAddToDo,
        alignment: .center
    )
    
    private let ourToDoMainImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(resource: .imgOurtodoMain)
        return imgView
    }()
    
    
    // MARK: - Property
        
    var tripId: Int = 0
    
    var todoId: Int = 0
    
    var segmentIndex: Int = 0
    
    var allocator: [Allocators] = []
    
    var initializeCode: Bool = false
    
    var progress: String = "incomplete"
    
    private var inviteCode: String?
    
    private var isSetDashBoardRoot: Bool = false
    
    private var headerData: OurToDoHeaderAppData? {
        didSet {
            guard let data = headerData else { return }
            self.inviteCode = data.code
            
            self.tripHeaderView.tripData = data
            tripMiddleView.participants = data.participants
            self.tripMiddleView.progress = data.progress
        }
    }
    
    private var ourToDoData: [ToDoAppData]? {
        didSet {
            Task {
                ourToDoCollectionView.reloadData()
                await loadData()
            }
            getOurToDoHeaderData()
        }
    }
        
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setHierarchy()
        setLayout()
        setDelegate()
        registerCell()
        setStyle()
        setSegmentDidChange()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Task {
            await loadData()
        }
        self.navigationBarview.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabbar()
        getOurToDoHeaderData()
        getToDoData(progress: self.progress)
        setGradient()
        
     
    }
    
    override func viewDidLayoutSubviews() {
        setGradient()
    }
}

// MARK: - Private method

private extension OurToDoViewController {
    func setGradient() {
        tripMiddleView.gradientView.setGradient(
            firstColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0),
            secondColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
            axis: .horizontal)
    }
    func hideTabbar() {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor(resource: .gray50)
        
//        self.navigationBarView.backgroundColor = UIColor(resource: .gray50)
    }
    
    func setSegmentDidChange() {
        self.didChangeValue(segment: self.ourToDoHeaderView.segmentedControl)
        self.didChangeValue(segment: self.stickyOurToDoHeaderView.segmentedControl)
        self.initializeCode = true
    }
    
    func setHierarchy() {
        self.view.addSubviews(navigationBarview, scrollView, addToDoButton)
        scrollView.addSubviews(contentView, stickyOurToDoHeaderView)
        contentView.addSubviews(tripHeaderView, 
                                tripMiddleView,
                                ourToDoMainImageView,
                                ourToDoHeaderView,
                                ourToDoCollectionView,
                                emptyView)
        emptyView.addSubviews(emptyViewIconImageView, emptyViewLabel)
    }
    
    func setLayout() {
        navigationBarview.snp.makeConstraints{
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(44))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        scrollView.snp.makeConstraints{
            $0.top.equalTo(navigationBarview.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(90))
        }
        
        contentView.snp.makeConstraints{
            $0.height.greaterThanOrEqualTo(ourToDoCollectionView.contentSize.height).priority(.low)
            $0.edges.width.equalTo(scrollView)
        }
        
        tripHeaderView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(102))
        }
        
        tripMiddleView.snp.makeConstraints{
            $0.top.equalTo(tripHeaderView.snp.bottom).offset(ScreenUtils.getHeight(20))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(235))
        }
        
        ourToDoMainImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
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
        emptyViewLabel.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor(resource: .gray50)
        self.navigationController?.navigationBar.barTintColor = UIColor(resource: .white000)
        contentView.backgroundColor = UIColor(resource: .gray50)
        tripHeaderView.isUserInteractionEnabled = true
        tripMiddleView.isUserInteractionEnabled = true
        emptyView.backgroundColor = UIColor(resource: .white000)
        ourToDoHeaderView.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        stickyOurToDoHeaderView.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
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
    func pushToAddToDoView() {
        let todoVC = ActivateToDoViewController()
        todoVC.navigationBarTitle = StringLiterals.ToDo.add
        guard let header = headerData else { return }
        todoVC.tripId = self.tripId
        todoVC.beforeVC = "our"
        todoVC.fromOurTodoParticipants = header.participants
        todoVC.manager = self.allocator
        todoVC.todoId = self.todoId
        self.navigationController?.pushViewController(todoVC, animated: false)
    }
    
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
        let topPadding = scrollView.safeAreaInsets.top
        
        let shouldShowSticky = topPadding + scrollView.contentOffset.y > ourToDoHeaderView.frame.minY
        stickyOurToDoHeaderView.isHidden = !shouldShowSticky
        
        if !shouldShowSticky {
            stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex = ourToDoHeaderView.segmentedControl.selectedSegmentIndex
            self.view.backgroundColor = UIColor(resource: .gray50)
            self.navigationBarview.backgroundColor = UIColor(resource: .gray50)
        } else {
            ourToDoHeaderView.segmentedControl.selectedSegmentIndex = stickyOurToDoHeaderView.segmentedControl.selectedSegmentIndex
            self.view.backgroundColor = UIColor(resource: .white000)
            self.navigationBarview.backgroundColor = UIColor(resource: .white000)
        }
        
        if topPadding + scrollView.contentOffset.y < 0 {
            scrollView.backgroundColor = UIColor(resource: .gray50)
        }else {
            scrollView.backgroundColor = UIColor(resource: .white000)
        }
    }
}

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
            ourToDoCell.todoTitleLabel.textColor = UIColor(resource: .gray400)
            ourToDoCell.index = indexPath.row
            ourToDoCell.isComplete = false
        } else {
            ourToDoCell.ourToDoData = self.ourToDoData?[indexPath.row]
            ourToDoCell.todoTitleLabel.textColor = UIColor(resource: .gray300)
            ourToDoCell.index = indexPath.row
            ourToDoCell.isComplete = true
        }
        return ourToDoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.todoId = self.ourToDoData?[indexPath.row].todoId ?? 0
        self.allocator =  self.ourToDoData?[indexPath.row].allocators ?? []
        
        /// 할일  조회 뷰에 데이터 세팅 후 이동
        let todoVC = ToDoViewController()
        todoVC.navigationBarTitle = StringLiterals.ToDo.inquiry
        guard let header = headerData else { return }
        todoVC.tripId = self.tripId
        todoVC.beforeVC = "our"
        todoVC.fromOurTodoParticipants = header.participants
        todoVC.manager = self.allocator
        todoVC.todoId = self.todoId
        self.navigationController?.pushViewController(todoVC, animated: false)

    }
}

extension OurToDoViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: ScreenUtils.getHeight(18), left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenUtils.getWidth(331) , height: ScreenUtils.getHeight(81))
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
        case .unAuthorizedError, .reIssueJWT:
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
