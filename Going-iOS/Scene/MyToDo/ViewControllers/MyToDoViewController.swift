import UIKit

import SnapKit

final class MyToDoViewController: UIViewController {
    
    // MARK: - UI Property

    private lazy var contentView: UIView = UIView()

    private lazy var navigationBarview = DOONavigationBar(self, type: .myToDo, backgroundColor: UIColor(resource: .gray50))

    private let tripHeaderView = TripHeaderView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(resource: .white000)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var myToDoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white000
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var myToDoHeaderView: OurToDoHeaderView = {
        let header = OurToDoHeaderView()
        header.segmentedControl.addTarget(self, action: #selector(didChangeValue(sender: )), for: .valueChanged)
        return header
    }()
    
    private lazy var stickyMyToDoHeaderView: OurToDoHeaderView = {
        let headerView = OurToDoHeaderView()
        headerView.isHidden = true
        headerView.backgroundColor = UIColor(resource: .white000)
        headerView.segmentedControl.addTarget(self, action: #selector(didChangeValue(sender: )), for: .valueChanged)
        return headerView
    }()
    
    private lazy var addToDoButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(resource: .red600)
        btn.setTitle(StringLiterals.MyToDo.mytodo, for: .normal)
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
    
    private let emptyViewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .imgMytodoEmpty)
        imageView.tintColor = UIColor(resource: .gray100)
        return imageView
    }()
    
    private let emptyViewLabel: UILabel = DOOLabel(
        font: .pretendard(.body3_medi),
        color: UIColor(resource: .gray200),
        text: StringLiterals.OurToDo.pleaseAddToDo,
        alignment: .center
    )
    
    private let myToDoMainImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(resource: .imgMytodoMain)
        return imgView
    }()
    
    
    // MARK: - Properties
    
    var myId: Int = 0
    
    var tripId: Int = 0
    
    var segmentIndex: Int = 0
    
    var initializeCode: Bool = false
    
    private var index: Int = 0
    
    private var todoId: Int = 0
    
    private var progress: String = "incomplete"
    
    private var isSetDashBoardRoot: Bool = false
    
    private var headerData: MyToDoHeaderAppData? {
        didSet {
            guard let data = headerData else { return }
            self.myId = data.participantId
            self.tripHeaderView.tripNameLabel.text = data.title
            self.tripHeaderView.tripDdayLabel.text = "나에게 남은 할일 \(data.count)개"
            
            let text = self.tripHeaderView.tripDdayLabel.text ?? ""
            let firstString = NSMutableAttributedString(string: text)
            firstString.addAttribute(.foregroundColor, value: UIColor(resource: .gray700), range: (text as NSString).range(of: "나에게 남은 할일"))
            firstString.addAttribute(.foregroundColor, value: UIColor(resource: .red500), range: (text as NSString).range(of: String(" \(data.count)개")))
            self.tripHeaderView.tripDdayLabel.attributedText = firstString
        }
    }
    
    private var myToDoData: [ToDoAppData]? {
        didSet {
            Task {
                myToDoCollectionView.reloadData()

                await loadMyToDoData()
            }
        }
    }
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        hideNavi()
        setHierarchy()
        setDelegate()
        getMyToDoHeaderData()
        registerCell()
        setLayout()
        setSegmentDidChange()
        setStyle()

    }

    override func viewDidAppear(_ animated: Bool) {
        Task {
         await loadMyToDoData()
        }
        self.navigationBarview.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabbar()
        setTsegmentIndex()

    }
}

// MARK: - Private method

private extension MyToDoViewController {
    func setTsegmentIndex() {
        if self.segmentIndex == 0 {
            getToDoData(progress: "incomplete")
        } else {
            getToDoData(progress: "complete")
        }
    }
    func hideTabbar() {
        self.tabBarController?.tabBar.isHidden = false

    }
    func hideNavi() {
        self.navigationController?.isNavigationBarHidden = true

    }
    
    func setSegmentDidChange() {
        self.didChangeValue(sender: self.myToDoHeaderView.segmentedControl)
        self.didChangeValue(sender: self.stickyMyToDoHeaderView.segmentedControl)
    }
    
    func setHierarchy() {
        self.view.addSubviews(navigationBarview, scrollView, addToDoButton)
        scrollView.addSubviews(contentView, stickyMyToDoHeaderView)
        contentView.addSubviews(tripHeaderView,
                                myToDoMainImageView,
                                myToDoHeaderView,
                                myToDoCollectionView,
                                emptyView)
        emptyView.addSubviews(emptyViewIcon, emptyViewLabel)
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
            $0.height.greaterThanOrEqualTo(myToDoCollectionView.contentSize.height)
            $0.edges.width.equalTo(scrollView.contentLayoutGuide)
        }
        
