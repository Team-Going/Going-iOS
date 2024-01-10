import UIKit

protocol OurToDoCollectionViewDelegate: AnyObject {
    func pushToToDo()
}

final class OurToDoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let identifier = "OurToDoCollectionViewCell"
    weak var delegate: OurToDoCollectionViewDelegate?
    var manager: [String] = []
    var ourToDoData: OurToDo? {
        didSet {
            guard let ourToDoData else {return}
            self.todoTitleLabel.text = ourToDoData.todoTitle
            self.deadlineLabel.text = ourToDoData.deadline + "까지"
            self.manager = ourToDoData.manager
            
            self.managerCollectionView.reloadData()
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
    
    // MARK: - UI Properties
    
    var todoBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.gray50
        return view
    }()
    let todoTitleLabel: UILabel = DOOLabel(font: .pretendard(.body3_medi), color: .gray700, alignment: .left)
    private lazy var deadlineLabel: UILabel = DOOLabel(font: .pretendard(.detail3_regular), color: .gray300, alignment: .center)
    lazy var managerCollectionView: UICollectionView = {setCollectionView()}()

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        registerCell()
        setLayout()
        setStyle()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func tapManagerCollectionView(_ sender: UITapGestureRecognizer) {
        self.delegate?.pushToToDo()
    }
}

// MARK: - Private Method

private extension OurToDoCollectionViewCell {
    
    func setHierarchy() {
        contentView.addSubview(todoBackgroundView)
        todoBackgroundView.addSubviews(todoTitleLabel, managerCollectionView, deadlineLabel)
    }
    
    func setLayout() {
        todoBackgroundView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        todoTitleLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(ScreenUtils.getWidth(16))
        }
        managerCollectionView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(16))
            $0.height.equalTo(ScreenUtils.getHeight(20))
        }
        deadlineLabel.snp.makeConstraints{
            $0.top.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
        }
    }
    
    func setStyle() {
        managerCollectionView.backgroundColor = .gray50
    }
    
    func setLabel(font: UIFont, textColor: UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.textAlignment = alignment
        return label
    }
    
    func setCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapManagerCollectionView(_:))))
        return collectionView
    }
    
    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = ScreenUtils.getWidth(4)
        flowLayout.minimumLineSpacing = ScreenUtils.getWidth(4)
        flowLayout.itemSize = CGSize(width: ScreenUtils.getWidth(42) , height: ScreenUtils.getHeight(20))
        return flowLayout
    }
    
    func setDelegate() {
        self.managerCollectionView.dataSource = self
        self.managerCollectionView.delegate = self
    }
    
    func registerCell() {
        self.managerCollectionView.register(ManagerCollectionViewCell.self, forCellWithReuseIdentifier: ManagerCollectionViewCell.identifier)
    }
    
}

extension OurToDoCollectionViewCell: UICollectionViewDelegate {}

extension OurToDoCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.manager.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let managerCell = collectionView.dequeueReusableCell(withReuseIdentifier: ManagerCollectionViewCell.identifier, for: indexPath) as? ManagerCollectionViewCell else {return UICollectionViewCell()}
        print("our \(self.manager[indexPath.row])")
        managerCell.managerData = self.manager[indexPath.row]
        if self.ourToDoData?.isComplete == false {
            self.manager[indexPath.row] == "지민" ? managerCell.changeLabelColor(color: .red400) : managerCell.changeLabelColor(color: .gray400)
        }else{
            managerCell.changeLabelColor(color: .gray300)
        }
        return managerCell
    }
}
