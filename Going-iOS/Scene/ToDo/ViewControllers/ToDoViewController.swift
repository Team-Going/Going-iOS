import UIKit

import SnapKit

final class ToDoViewController: UIViewController {

    // MARK: - UI Components

    private lazy var navigationBarView = {
        let navView = NavigationView()
        navView.titleLabel.text = "할일 추가"
        navView.backButton.addTarget(self, action: #selector(popToOurToDoView), for: .touchUpInside)
        return navView
    }()
    private let contentView: UIView = UIView()
    private let todoLabel: UILabel = {
        let label = UILabel()
        label.setTitleLabel(title: "할 일")
        return label
    }()
    private let todoTextfield: UITextField = {
        let tf = UITextField()
        tf.font = .pretendard(.body3_medi)
        tf.textColor = .gray700
        tf.backgroundColor = .white000
        tf.borderStyle = .roundedRect
        tf.layer.borderColor = UIColor.gray200.cgColor
        tf.layer.cornerRadius = 6
        tf.layer.borderWidth = 1
        tf.setLeftPadding(amount: 12)
        return tf
    }()
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.setTitleLabel(title: "언제까지")
        return label
    }()
    private let deadlineTextfieldLabel: UILabel = {
        let label = LeftPaddingLabel(padding: UIEdgeInsets(top: 0.0, left: 18.0, bottom: 0.0, right: 18.0))
        label.font = .pretendard(.body3_medi)
        label.textColor = .gray200
        label.backgroundColor = .white000
        label.textAlignment = .left
        label.layer.borderColor = UIColor.gray200.cgColor
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        label.isUserInteractionEnabled = true
        return label
    }()
    private let dropdownContainer: UIView = UIView()
    private lazy var dropdownButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.ToDo.disabledDropdown, for: .normal)
        btn.backgroundColor = .white000
        btn.addTarget(self, action: #selector(presentToDatePicker(_:)), for: .touchUpInside)
        return btn
    }()
    private let managerLabel: UILabel = {
        let label = UILabel()
        label.setTitleLabel(title: "누가하나요?")
        return label
    }()
    private lazy var todoManagerCollectionView: UICollectionView = {
        setCollectionView()
    }()
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.setTitleLabel(title: "메모")
        return label
    }()
    private let memoTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .white000
        tv.textContainerInset = UIEdgeInsets(top: ScreenUtils.getHeight(12), left: ScreenUtils.getWidth(12), bottom: ScreenUtils.getHeight(12), right: ScreenUtils.getWidth(12))
        tv.font = .pretendard(.body3_medi)
        tv.textColor = .gray200
        tv.layer.borderColor = UIColor.gray200.cgColor
        tv.layer.cornerRadius = 6
        tv.layer.borderWidth = 1
        return tv
    }()
    
    // MARK: - Properties
    
    lazy var navigationBarTitle: String = ""
    lazy var isActivateView: Bool = true
    var getToDoData: ToDoData?
    var manager: [Manager] = []
    var memoTextviewPlaceholder: String = ""
    var todoTextfieldPlaceholder: String = ""
    var saveToDoData: ToDoData?
    var data: ToDoData? {
        didSet {
            guard let todoData = data else {return}
            self.getToDoData = todoData
            todoTextfield.text = self.getToDoData?.todo
            deadlineTextfieldLabel.text = self.getToDoData?.deadline
            manager = self.getToDoData?.manager ?? []
            memoTextView.text = self.getToDoData?.memo
        }
    }
    var setDefaultValue: [Any]? {
        didSet {
            guard let value = setDefaultValue else {return}
            todoTextfieldPlaceholder = value[0] as! String
            todoTextfield.placeholder = todoTextfieldPlaceholder
            deadlineTextfieldLabel.text = value[1] as? String
            manager = value[2] as! [Manager]
            memoTextviewPlaceholder = value[3] as! String
            memoTextView.text = memoTextviewPlaceholder
        }
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setHierachy()
        setLayout()
        registerCell()
        setDelegate()
        setStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationBarView.backgroundColor = .gray50
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - @objc Methods

    @objc
    func popToOurToDoView() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc
    func presentToDatePicker(_ sender: UITapGestureRecognizer) {
        print("presentToDatePicker")
    }
    
    @objc
    func didTapToDoManagerButton(_ sender: UIButton) {
        if isActivateView {
            changeButtonConfig(isSelected: sender.isSelected, btn: sender)
            sender.isSelected = sender.isSelected ? false : true
            manager[sender.tag].isManager = sender.isSelected ? true : false
        }
    }
}

