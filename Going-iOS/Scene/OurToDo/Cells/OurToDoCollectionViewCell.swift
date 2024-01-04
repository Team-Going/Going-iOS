import UIKit

protocol OurToDoCollectionViewDelegate: AnyObject {
    func getManagersData()
}

class OurToDoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let identifier = "OurToDoCollectionViewCell"
    let absoluteWidth = UIScreen.main.bounds.width / 375
    let absoluteHeight = UIScreen.main.bounds.height / 812
    weak var delegate: OurToDoCollectionViewDelegate?
    var manager: [String] = []
    var data: OurToDo? {
        didSet {
            guard let data = data else {return}
            self.todoTitleLabel.text = data.todoTitle
            self.deadlineLabel.text = data.deadline + "까지"
            self.manager = data.manager
            
            self.managerCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Properties
    
    var todoBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.gray50
        return view
    }()
    lazy var todoTitleLabel: UILabel = {setLabel(font: UIFont.pretendard(.body3_medi), textColor: UIColor.gray700, alignment: .left)}()
    private lazy var deadlineLabel: UILabel = {setLabel(font: UIFont.pretendard(.detail3_regular), textColor: UIColor.gray300, alignment: .center)}()
    lazy var managerCollectionView: UICollectionView = {setCollectionView()}()

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
}

// MARK: - Private Method

private extension OurToDoCollectionViewCell {
    
    func setHierachy() {
        contentView.addSubview(todoBackgroundView)
        todoBackgroundView.addSubviews(todoTitleLabel, managerCollectionView, deadlineLabel)
    }
    
    func setLayout() {
        todoBackgroundView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        todoTitleLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(absoluteWidth * 16)
//            $0.height.equalTo(absoluteHeight * 21)
        }
        managerCollectionView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(absoluteWidth * 16)
            $0.bottom.equalToSuperview().inset(absoluteHeight * 16)
            $0.height.equalTo(absoluteHeight * 20)
        }
        deadlineLabel.snp.makeConstraints{
            $0.top.trailing.equalToSuperview().inset(absoluteWidth * 16)
//            $0.height.equalTo(18)
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
        return collectionView
    }
    
    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = absoluteWidth * 4
        flowLayout.minimumLineSpacing = absoluteWidth * 4
        flowLayout.itemSize = CGSize(width: absoluteWidth * 42 , height: absoluteHeight * 20)
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
        if self.data?.isComplete == false {
            self.manager[indexPath.row] == "지민" ? managerCell.changeLabelColor(color: .red400) : managerCell.changeLabelColor(color: .gray400)
        }else{
            managerCell.changeLabelColor(color: .gray300)
        }
        return managerCell
    }
}
