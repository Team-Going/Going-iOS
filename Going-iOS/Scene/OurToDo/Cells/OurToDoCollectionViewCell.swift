import UIKit

protocol OurToDoCollectionViewDelegate: AnyObject {
    func pushToInquiry(todoId: Int, allocators: [Allocators])
}

final class OurToDoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let identifier = "OurToDoCollectionViewCell"
    
    weak var delegate: OurToDoCollectionViewDelegate?
    
    var ourToDoData: ToDoAppData? {
        didSet {
            guard let ourToDoData else {return}
            self.todoTitleLabel.text = ourToDoData.title
            self.deadlineLabel.text = ourToDoData.endDate + "까지"
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

    var isComplete: Bool? {
        didSet {
            self.managerCollectionView.reloadData()
        }
    }
    
    var todoId: Int = 0
    
    var allocators: [Allocators] = []
    
    // MARK: - UI Properties
    
    var todoBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(resource: .gray50)
        return view
    }()
    
    let todoTitleLabel: UILabel = DOOLabel(
        font: .pretendard(.body3_medi),
        color: UIColor(resource: .gray700),
        alignment: .left
    )
   
    private lazy var deadlineLabel: UILabel = DOOLabel(
        font: .pretendard(.detail3_regular),
        color: UIColor(resource: .gray300),
        alignment: .center
    )
    
    lazy var managerCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapManagerCollectionView(_:))))
        return collectionView
    }()

    
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
        self.delegate?.pushToInquiry(todoId: todoId, allocators: allocators)
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
        managerCollectionView.backgroundColor = UIColor(resource: .gray50)
    }
    
    func setLabel(font: UIFont, textColor: UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.textAlignment = alignment
        return label
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
        
        //담당자가 없는 경우
        if ourToDoData?.allocators.count == 0 {
            return 1
        } else {
            return ourToDoData?.allocators.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let managerCell = collectionView.dequeueReusableCell(withReuseIdentifier: ManagerCollectionViewCell.identifier, for: indexPath) as? ManagerCollectionViewCell else {return UICollectionViewCell()}
        
        self.todoId = self.ourToDoData?.todoId ?? 0
        self.allocators = self.ourToDoData?.allocators ?? []
        
        //담당자가 없는 경우
        if self.ourToDoData?.allocators.count == 0 {
            managerCell.isEmpty = true
            managerCell.managerData = StringLiterals.OurToDo.emptyAllocator
        } 
        //담당자가 있는 경우
        else {
            managerCell.isEmpty = false
            managerCell.managerLabel.backgroundColor = UIColor.clear
            managerCell.managerData = ourToDoData?.allocators[indexPath.row].name
            if isComplete == true {
                managerCell.changeLabelColor(color: UIColor(resource: .gray300))
            } else {
                if ourToDoData?.allocators[indexPath.row].isOwner == true {
                    managerCell.changeLabelColor(color: UIColor(resource: .red500))
                }else {
                    managerCell.changeLabelColor(color: UIColor(resource: .gray400))
                }
            }
        }

        return managerCell
    }
}

extension OurToDoCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ScreenUtils.getWidth(4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ScreenUtils.getWidth(4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if ourToDoData?.allocators.count == 0 {
            return CGSize(width: ScreenUtils.getWidth(94) , height: ScreenUtils.getHeight(20))
        } else {
            let name = ourToDoData?.allocators[indexPath.row].name ?? ""
            if name.containsEmoji() {
                return CGSize(width: ScreenUtils.getWidth(60), height: ScreenUtils.getHeight(20))
            } else {
                return CGSize(width: ScreenUtils.getWidth(42), height: ScreenUtils.getHeight(20))
            }        }
    }
}
