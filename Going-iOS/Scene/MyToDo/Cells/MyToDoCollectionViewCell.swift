//
//  MyToDoCollectionViewCell.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/7/24.
//

import UIKit

protocol MyToDoCollectionViewDelegate: AnyObject {
    func getButtonIndex(index: Int, image: UIImage)
    func pushToToDo()
}

class MyToDoCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let identifier = "MyToDoCollectionViewCell"
    weak var delegate: MyToDoCollectionViewDelegate?
    var manager: [String] = []
    // TODO: - 사용자 id 값 비교해서 담당자가 본인인지 확인
    var myToDoData: MyToDo? {
        didSet {
            guard let myToDoData else {return}
            self.todoTitleLabel.text = myToDoData.todoTitle
            self.deadlineLabel.text = myToDoData.deadline + "까지"
            self.manager = (myToDoData.manager[0] == "지민") && myToDoData.isPrivate ? ["나만보기"] : myToDoData.manager
        }
    }
    var index: Int? {
        didSet {
            guard let index else {return}
            self.index = index
            self.managerCollectionView.reloadData()
        }
    }
    var textColor: UIColor? {
        didSet {
            guard let textColor else {return}
            self.todoTitleLabel.textColor = textColor
        }
    }
    var buttonImg: UIImage? {
        didSet {
            guard let buttonImg else {return}
            self.checkButton.setImage(buttonImg, for: .normal)
            self.managerCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Components
    
    private let todoBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.gray50
        return view
    }()
    lazy var todoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(.body3_medi)
        label.textColor = UIColor.gray700
        label.textAlignment = .left
        return label
    }()
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(.detail3_regular)
        label.textColor = UIColor.gray300
        label.textAlignment = .center
        return label
    }()
    lazy var managerCollectionView: UICollectionView = {setCollectionView()}()
    lazy var checkButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.MyToDo.btnCheckBoxIncomplete, for: .normal)
        btn.addTarget(self, action: #selector(checkButtonTap), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierachy()
        registerCell()
        setLayout()
        setStyle()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func checkButtonTap() {
        let index = self.index ?? 0
        let image = self.checkButton.imageView?.image ?? UIImage()
        self.delegate?.getButtonIndex(index: index, image: image)
    }
    
    @objc
    func tapManagerCollectionView(_ sender: UITapGestureRecognizer) {
        self.delegate?.pushToToDo()
    }
}

// MARK: - Private Method

private extension MyToDoCollectionViewCell {
    
    func setHierachy() {
        contentView.addSubview(todoBackgroundView)
        todoBackgroundView.addSubviews(checkButton, todoTitleLabel, managerCollectionView, deadlineLabel)
    }
    
    func setLayout() {
        todoBackgroundView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        checkButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(16))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(12))
            $0.size.equalTo(ScreenUtils.getHeight(20))
        }
        todoTitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.leading.equalTo(checkButton.snp.trailing).offset(ScreenUtils.getWidth(12))
        }
        managerCollectionView.snp.makeConstraints{
            $0.leading.equalTo(checkButton.snp.trailing).offset(ScreenUtils.getWidth(12))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(15))
            $0.height.equalTo(ScreenUtils.getHeight(20))
        }
        deadlineLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(18))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
        }
    }
    
    func setStyle() {
        managerCollectionView.backgroundColor = .gray50
    }
    
    func setManagerLabel(label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.cornerRadius = 5
    }
    func setCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout(width: 42))
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapManagerCollectionView(_:))))
        return collectionView
    }
    
    func setCollectionViewLayout(width: CGFloat) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = ScreenUtils.getWidth(4)
        flowLayout.minimumLineSpacing = ScreenUtils.getWidth(4)
        flowLayout.itemSize = CGSize(width: ScreenUtils.getWidth(width), height: ScreenUtils.getHeight(20))
        return flowLayout
    }

    func setDelegate() {
        self.managerCollectionView.dataSource = self
        self.managerCollectionView.delegate = self
    }
    
    func registerCell() {
        self.managerCollectionView.register(ManagerCollectionViewCell.self, forCellWithReuseIdentifier: ManagerCollectionViewCell.identifier)
    }
    
    func setLabelWithImage(label: UILabel, string: String, isComplete: Bool) {
        let string = NSAttributedString(string: " \(string)" )
        let attachment = NSTextAttachment()
        // 완료/미완료에 따라 자물쇠 이미지 세팅
        let image = isComplete ? ImageLiterals.MyToDo.icLockLight : ImageLiterals.MyToDo.icLockDark
        attachment.image = image
        // 이미지와 라벨 수직 정렬 맞춰주기
        attachment.bounds = CGRect(x: 0, y: ScreenUtils.getHeight(-1), width: image.size.width, height: image.size.height)
        let attachImg = NSAttributedString(attachment: attachment)
        label.labelWithImg(composition: attachImg, string)
    }
}

// MARK: - Extension

extension MyToDoCollectionViewCell: UICollectionViewDelegate{}

extension MyToDoCollectionViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.manager.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let managerCell = collectionView.dequeueReusableCell(withReuseIdentifier: ManagerCollectionViewCell.identifier, for: indexPath) as? ManagerCollectionViewCell else {return UICollectionViewCell()}
        let data = self.myToDoData ?? MyToDo.emptyMyToDo
        
        if data.isPrivate {
            setLabelWithImage(
                label: managerCell.managerLabel,
                string: self.manager[indexPath.row],
                isComplete: data.isComplete)
        }else {
            managerCell.managerLabel.text = self.manager[indexPath.row]
        }
        
        // 미완료 / 완료 / 나만보기 태그 색상 세팅
        // TODO: - id 값으로 본인 확인하고 색상 세팅
        if self.myToDoData?.isComplete == false {
            self.manager[indexPath.row] == "지민" ? managerCell.changeLabelColor(color: .red400) : managerCell.changeLabelColor(color: .gray400)
        }else{
            managerCell.changeLabelColor(color: .gray300)
        }
        return managerCell
    }
}

extension MyToDoCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {return CGSize()}

        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = ScreenUtils.getWidth(4)
        layout.minimumLineSpacing = ScreenUtils.getWidth(4)
        
        let stringLength = self.manager[indexPath.row] == "나만보기"
        ? self.manager[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.pretendard(.detail2_regular)]).width + ScreenUtils.getWidth(12)
        : self.manager[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.pretendard(.detail2_regular)]).width
        return CGSize(width: stringLength + ScreenUtils.getWidth(12), height: ScreenUtils.getHeight(20))
    }
}
