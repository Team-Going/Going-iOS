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
        btn.setTitle(" 나의 할일", for: .normal)
        btn.setTitleColor(.white000, for: .normal)
        btn.titleLabel?.font = .pretendard(.body1_bold)
        btn.setImage(ImageLiterals.OurToDo.btnPlusOurToDo, for: .normal)
        btn.setImage(ImageLiterals.OurToDo.btnPlusOurToDo, for: .highlighted)
        btn.imageView?.tintColor = .white000
        btn.addTarget(self, action: #selector(pushToAddToDoView(_:)), for: .touchUpInside)
        btn.semanticContentAttribute = .forceLeftToRight
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
    private let emptyViewLabel: UILabel = DOOLabel(font: .pretendard(.body3_medi), color: .gray200, text: "할일을 추가해주세요.", alignment: .center)
    private let myToDoMainImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = ImageLiterals.MyToDo.mainViewIcon
        return imgView
    }()
    
    // MARK: - Properties
    
    private var index: Int = 0
    var myToDoData: MyToDoData?
    var incompletedData: [MyToDo] = []
    var completedData: [MyToDo] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        setHierachy()
        setDelegate()
        setData()
        registerCell()
        setLayout()
        setStyle()
        setTapBarImage()
        self.didChangeValue(sender: self.myToDoHeaderView.segmentedControl)
        self.didChangeValue(sender: self.stickyMyToDoHeaderView.segmentedControl)
    }

    override func viewDidAppear(_ animated: Bool) {
        loadData()
        setEmptyView()
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
            $0.height.greaterThanOrEqualTo(myToDoCollectionView.contentSize.height).priority(.low)
            $0.edges.width.equalTo(scrollView)
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
        setEmptyView()
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
    }
    
    func setData() {
        self.myToDoData = MyToDoData.myToDoData

        for i in myToDoData?.myToDo ?? [] {
            i.isComplete ? completedData.append(i) : incompletedData.append(i)
        }
        tripHeaderView.myToDoHeaderData = [myToDoData?.tripTitle ?? "", myToDoData?.toDoCountLabel ?? ""]
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
    
    func loadData() {
        // 데이터 로드 후에 호출되는 메서드 또는 클로저에서
        self.myToDoCollectionView.reloadData()
        myToDoCollectionView.layoutIfNeeded()
        
        // Update the constraint based on the new content size
        myToDoCollectionView.snp.updateConstraints {
            $0.height.equalTo(myToDoCollectionView.contentSize.height).priority(.low)
        }
    }
    
    /// 할일 추가/ 할일  조회 뷰에 데이터 세팅하고 이동하는 메소드
    func setToDoView(naviBarTitle: String, isActivate: Bool) {
        var manager: [Manager] = []
        let todoData = ToDoData.todoData
        for friendProfile in todoData.manager {
            manager.append(Manager(name: friendProfile.name, isManager: false))
        }
        
        let todoVC = ToDoViewController()
        todoVC.navigationBarTitle = naviBarTitle
        todoVC.manager = manager
        todoVC.isActivateView = isActivate
        self.navigationController?.pushViewController(todoVC, animated: false)
    }
    
    func checkButtonTapped(index: Int, image: UIImage) {
        var todo: MyToDo = MyToDo(todoTitle: "", manager: [], deadline: "", isComplete: false, isPrivate: false)
        if image == ImageLiterals.MyToDo.btnCheckBoxComplete {
            todo = completedData[index]
            todo.isComplete = false
            incompletedData.append(todo)
            completedData.remove(at: index)
        } else if image == ImageLiterals.MyToDo.btnCheckBoxIncomplete {
            todo = incompletedData[index]
            todo.isComplete = true
            completedData.append(todo)
            incompletedData.remove(at: index)
        }
        loadData()
    }
    
    func setTapBarImage() {
        self.tabBarView.ourToDoTab.setImage(ImageLiterals.TabBar.tabbarOurToDoUnselected, for: .normal)
        self.tabBarView.myToDoTab.setImage(ImageLiterals.TabBar.tabbarMyToDoSelected, for: .normal)
    }
    
    /// 투두 없는 경우 empty view 띄워주는 메소드
    func setEmptyView() {
        if self.myToDoData?.myToDo.isEmpty ?? true {
            emptyView.snp.makeConstraints {
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
            emptyView.backgroundColor = .white000
        }else {
            myToDoCollectionView.snp.makeConstraints {
                $0.top.equalTo(myToDoHeaderView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(contentView)
                $0.height.equalTo(myToDoCollectionView.contentSize.height).priority(.low)
            }
        }
    }
    
    // MARK: - objc Method

    //TODO: - 서버통신 데이터 수정 필요

    @objc
    func pushToAddToDoView(_ sender: UITapGestureRecognizer) {
        setToDoView(naviBarTitle: "추가", isActivate: true)
    }
    
    @objc
    func didChangeValue(sender: UISegmentedControl) {
        
        if stickyMyToDoHeaderView.isHidden {
            stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex = myToDoHeaderView.segmentedControl.selectedSegmentIndex
        } else {
            myToDoHeaderView.segmentedControl.selectedSegmentIndex = stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex
        }
        
        loadData()
    }
    
    //TODO: - 서버통신 데이터 수정 필요
    
    @objc
    func pushToInquiryToDo() {
        setToDoView(naviBarTitle: "조회", isActivate: false)
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
        setToDoView(naviBarTitle: "조회", isActivate: false)
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
        
        if stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex == 0 {
            return self.incompletedData.count
        } else {
            return self.completedData.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let myToDoCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyToDoCollectionViewCell.identifier, for: indexPath) as? MyToDoCollectionViewCell else {return UICollectionViewCell()}
        myToDoCell.delegate = self
        
        if stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex == 0 {
            myToDoCell.myToDoData = self.incompletedData[indexPath.row]
            myToDoCell.textColor = UIColor.gray400
            myToDoCell.buttonImg = ImageLiterals.MyToDo.btnCheckBoxIncomplete
            myToDoCell.index = indexPath.row
        } else {
            myToDoCell.myToDoData = self.completedData[indexPath.row]
            myToDoCell.textColor = UIColor.gray300
            myToDoCell.buttonImg = ImageLiterals.MyToDo.btnCheckBoxComplete
            myToDoCell.index = indexPath.row
        }
        return myToDoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushToInquiryToDo()
    }
}