        tripHeaderView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(102))
        }
        
        myToDoMainImageView.snp.makeConstraints {
            $0.top.equalTo(tripHeaderView)
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.width.equalTo(ScreenUtils.getWidth(137))
            $0.height.equalTo(ScreenUtils.getHeight(100))
        }
        
        myToDoHeaderView.snp.makeConstraints{
            $0.top.equalTo(tripHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(49))
        }
        
        emptyView.snp.remakeConstraints {
            $0.top.equalTo(myToDoHeaderView.snp.bottom)
            $0.bottom.equalTo(contentView)
            $0.leading.trailing.equalToSuperview()
        }
        
        emptyViewIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(150))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(114))
        }
        
        emptyViewLabel.snp.makeConstraints {
            $0.top.equalTo(emptyViewIcon.snp.bottom).offset(ScreenUtils.getHeight(16))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(129))
        }
        
        myToDoCollectionView.snp.makeConstraints {
            $0.top.equalTo(myToDoHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(myToDoCollectionView.contentSize.height)
        }
        
        stickyMyToDoHeaderView.snp.makeConstraints{
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
    
    func setStyle() {
        self.view.backgroundColor = UIColor(resource: .gray50)
        self.navigationController?.navigationBar.barTintColor = UIColor(resource: .white000)
        contentView.backgroundColor = UIColor(resource: .gray50)
        tripHeaderView.isUserInteractionEnabled = true
        emptyView.backgroundColor = UIColor(resource: .white000)
        self.initializeCode = true
    }
    
    func setDelegate() {
        self.scrollView.delegate = self
        self.myToDoCollectionView.delegate = self
        self.myToDoCollectionView.dataSource = self
    }

    func registerCell() {
        self.myToDoCollectionView.register(MyToDoCollectionViewCell.self, forCellWithReuseIdentifier: MyToDoCollectionViewCell.identifier)
    }
    
    func loadMyToDoData() async {
        self.setEmptyView()
        getMyToDoHeaderData()

        DispatchQueue.main.async {
            let conetentHeight = CGFloat(self.myToDoData?.count ?? 0) * ScreenUtils.getHeight(99)
            self.myToDoCollectionView.snp.remakeConstraints {
                $0.top.equalTo(self.myToDoHeaderView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(self.contentView)
                $0.height.equalTo(conetentHeight)
             }
            self.myToDoCollectionView.layoutIfNeeded()
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
    
    ///  할일  조회 뷰에 데이터 세팅하고 이동하는 메소드
    func setInquiryToDoView(before: String, naviBarTitle: String) {
        let todoVC = ToDoViewController()
        todoVC.navigationBarTitle = naviBarTitle
        todoVC.beforeVC = before
        todoVC.myId = self.myId
        todoVC.todoId = self.todoId
        todoVC.tripId = self.tripId
        self.navigationController?.pushViewController(todoVC, animated: false)
    }
    
    func checkButtonTapped(index: Int, image: UIImage) {
        Task {
            let todo = self.myToDoData?[index] ?? ToDoAppData(todoId: 0, title: "", endDate: "", allocators: [], secret: false)
            if image == UIImage(resource: .btnCheckboxComplete) {
                self.myToDoData?.remove(at: index)
                try await getIncompleteToDoData(todoId: todo.todoId)
                await loadMyToDoData()
            } else if image == UIImage(resource: .btnCheckboxIncomplete) {
                self.myToDoData?.remove(at: index)
                try await getCompleteToDoData(todoId: todo.todoId)
                await loadMyToDoData()
            }
        }
        
    }
    
    /// 투두 없는 경우 empty view 띄워주는 메소드
    func setEmptyView() {
        if self.myToDoData?.count != 0 {
            self.emptyView.isHidden = true
            self.emptyViewIcon.isHidden = true
            self.emptyViewLabel.isHidden = true
            self.myToDoCollectionView.isHidden = false
        } else {
            self.emptyView.isHidden = false
            self.emptyViewIcon.isHidden = false
            self.emptyViewLabel.isHidden = false
            self.myToDoCollectionView.isHidden = true
        }
    }
    
    // MARK: - objc Method
    
    //추가버튼눌렀을때
    @objc
    func pushToAddToDoView() {
        let todoVC = ActivateToDoViewController()
        todoVC.navigationBarTitle = StringLiterals.ToDo.add
        todoVC.beforeVC = "my"
        todoVC.myId = self.myId
        todoVC.todoId = self.todoId
        todoVC.tripId = self.tripId
        self.navigationController?.pushViewController(todoVC, animated: false)
    }
    
    @objc
    func didChangeValue(sender: UISegmentedControl) {
        if initializeCode {
            if sender.selectedSegmentIndex == 0 {
                getToDoData(progress: "incomplete")
            } else {
                getToDoData(progress: "complete")
            }

            if stickyMyToDoHeaderView.isHidden {
                stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex = myToDoHeaderView.segmentedControl.selectedSegmentIndex
                segmentIndex = stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex
            } else {
                myToDoHeaderView.segmentedControl.selectedSegmentIndex = stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex
                segmentIndex = myToDoHeaderView.segmentedControl.selectedSegmentIndex

            }
        }
    }
}

// MARK: - Extension

extension MyToDoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // contentOffset.y: 손가락을 위로 올리면 + 값, 손가락을 아래로 내리면 - 값
        let topPadding = scrollView.safeAreaInsets.top
        
        let shouldShowSticky = topPadding + scrollView.contentOffset.y > myToDoHeaderView.frame.minY
        stickyMyToDoHeaderView.isHidden = !shouldShowSticky
        
        if !shouldShowSticky {
            self.view.backgroundColor = UIColor(resource: .gray50)
            self.navigationBarview.backgroundColor = UIColor(resource: .gray50)
        } else {
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

extension MyToDoViewController: MyToDoCollectionViewDelegate {
    
    func getButtonIndex(index: Int, image: UIImage) {
        checkButtonTapped(index: index, image: image)
    }

}

extension MyToDoViewController: UICollectionViewDelegate {}

extension MyToDoViewController: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myToDoData?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let myToDoCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyToDoCollectionViewCell.identifier, for: indexPath) as? MyToDoCollectionViewCell else {return UICollectionViewCell()}
        myToDoCell.delegate = self
        
        if stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex == 0 {
            myToDoCell.myToDoData = self.myToDoData?[indexPath.row]
            myToDoCell.textColor = UIColor(resource: .gray400)
            myToDoCell.buttonImg = UIImage(resource: .btnCheckboxIncomplete)
            myToDoCell.index = indexPath.row
            myToDoCell.isComplete = false
        } else {
            myToDoCell.myToDoData = self.myToDoData?[indexPath.row]
            myToDoCell.textColor = UIColor(resource: .gray300)
            myToDoCell.buttonImg = UIImage(resource: .btnCheckboxComplete)
            myToDoCell.index = indexPath.row
            myToDoCell.isComplete = true
        }
        return myToDoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.todoId = self.myToDoData?[indexPath.row].todoId ?? 0
        setInquiryToDoView(before: "my", naviBarTitle: StringLiterals.ToDo.inquiry)
    }
}

extension MyToDoViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: ScreenUtils.getHeight(18), left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenUtils.getWidth(331) , height: ScreenUtils.getHeight(81))
    }
}

