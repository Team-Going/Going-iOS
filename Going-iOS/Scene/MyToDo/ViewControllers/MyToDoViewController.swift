//
//  MyToDoViewController.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/7/24.
//

import UIKit

class MyToDoViewController: UIViewController {

    // MARK: - UI Property
    
    private lazy var contentView: UIView = UIView()
    private let navigationBarview = CreateNavigationBar()
    private let tripHeaderView = TripHeaderView()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white000
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    private lazy var myToDoCollectionView: UICollectionView = {setCollectionView()}()
    private let myToDoHeaderView: OurToDoHeaderView = OurToDoHeaderView()
    private let stickyMyToDoHeaderView: OurToDoHeaderView = {
        let headerView = OurToDoHeaderView()
        headerView.isHidden = true
        headerView.backgroundColor = .white000
        return headerView
    }()
    
    // MARK: - Properties
    
    enum Section: CaseIterable {
        case main
    }
    private var dataSource: UICollectionViewDiffableDataSource<Section, MyToDo>!
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
        self.didChangeValue(segment: self.myToDoHeaderView.segmentedControl)
        self.didChangeValue(segment: self.stickyMyToDoHeaderView.segmentedControl)
    }

    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    // MARK: - objc Method

    @objc
    func pushToAddToDoView(_ sender: UITapGestureRecognizer) {
        print("pushToAddToDoView")
        let todoVC = ToDoViewController()
        todoVC.navigationBarTitle = "추가"
        self.navigationController?.pushViewController(todoVC, animated: false)
    }
    
    @objc 
    func didChangeValue(segment: UISegmentedControl) {
        loadData()
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
}

// MARK: - Private method

private extension MyToDoViewController {
    
    func setHierachy() {
        self.view.addSubviews(navigationBarview, scrollView)
        scrollView.addSubviews(contentView, stickyMyToDoHeaderView)
        contentView.addSubviews(tripHeaderView, myToDoHeaderView, myToDoCollectionView)
    }
    
    func setLayout() {
        navigationBarview.snp.makeConstraints{
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(44))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(10))
            $0.height.equalTo(ScreenUtils.getHeight(60))
        }
        scrollView.snp.makeConstraints{
            $0.top.equalTo(navigationBarview.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
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
        myToDoHeaderView.snp.makeConstraints{
            $0.top.equalTo(tripHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(49))
        }
        myToDoCollectionView.snp.makeConstraints{
            $0.top.equalTo(myToDoHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(myToDoCollectionView.contentSize.height).priority(.low)
        }
        stickyMyToDoHeaderView.snp.makeConstraints{
            $0.top.equalTo(navigationBarview.snp.bottom)
            $0.leading.trailing.width.equalTo(scrollView)
            $0.height.equalTo(ScreenUtils.getHeight(49))
        }
    }
    
    func setStyle() {
        self.view.backgroundColor = .gray50
        self.navigationController?.navigationBar.barTintColor = .white000
        contentView.backgroundColor = .gray50
        tripHeaderView.isUserInteractionEnabled = true
        tripHeaderView.editTripButton.isHidden = true
        myToDoHeaderView.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        stickyMyToDoHeaderView.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
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
        scrollView.contentSize = myToDoCollectionView.frame.size
    }
    
    /// 미완료/완료에 따라 todo cell style 설정해주는 메소드
    func setCellStyle(cell: MyToDoCollectionViewCell, data: MyToDo, textColor: UIColor, isUserInteractionEnabled: Bool, buttonImg: UIImage) {
        cell.myToDoData = data
        cell.todoTitleLabel.textColor = textColor
        cell.managerCollectionView.isUserInteractionEnabled = isUserInteractionEnabled
        cell.checkButton.setImage(buttonImg, for: .normal)
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
            stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex = myToDoHeaderView.segmentedControl.selectedSegmentIndex
            self.view.backgroundColor = .gray50
            self.navigationBarview.backgroundColor = .gray50
        } else {
            myToDoHeaderView.segmentedControl.selectedSegmentIndex = stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex
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
        let myToDoHeaderIndex = self.myToDoHeaderView.segmentedControl.selectedSegmentIndex
        let stickHeaderIndex = self.stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex
        if self.stickyMyToDoHeaderView.isHidden {
            if (myToDoHeaderIndex == 0 && stickHeaderIndex == 0) || (myToDoHeaderIndex == 0 && stickHeaderIndex == 1){
                self.loadData()
                return self.incompletedData.count
            }else if (myToDoHeaderIndex == 1 && stickHeaderIndex == 1) || (myToDoHeaderIndex == 1 && stickHeaderIndex == 0) {
                self.loadData()
                return self.completedData.count
            }else { return 0}
        }else {
            if (myToDoHeaderIndex == 1 && stickHeaderIndex == 0) || (myToDoHeaderIndex == 0 && stickHeaderIndex == 0){
                self.loadData()
                return self.incompletedData.count
            }else if (myToDoHeaderIndex == 1 && stickHeaderIndex == 1) || (myToDoHeaderIndex == 0 && stickHeaderIndex == 1) {
                self.loadData()
                return self.completedData.count
            }else {return 0}
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let myToDoCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyToDoCollectionViewCell.identifier, for: indexPath) as? MyToDoCollectionViewCell else {return UICollectionViewCell()}
        myToDoCell.delegate = self

        let myToDoHeaderIndex = self.myToDoHeaderView.segmentedControl.selectedSegmentIndex
        let stickHeaderIndex = self.stickyMyToDoHeaderView.segmentedControl.selectedSegmentIndex

        if self.stickyMyToDoHeaderView.isHidden {
            if (myToDoHeaderIndex == 0 && stickHeaderIndex == 0) || (myToDoHeaderIndex == 0 && stickHeaderIndex == 1){
                self.setCellStyle(cell: myToDoCell, data: self.incompletedData[indexPath.row], textColor: UIColor.gray400, isUserInteractionEnabled: true, buttonImg: ImageLiterals.MyToDo.btnCheckBoxIncomplete)
                    myToDoCell.index = indexPath.row
            }else if (myToDoHeaderIndex == 1 && stickHeaderIndex == 1) || (myToDoHeaderIndex == 1 && stickHeaderIndex == 0) {
                self.setCellStyle(cell: myToDoCell, data: self.completedData[indexPath.row], textColor: UIColor.gray300, isUserInteractionEnabled: false, buttonImg: ImageLiterals.MyToDo.btnCheckBoxComplete)
                    myToDoCell.index = indexPath.row
            }else {}
        }else {
            if (myToDoHeaderIndex == 1 && stickHeaderIndex == 0) || (myToDoHeaderIndex == 0 && stickHeaderIndex == 0){
                self.setCellStyle(cell: myToDoCell, data: self.incompletedData[indexPath.row], textColor: UIColor.gray400, isUserInteractionEnabled: true, buttonImg: ImageLiterals.MyToDo.btnCheckBoxIncomplete)
                    myToDoCell.index = indexPath.row
            }else if (myToDoHeaderIndex == 1 && stickHeaderIndex == 1) || (myToDoHeaderIndex == 0 && stickHeaderIndex == 1) {
                self.setCellStyle(cell: myToDoCell, data: self.completedData[indexPath.row], textColor: UIColor.gray300, isUserInteractionEnabled: false, buttonImg: ImageLiterals.MyToDo.btnCheckBoxComplete)
                    myToDoCell.index = indexPath.row
            }else {}
        }
        return myToDoCell
    }
}