// MARK: - Prviate Methods

private extension ToDoViewController {
    
    func setHierachy() {
        self.view.addSubviews(navigationBarView, contentView)
        contentView.addSubviews(todoLabel, todoTextfield, deadlineLabel, deadlineTextfieldLabel, managerLabel, todoManagerCollectionView, memoLabel, memoTextView)
        deadlineTextfieldLabel.addSubview(dropdownButton)

    }
    
    func setLayout() {
        navigationBarView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        contentView.snp.makeConstraints{
            $0.top.equalTo(navigationBarView.snp.bottom).offset(ScreenUtils.getHeight(40))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(18))
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(60))
        }
        
        todoLabel.snp.makeConstraints{
            $0.top.equalTo(navigationBarView.snp.bottom).offset(ScreenUtils.getHeight(40))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(19))
        }
        todoTextfield.snp.makeConstraints{
            $0.top.equalTo(todoLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(48))
        }
        deadlineLabel.snp.makeConstraints{
            $0.top.equalTo(todoTextfield.snp.bottom).offset(ScreenUtils.getHeight(28))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(19))
        }
        deadlineTextfieldLabel.snp.makeConstraints{
            $0.top.equalTo(deadlineLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(48))
        }
        dropdownButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(19))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(ScreenUtils.getHeight(22))
        }
        managerLabel.snp.makeConstraints{
            $0.top.equalTo(deadlineTextfieldLabel.snp.bottom).offset(ScreenUtils.getHeight(28))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(19))
        }
        todoManagerCollectionView.snp.makeConstraints{
            $0.top.equalTo(managerLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(48))
        }
        memoLabel.snp.makeConstraints{
            $0.top.equalTo(todoManagerCollectionView.snp.bottom).offset(ScreenUtils.getHeight(28))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(19))
        }
        memoTextView.snp.makeConstraints{
            $0.top.equalTo(memoLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(143))
        }
        
    }
    
    // TODO: - 할일 조회 일 경우 placeholder 값이 이전에 세팅된 값이어야 함
    
    func setStyle() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white000
        contentView.backgroundColor = .white000
        navigationBarView.backgroundColor = .white000
        dropdownContainer.backgroundColor = .white
        switch navigationBarTitle {
        case "추가": navigationBarView.titleLabel.text = "할일 추가"
            setDefaultValue = ["할일을 입력해주세요.", "날짜를 선택해주세요.", self.manager , "메모를 입력해주세요."]
        case "조회": navigationBarView.titleLabel.text = "할일 조회"
            setDefaultValue = ["조회", "조회", self.manager , "조회"]
        case "수정": navigationBarView.titleLabel.text = "할일 수정"
            setDefaultValue = ["수정", "수정", self.manager , "수정"]
        default: return
        }
    }
    
    func setDelegate() {
        todoManagerCollectionView.dataSource = self
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
        flowLayout.itemSize = CGSize(width: ScreenUtils.getWidth(45) , height: ScreenUtils.getHeight(24))
        return flowLayout
    }
    
    func registerCell() {
        self.todoManagerCollectionView.register(ToDoManagerCollectionViewCell.self, forCellWithReuseIdentifier: ToDoManagerCollectionViewCell.identifier)
    }
    
    /// 버튼 클릭 시 버튼 스타일 변경해주는 메소드
    func changeButtonConfig(isSelected: Bool, btn: UIButton) {
        if !isSelected {
            btn.setTitleColor(.white000, for: .normal)
            btn.backgroundColor = .gray400
        }else {
            btn.setTitleColor(.gray300, for: .normal)
            btn.backgroundColor = .white000
        }
    }
}

// MARK: - Extension

extension ToDoViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.manager.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let managerCell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoManagerCollectionViewCell.identifier, for: indexPath) as? ToDoManagerCollectionViewCell else {return UICollectionViewCell()}
        
        let name = manager[indexPath.row].name
        
        managerCell.managerButton.setTitle(name, for: .normal)
        managerCell.managerButton.tag = indexPath.row
        managerCell.managerButton.addTarget(self, action: #selector(didTapToDoManagerButton(_:)), for: .touchUpInside)
        if manager[indexPath.row].isManager {
            managerCell.managerButton.isSelected = true
            managerCell.managerButton.setTitleColor(.white000, for: .normal)
            managerCell.managerButton.backgroundColor = .red500
        }
        return managerCell
    }
}
