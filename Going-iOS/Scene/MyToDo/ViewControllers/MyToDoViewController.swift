//
//  MyToDoViewController.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/7/24.
//

import UIKit

import SnapKit

final class MyToDoViewController: UIViewController {

    // MARK: - UI Property

    private lazy var contentView: UIView = UIView()
    private lazy var navigationBarview = DOONavigationBar(self, type: .myToDo, backgroundColor: .gray50)
    private let tripHeaderView = TripHeaderView()
    private let tabBarView: TabBarView = TabBarView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white000
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    private lazy var myToDoCollectionView: UICollectionView = {setCollectionView()}()
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
        btn.addTarget(self, action: #selector(pushToAddToDoView(_:)), for: .touchUpInside)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.layer.cornerRadius = ScreenUtils.getHeight(26)
        return btn
    }()
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let emptyViewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.MyToDo.emptyViewIcon
        imageView.tintColor = .gray100
        return imageView
    }()
    private let emptyViewLabel: UILabel = DOOLabel(font: .pretendard(.body3_medi), color: .gray200, text: StringLiterals.OurToDo.pleaseAddToDo, alignment: .center)
    private let myToDoMainImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = ImageLiterals.MyToDo.mainViewIcon
        return imgView
    }()
    
    // MARK: - Properties
    
    private var index: Int = 0
    private var progress: String = "incomplete"
    var detailToDoData: GetDetailToDoResponseStuct = GetDetailToDoResponseStuct(title: "", endDate: "", allocators: [], memo: "", secret: false)
    private var headerData: MyToDoHeaderAppData? {
        didSet {
            guard let data = headerData else { return }
            self.tripHeaderView.tripNameLabel.text = data.name
            self.tripHeaderView.tripDdayLabel.text = "나에게 남은 할일 \(data.count)개"
            
            let text = self.tripHeaderView.tripDdayLabel.text ?? ""
            let firstString = NSMutableAttributedString(string: text)
            firstString.addAttribute(.foregroundColor, value: UIColor.gray700, range: (text as NSString).range(of: "나에게 남은 할일"))
            firstString.addAttribute(.foregroundColor, value: UIColor.red400, range: (text as NSString).range(of: String(" \(data.count)개")))
            print("header \(data.count)개")
            self.tripHeaderView.tripDdayLabel.attributedText = firstString
        }
    }
    var initializeCode: Bool = false
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
        getToDoData(progress: progress)
        registerCell()
        setLayout()
        setStyle()
        setTapBarImage()
        self.didChangeValue(sender: self.myToDoHeaderView.segmentedControl)
        self.didChangeValue(sender: self.stickyMyToDoHeaderView.segmentedControl)
        self.initializeCode = true
    }

    override func viewDidAppear(_ animated: Bool) {
        Task {
         await loadMyToDoData()
        }
    }
}

// MARK: - Private method

private extension MyToDoViewController {
    
    func setHierachy() {
        self.view.addSubviews(navigationBarview, tabBarView, scrollView, addToDoButton)
        scrollView.addSubviews(contentView, stickyMyToDoHeaderView)
        contentView.addSubviews(tripHeaderView, myToDoMainImageView, myToDoHeaderView, myToDoCollectionView, emptyView)
        emptyView.addSubviews(emptyViewIcon, emptyViewLabel)
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
            $0.height.greaterThanOrEqualTo(myToDoCollectionView.contentSize.height)
            $0.edges.width.equalTo(scrollView.contentLayoutGuide)
        }
        tripHeaderView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(ScreenUtils.getHeight(8))
            $0.height.equalTo(ScreenUtils.getHeight(95))
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
        self.tabBarView.delegate = self
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
    
    /// 할일 추가/ 할일  조회 뷰에 데이터 세팅하고 이동하는 메소드
    func setToDoView(before: String, naviBarTitle: String, isActivate: Bool) {
        let todoVC = ToDoViewController()
        todoVC.navigationBarTitle = naviBarTitle
        todoVC.isActivateView = isActivate
        todoVC.data = detailToDoData
        todoVC.manager = detailToDoData.allocators
        todoVC.beforeVC = before
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
    
    func setTapBarImage() {
        self.tabBarView.ourToDoTab.setImage(ImageLiterals.TabBar.tabbarOurToDoUnselected, for: .normal)
        self.tabBarView.myToDoTab.setImage(ImageLiterals.TabBar.tabbarMyToDoSelected, for: .normal)
    }
    
    /// 투두 없는 경우 empty view 띄워주는 메소드
    func setEmptyView() {
        if self.myToDoData?.count != 0 {
            self.emptyView.isHidden = true
            self.emptyViewIcon.isHidden = true
            self.emptyViewLabel.isHidden = true
            self.myToDoCollectionView.isHidden = false
        }else {
            self.emptyView.isHidden = false
            self.emptyViewIcon.isHidden = false
            self.emptyViewLabel.isHidden = false
            self.myToDoCollectionView.isHidden = true
        }
    }
    
    // MARK: - objc Method

    //TODO: - 서버통신 데이터 수정 필요

    @objc
    func pushToAddToDoView(_ sender: UITapGestureRecognizer) {
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
            } else {
                myToDoHeaderView.segmentedControl.selectedSegmentIndex = stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex
            }
        }
    }
    
    //TODO: - 서버통신 데이터 수정 필요
    
    @objc
    func pushToInquiryToDo() {
        setToDoView(before: "my", naviBarTitle: StringLiterals.ToDo.inquiry, isActivate: false)
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
    func pushToToDo() {
        setToDoView(before: "my", naviBarTitle: StringLiterals.ToDo.inquiry, isActivate: false)
    }
    
    func getButtonIndex(index: Int, image: UIImage) {
        checkButtonTapped(index: index, image: image)
    }

}

extension MyToDoViewController: TabBarDelegate {
    func tapOurToDo() {
        let ourToDoVC = OurToDoViewController()
        self.navigationController?.pushViewController(ourToDoVC, animated: false)
    }
    
    func tapMyToDo() {
        let myToDoVC = MyToDoViewController()
        self.navigationController?.pushViewController(myToDoVC, animated: false)
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
        pushToInquiryToDo()
    }
}

extension MyToDoViewController {
    func handlingError(_ error: NetworkError) {
        switch error {
        case .clientError(let message):
            DOOToast.show(message: "\(message)", insetFromBottom: 50)
        default:
            DOOToast.show(message: error.description, insetFromBottom: 50)
        }
    }
}

extension MyToDoViewController {
    func getMyToDoHeaderData() {
        Task {
            do {
                self.headerData = try await MyToDoService.shared.getMyToDoHeader(tripId: 53)
                print("my header \(self.headerData)")
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
                self.myToDoData = try await ToDoService.shared.getToDoData(tripId: 53, category: "my", progress: progress)
                print("my todo \(self.myToDoData)")
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handlingError(error)
                print("my todo \(error)")
            }
        }
    }
    
    func getDetailToDoData() {
        Task {
            do {
                self.detailToDoData = try await ToDoService.shared.getDetailToDoData(todoId: 1)
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
