import UIKit

import SnapKit

final class MyToDoViewController: UIViewController {
    
    // MARK: - UI Property

    private lazy var contentView: UIView = UIView()
    
    private lazy var navigationBarview = DOONavigationBar(self, type: .myToDo, backgroundColor: .gray50)
    
    private let tripHeaderView = TripHeaderView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white000
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var myToDoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: ScreenUtils.getWidth(327) , height: ScreenUtils.getHeight(81))
        flowLayout.sectionInset = UIEdgeInsets(top: ScreenUtils.getHeight(12), left: 1.0, bottom: 1.0, right: 1.0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
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
        headerView.backgroundColor = .white000
        headerView.segmentedControl.addTarget(self, action: #selector(didChangeValue(sender: )), for: .valueChanged)
        return headerView
    }()
    
    private lazy var addToDoButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red700
        btn.setTitle(StringLiterals.MyToDo.mytodo, for: .normal)
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
    
    private let emptyView: UIView = UIView()
    
    private let emptyViewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.MyToDo.emptyViewIcon
        imageView.tintColor = .gray100
        return imageView
    }()
    
    private let emptyViewLabel: UILabel = DOOLabel(
        font: .pretendard(.body3_medi),
        color: .gray200,
        text: StringLiterals.OurToDo.pleaseAddToDo,
        alignment: .center
    )
    
    private let myToDoMainImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = ImageLiterals.MyToDo.mainViewIcon
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
            firstString.addAttribute(.foregroundColor, value: UIColor.gray700, range: (text as NSString).range(of: "나에게 남은 할일"))
            firstString.addAttribute(.foregroundColor, value: UIColor.red400, range: (text as NSString).range(of: String(" \(data.count)개")))
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
    
        self.navigationController?.isNavigationBarHidden = true
        setHierachy()
        setDelegate()
        getMyToDoHeaderData()
        registerCell()
        setLayout()
        setStyle()
        self.didChangeValue(sender: self.myToDoHeaderView.segmentedControl)
        self.didChangeValue(sender: self.stickyMyToDoHeaderView.segmentedControl)
        self.initializeCode = true
    }

    override func viewDidAppear(_ animated: Bool) {
        Task {
         await loadMyToDoData()
        }
        self.navigationBarview.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if self.segmentIndex == 0 {
            getToDoData(progress: "incomplete")
        } else {
            getToDoData(progress: "complete")
        }

    }
}

// MARK: - Private method

private extension MyToDoViewController {
    
    func setHierachy() {
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
        self.view.backgroundColor = .gray50
        self.navigationController?.navigationBar.barTintColor = .white000
        contentView.backgroundColor = .gray50
        tripHeaderView.isUserInteractionEnabled = true
        emptyView.backgroundColor = .white000
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
    
    
    /// 할일 추가/ 할일  조회 뷰에 데이터 세팅하고 이동하는 메소드
    func setToDoView(before: String, naviBarTitle: String, isActivate: Bool) {
        let todoVC = ToDoViewController()
        todoVC.navigationBarTitle = naviBarTitle
        todoVC.isActivateView = isActivate
        todoVC.beforeVC = before
        todoVC.myId = self.myId
        todoVC.todoId = self.todoId
        todoVC.tripId = self.tripId
        self.navigationController?.pushViewController(todoVC, animated: false)
    }
    
    func checkButtonTapped(index: Int, image: UIImage) {
        Task {
            let todo = self.myToDoData?[index] ?? ToDoAppData(todoId: 0, title: "", endDate: "", allocators: [], secret: false)
            if image == ImageLiterals.MyToDo.btnCheckBoxComplete {
                self.myToDoData?.remove(at: index)
                try await getIncompleteToDoData(todoId: todo.todoId)
                await loadMyToDoData()
            } else if image == ImageLiterals.MyToDo.btnCheckBoxIncomplete {
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
        setToDoView(before: "my", naviBarTitle: StringLiterals.ToDo.add, isActivate: true)
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
            self.view.backgroundColor = .gray50
            self.navigationBarview.backgroundColor = .gray50
        } else {
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
            myToDoCell.textColor = UIColor.gray400
            myToDoCell.buttonImg = ImageLiterals.MyToDo.btnCheckBoxIncomplete
            myToDoCell.index = indexPath.row
            myToDoCell.isComplete = false
        } else {
            myToDoCell.myToDoData = self.myToDoData?[indexPath.row]
            myToDoCell.textColor = UIColor.gray300
            myToDoCell.buttonImg = ImageLiterals.MyToDo.btnCheckBoxComplete
            myToDoCell.index = indexPath.row
            myToDoCell.isComplete = true
        }
        return myToDoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.todoId = self.myToDoData?[indexPath.row].todoId ?? 0
        setToDoView(before: "my", naviBarTitle: StringLiterals.ToDo.inquiry, isActivate: false)
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
