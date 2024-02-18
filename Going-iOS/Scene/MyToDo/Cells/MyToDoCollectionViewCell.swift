import UIKit

protocol MyToDoCollectionViewDelegate: AnyObject {
    func getButtonIndex(index: Int, image: UIImage)
}

class MyToDoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MyToDoCollectionViewCell"
    weak var delegate: MyToDoCollectionViewDelegate?
    var manager: [Allocators] = []
    var myToDoData: ToDoAppData? {
        didSet {
            guard let myToDoData else {return}
            self.todoTitleLabel.text = myToDoData.title
            self.deadlineLabel.text = myToDoData.endDate + "까지"
            self.manager = myToDoData.allocators
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
    var isComplete: Bool? {
        didSet {
            self.managerCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Components
    
    private let todoBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(resource: .gray50)
        return view
    }()
    lazy var todoTitleLabel: UILabel = DOOLabel(font: .pretendard(.body3_medi), color: UIColor(resource: .gray700), alignment: .left)
    private let deadlineLabel: UILabel = DOOLabel(font: .pretendard(.detail3_regular), color: UIColor(resource: .gray300), alignment: .center)

    private let  managerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
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
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(16))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
        }
    }
    
    func setStyle() {
        managerCollectionView.backgroundColor = UIColor(resource: .gray50)
    }
    
    func setManagerLabel(label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = UIColor(resource: .white000)
        label.backgroundColor = UIColor(resource: .black000)
        label.layer.cornerRadius = 5
    }
    func setCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }
    

    func setDelegate() {
        self.managerCollectionView.dataSource = self
        self.managerCollectionView.delegate = self
    }
    
    func registerCell() {
        self.managerCollectionView.register(ManagerCollectionViewCell.self, forCellWithReuseIdentifier: ManagerCollectionViewCell.identifier)
    }
    
    func setLabelWithImage(label: UILabel, string: String) {
        let string = NSAttributedString(string: " \(string)" )
        let attachment = NSTextAttachment()
        // 완료/미완료에 따라 자물쇠 이미지 세팅
        let image = isComplete! ? ImageLiterals.MyToDo.icLockLight : ImageLiterals.MyToDo.icLockDark
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
        let data = self.myToDoData ?? ToDoAppData(todoId: 0, title: "", endDate: "", allocators: [], secret: false)
        
        if data.secret {
            managerCell.managerData = "혼자할일"
            setLabelWithImage(
                label: managerCell.managerLabel,
                string: "혼자할일")
        }else {
            managerCell.managerLabel.text = self.manager[indexPath.row].name
        }
        
        // 미완료 / 완료 / 나만보기 태그 색상 세팅
        if isComplete == true {
            managerCell.changeLabelColor(color: UIColor(resource: .gray300))
        }else{
            // owner
            if manager[indexPath.row].isOwner {
                if self.myToDoData?.secret == true {
                    managerCell.changeLabelColor(color: UIColor(resource: .gray400))
                }else {
                    managerCell.changeLabelColor(color: UIColor(resource: .red500))
                }
            }else {
                managerCell.changeLabelColor(color: UIColor(resource: .gray400))
            }
        }
        return managerCell
    }
}

extension MyToDoCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ScreenUtils.getWidth(4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ScreenUtils.getWidth(4)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //자물쇠
        if myToDoData?.secret == true {
            return CGSize(width: ScreenUtils.getWidth(66), height: ScreenUtils.getHeight(20))
        } else {
            return CGSize(width: ScreenUtils.getWidth(42), height: ScreenUtils.getHeight(20))
        }
    }
}