extension MyToDoViewController {
    func handlingError(_ error: NetworkError) {
        switch error {
        case .clientError(let message):
            DOOToast.show(message: "\(message)", insetFromBottom: 80)
        case .serverError:
            DOOToast.show(message: "서버 오류", insetFromBottom: 80)
        case .unAuthorizedError, .reIssueJWT:
            DOOToast.show(message: "토큰만료, 재로그인필요", insetFromBottom: 80)
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            DOOToast.show(message: error.description, insetFromBottom: 80)
        }
    }
}

extension MyToDoViewController {
    func getMyToDoHeaderData() {
        Task {
            do {
                let data = try await MyToDoService.shared.getMyToDoHeader(tripId: self.tripId)
                self.headerData = data
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handlingError(error)
            }
        }
    }
    
    func getToDoData(progress: String) {
        Task {
            do {
                self.myToDoData = try await ToDoService.shared.getToDoData(tripId: self.tripId, category: "my", progress: progress)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handlingError(error)
            }
        }
    }
    
    func getCompleteToDoData(todoId: Int) async throws {
        do{
            try await ToDoService.shared.getCompleteToDoData(todoId: todoId)
        }
        catch {
            guard let error = error as? NetworkError else { return }
            handlingError(error)
        }
    }
    
    func getIncompleteToDoData(todoId: Int) async throws {
        do{
            try await ToDoService.shared.getIncompleteToDoData(todoId: todoId)
        }
        catch {
            guard let error = error as? NetworkError else { return }
            handlingError(error)
        }
    }
}
