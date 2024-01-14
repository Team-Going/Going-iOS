import UIKit

import SnapKit

final class ToDoViewController: UIViewController {

    // MARK: - UI Components

    private lazy var navigationBarView = DOONavigationBar(self, type: .backButtonWithTitle(StringLiterals.ToDo.inquiryToDo), backgroundColor: .white000)
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    private let contentView: UIView = UIView()
    private let todoLabel: UILabel = DOOLabel(font: .pretendard(.body2_bold), color: .gray700, text: StringLiterals.ToDo.todo)
    private let todoTextfield: UITextField = {
        let tf = UITextField()
        tf.setTextField(forPlaceholder: "", forBorderColor: .gray200, forCornerRadius: 6)
        tf.font = .pretendard(.body3_medi)
        tf.setPlaceholderColor(.gray700)
        tf.textColor = .gray700
        tf.backgroundColor = .white000
        tf.setLeftPadding(amount: 12)
        return tf
    }()
    private let countToDoCharacterLabel: UILabel = DOOLabel(font: .pretendard(.detail2_regular), color: .gray200, text: "0/15")
    private let deadlineLabel: UILabel = DOOLabel(font: .pretendard(.body2_bold), color: .gray700, text: StringLiterals.ToDo.deadline)
    private let deadlineTextfieldLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.body3_medi), color: .gray200, alignment: .left, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0))
        label.backgroundColor = .white000
        label.layer.borderColor = UIColor.gray200.cgColor
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        label.isUserInteractionEnabled = true
        return label
    }()
    private let bottomSheetVC = DatePickerBottomSheetViewController()
    private let dropdownContainer: UIView = UIView()
    private lazy var dropdownButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.ToDo.disabledDropdown, for: .normal)
        btn.backgroundColor = .white000
        btn.addTarget(self, action: #selector(presentToDatePicker), for: .touchUpInside)
        return btn
    }()
    private let managerLabel: UILabel = DOOLabel(font: .pretendard(.body2_bold), color: .gray700, text: StringLiterals.ToDo.allocation)
    private lazy var todoManagerCollectionView: UICollectionView = {
        setCollectionView()
    }()
    private let memoLabel: UILabel = DOOLabel(font: .pretendard(.body2_bold), color: .gray700, text: StringLiterals.ToDo.memo)
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
    private let countMemoCharacterLabel: UILabel = DOOLabel(font: .pretendard(.detail2_regular), color: .gray200, text: "0/1000")
    private let buttonView: UIView = UIView()
    private lazy var singleButtonView: DOOButton = {
        let singleBtn = DOOButton(type: .unabled, title: StringLiterals.ToDo.toSave)
        singleBtn.addTarget(self, action: #selector(saveToDo), for: .touchUpInside)
        return singleBtn
    }()
    private lazy var doubleButtonView = DoubleButtonView()
    
    // MARK: - Properties
    
    lazy var beforeVC: String = ""
    lazy var navigationBarTitle: String = ""
    lazy var manager: [Allocators] = []
    private var getToDoData: DetailToDoAppData?
    private var memoTextviewPlaceholder: String = ""
    private var todoTextfieldPlaceholder: String = ""
    private var saveToDoData: DetailToDoAppData?
    var data: DetailToDoAppData? {
        didSet {
            guard let data else {return}
            self.getToDoData = data
            todoTextfield.text = data.title
            deadlineTextfieldLabel.text = data.endDate
            manager = data.allocators
            if data.secret == true {
                manager[0].name = "혼자할일"
                manager.append(Allocators.EmptyData)
            }
            memoTextView.text = data.memo
            print(manager)
        }
    }
    var setDefaultValue: [Any]? {
        didSet {
            guard let value = setDefaultValue else {return}
            todoTextfieldPlaceholder = value[0] as! String
            todoTextfield.placeholder = todoTextfieldPlaceholder
            deadlineTextfieldLabel.text = value[1] as? String
            manager = value[2] as! [Allocators]
            memoTextviewPlaceholder = value[3] as! String
            memoTextView.text = memoTextviewPlaceholder
        }
    }
    
    var isActivateView: Bool? = false {
        didSet {
            guard let isActivateView else {return}
            self.todoTextfield.isUserInteractionEnabled = isActivateView ? true : false
            self.deadlineTextfieldLabel.isUserInteractionEnabled = isActivateView ? true : false
            self.todoManagerCollectionView.isUserInteractionEnabled = isActivateView ? true : false
            self.memoTextView.isUserInteractionEnabled = isActivateView ? true : false
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

    override func viewDidAppear(_ animated: Bool) {
        if navigationBarTitle == StringLiterals.ToDo.inquiry {
            setInquiryStyle()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationBarView.backgroundColor = .gray50
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - @objc Methods
    
    @objc
    func presentToDatePicker(for button: UIButton) {
        print("presentToDatePicker")
        showDatePicker(for: button)
        dropdownButton.setImage(ImageLiterals.ToDo.tappedDropdown, for: .normal)
    }
    
    // 담당자 버튼 탭 시 버튼 색상 변경 & 배열에 담아주는 메서드
    @objc
    func didTapToDoManagerButton(_ sender: UIButton) {
        guard let isActivateView = self.isActivateView else {return}
        if isActivateView {
            changeButtonConfig(isSelected: sender.isSelected, btn: sender)
            sender.isSelected = sender.isSelected ? false : true
            manager[sender.tag].isOwner = sender.isSelected ? true : false
        }
    }
    
    // 저장 버튼 탭 시 데이터를 배열에 담아주고 아워투두 뷰로 돌아가는 메서드
    @objc
    func saveToDo() {
        let todo = todoTextfield.text ?? ""
        let deadline = (deadlineTextfieldLabel.text == "날짜를 선택해주세요." ? "" : deadlineTextfieldLabel.text) ?? ""
        let memo = (memoTextView.text == memoTextviewPlaceholder ? "" : memoTextView.text) ?? ""
        let secret = beforeVC == "our" ? false : true
        if !todo.isEmpty && !deadline.isEmpty{
            self.saveToDoData = DetailToDoAppData(title: todo, endDate: deadline, allocators: manager, memo: memo, secret: secret)
            self.navigationController?.popViewController(animated: false)
            DOOToast.show(message: "할 일이 추가되었어요.", insetFromBottom: ScreenUtils.getHeight(106))
        }
    }
    
}

// MARK: - Prviate Methods

private extension ToDoViewController {
    
    func setHierachy() {
        self.view.addSubviews(navigationBarView, underlineView, contentView)
        contentView.addSubviews(
            todoLabel,
            todoTextfield,
            countToDoCharacterLabel,
            deadlineLabel,
            deadlineTextfieldLabel,
            managerLabel,
            todoManagerCollectionView,
            memoLabel,
            memoTextView,
            countMemoCharacterLabel,
            buttonView
        )
        deadlineTextfieldLabel.addSubview(dropdownButton)

    }
    
    func setLayout() {
        navigationBarView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        underlineView.snp.makeConstraints{
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        contentView.snp.makeConstraints{
            $0.top.equalTo(underlineView.snp.bottom).offset(ScreenUtils.getHeight(40))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(18))
            $0.bottom.equalToSuperview()
        }
        guard let isActivateView else {return}
        isActivateView ? setButtonView(button: singleButtonView) : setButtonView(button: doubleButtonView)
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
        countToDoCharacterLabel.snp.makeConstraints{
            $0.top.equalTo(todoTextfield.snp.bottom).offset(4)
            $0.trailing.equalTo(todoTextfield.snp.trailing).inset(4)
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
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(12))
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
        countMemoCharacterLabel.snp.makeConstraints{
            $0.top.equalTo(memoTextView.snp.bottom).offset(4)
            $0.trailing.equalTo(memoTextView.snp.trailing).inset(4)
        }
        buttonView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(40))
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
        case "추가": 
            navigationBarView.titleLabel.text = "할일 추가"
            setDefaultValue = ["할일을 입력해주세요.", "날짜를 선택해주세요.", self.manager , "메모를 입력해주세요."]
        case "조회": 
            navigationBarView.titleLabel.text = "할일 조회"
            setDefaultValue = [data?.title, data?.endDate, self.manager , data?.memo]
            setInquiryStyle()
        case "수정":
            navigationBarView.titleLabel.text = "할일 수정"
            setDefaultValue = ["수정", "수정", self.manager , "수정"]
        default: 
            return
        }
    }
    
    func setDelegate() {
        todoTextfield.delegate = self
        todoManagerCollectionView.dataSource = self
        todoManagerCollectionView.delegate = self
        memoTextView.delegate = self
        bottomSheetVC.delegate = self
        doubleButtonView.delegate = self
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
    
    /// 담당자 버튼 클릭 시 버튼 스타일 변경해주는 메소드
    func changeButtonConfig(isSelected: Bool, btn: UIButton) {
        if !isSelected {
            btn.setTitleColor(.white000, for: .normal)
            btn.backgroundColor = btn.tag == 0 ? UIColor.red500 : UIColor.gray400
            btn.layer.borderColor = btn.tag == 0 ? UIColor.red500.cgColor : UIColor.gray400.cgColor
        }else {
            btn.setTitleColor(.gray300, for: .normal)
            btn.backgroundColor = .white000
            btn.layer.borderColor = UIColor.gray300.cgColor
        }
    }
    
    // 추가, 조회 뷰에 따라 하단 버튼을 세팅해주는 메서드
    func setButtonView(button: UIView) {
        isActivateView = navigationBarTitle != "조회" ? true : false
        buttonView.addSubview(button)
        button.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    // 조회 뷰 스타일 세팅 메서드
    // TODO: - 서버 통신 할 때 버튼 색상 변경 로직 추가 + placeholder랑 비교해서 빈값인지 확인
    func setInquiryStyle() {
        guard let todotext = todoTextfield.placeholder?.count else {return}
        guard let memotext = memoTextView.text?.count else {return}
        todoTextfield.layer.borderColor = UIColor.gray700.cgColor
        todoTextfield.setPlaceholderColor(.gray700)
        countToDoCharacterLabel.textColor = .gray700
        countToDoCharacterLabel.text = "\(todotext)/15"
        deadlineTextfieldLabel.layer.borderColor = UIColor.gray700.cgColor
        deadlineTextfieldLabel.textColor = .gray700
        dropdownButton.setImage(ImageLiterals.ToDo.enabledDropdown, for: .normal)
        memoTextView.layer.borderColor = memoTextView.text == "메모를 입력해주세요." ? UIColor.gray200.cgColor : UIColor.gray700.cgColor
        memoTextView.textColor = memoTextView.text == "메모를 입력해주세요." ? UIColor.gray200 : UIColor.gray700
        countMemoCharacterLabel.text = "\(memotext)/1000"
        countMemoCharacterLabel.textColor = .gray700
    }
    
    /// 텍스트 필드에 들어갈 텍스트를 DateFormatter로  변환하는 메서드
    func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter.string(from: date)
    }
    
    /// DatePicker Presnet 하는 메서드
    func showDatePicker(for button: UIButton) {
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
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
        print("name \(name)")
        managerCell.managerButton.isEnabled = true
        managerCell.managerButton.setTitle(name, for: .normal)
        managerCell.managerButton.tag = indexPath.row
        managerCell.managerButton.addTarget(self, action: #selector(didTapToDoManagerButton(_:)), for: .touchUpInside)
        //아워투두 -> 조회
        //다 선택된 옵션
        //마이투두 -> 조회
        //혼자할일 + 라벨
        //아워투두
        if beforeVC == "our" {
            //조회
            if isActivateView == false {
                managerCell.managerButton.isSelected = true
                managerCell.managerButton.setTitleColor(.white000, for: .normal)
                if manager[indexPath.row].isOwner {
                    managerCell.managerButton.backgroundColor = .red500
                    managerCell.managerButton.layer.borderColor = UIColor.red500.cgColor
                } else {
                    managerCell.managerButton.backgroundColor = .gray400
                    managerCell.managerButton.layer.borderColor = UIColor.gray400.cgColor
                }
            } // 추가
            else {
                managerCell.managerButton.backgroundColor = .white000
                managerCell.managerButton.setTitleColor(.gray300, for: .normal)
                managerCell.managerButton.layer.borderColor = UIColor.gray300.cgColor
            }
        }// 마이투두
        else {
            // 조회
            if isActivateView == false {
                managerCell.managerButton.isSelected = true
                // 혼자 할 일
                if data?.secret == true {
                    //설명라벨 세팅
                    if manager[indexPath.row].name == "나만 볼 수 있는 할일이에요" {
                        managerCell.managerButton.isEnabled = false
                        managerCell.managerButton.backgroundColor = .white000
                        managerCell.managerButton.layer.borderColor = UIColor.white000.cgColor

                        managerCell.managerButton.setTitleColor(.gray200, for: .normal)
                    } else {
                        managerCell.managerButton.setImage(ImageLiterals.ToDo.orangeLock, for: .normal)
                        managerCell.managerButton.setTitleColor(.red500, for: .normal)
                        managerCell.managerButton.layer.borderColor = UIColor.red500.cgColor
                        managerCell.managerButton.backgroundColor = .white000
                    }
                } else{
                    managerCell.managerButton.setTitleColor(.white000, for: .normal)
                    if manager[indexPath.row].isOwner { //owner
                        managerCell.managerButton.backgroundColor = UIColor.red500
                        managerCell.managerButton.layer.borderColor = UIColor.red500.cgColor
                    }else {
                        managerCell.managerButton.backgroundColor = UIColor.gray400
                        managerCell.managerButton.layer.borderColor = UIColor.gray400.cgColor
                    }
                }
            }// 추가
            else {
                //설명라벨 세팅
                if manager[indexPath.row].name == "나만 볼 수 있는 할일이에요" {
                    managerCell.managerButton.isEnabled = true
                    managerCell.managerButton.backgroundColor = .white000
                    managerCell.managerButton.layer.borderColor = UIColor.white000.cgColor
                    managerCell.managerButton.setTitleColor(.white000, for: .normal)
                } else {
                    managerCell.managerButton.setImage(ImageLiterals.ToDo.orangeLock, for: .normal)
                    managerCell.managerButton.setTitleColor(.red500, for: .normal)
                    managerCell.managerButton.layer.borderColor = UIColor.red500.cgColor
                    managerCell.managerButton.backgroundColor = .white000
                }
            }
        }
        return managerCell
    }
}

extension ToDoViewController: UITextViewDelegate {

    func textViewDidBeginEditing (_ textView: UITextView) {
        todoTextfield.resignFirstResponder()
        textView.becomeFirstResponder()

        if textView.text == memoTextviewPlaceholder {
            textView.text = ""
            textView.textColor = .gray700
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard  let string = textView.text else { return  false }
        
        // newLength: 텍스트 필드의 현재 문자열 길이 + 사용자가 입력하는 문자열 길이 - 꺼질 길이
        let newLength = string.count + text.count - range.length
        if newLength == 0 {
            textView.layer.borderColor =  UIColor.gray200.cgColor
            countMemoCharacterLabel.textColor = .gray200
            countMemoCharacterLabel.text = "\(newLength)" + "/1000"
        } else if newLength < 1000 {
            textView.layer.borderColor =  UIColor.gray700.cgColor
            countMemoCharacterLabel.textColor = .gray700
            countMemoCharacterLabel.text = "\(newLength)" + "/1000"
        }
        return  !(newLength > 1000)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = memoTextviewPlaceholder
            textView.textColor = .gray200
        }
    }
}

extension ToDoViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing (_ textField: UITextField) {
        textField.placeholder = ""
        textField.becomeFirstResponder()
        memoTextView.resignFirstResponder()
    }
    func  textField ( _  textField : UITextField, shouldChangeCharactersIn  range : NSRange , replacementString  string : String ) -> Bool {
        guard  let text = textField.text else { return  false }

         let newLength = text.count + string.count - range.length

        if newLength == 0 {
            textField.layer.borderColor =  UIColor.gray200.cgColor
            countToDoCharacterLabel.textColor = .gray200
            singleButtonView.currentType = .unabled
            countToDoCharacterLabel.text = "\(newLength)" + "/15"
        } else if newLength < 16 {
            textField.layer.borderColor =  UIColor.gray700.cgColor
            countToDoCharacterLabel.textColor = .gray700
            countToDoCharacterLabel.text = "\(newLength)" + "/15"
            let todo = deadlineTextfieldLabel.text
            if todo != "날짜를 선택해주세요." {singleButtonView.currentType = .enabled}
        }
        return  !(newLength > 15)
    }
}

extension ToDoViewController: BottomSheetDelegate {
    func datePickerDidChanged(date: Date) {
        print("dddd")
        // 실시간 반영 구현 해야합니다 ㅠㅠ
    }
    
    func didSelectDate(date: Date) {
        let formattedDate = dateFormat(date: date)
        deadlineTextfieldLabel.text = formattedDate
        deadlineTextfieldLabel.textColor = .gray700
        deadlineTextfieldLabel.layer.borderColor = UIColor.gray700.cgColor
        dropdownButton.setImage(ImageLiterals.ToDo.enabledDropdown, for: .normal)
        if todoTextfield.text != "" {singleButtonView.currentType = .enabled}
    }
}

extension ToDoViewController: DoubleButtonDelegate {
    func tapEditButton() {
        DOOToast.show(message: "해당 기능은 추후 업데이트 예정이에요 :)", insetFromBottom: ScreenUtils.getHeight(107))
    }
    
    func tapDeleteButton() {
        self.navigationController?.popViewController(animated: false)
        DOOToast.show(message: "할일이 삭제되었어요.", insetFromBottom: ScreenUtils.getHeight(107))
    }
    
}

extension ToDoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {return CGSize()}

        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = ScreenUtils.getWidth(4)
//        layout.minimumLineSpacing = ScreenUtils.getWidth(4)
        
        let stringLength = data?.secret == true
        ? manager[indexPath.row].name.size(withAttributes: [NSAttributedString.Key.font : UIFont.pretendard(.detail2_regular)]).width + ScreenUtils.getWidth(12)
        : self.manager[indexPath.row].name.size(withAttributes: [NSAttributedString.Key.font : UIFont.pretendard(.detail2_regular)]).width
        return CGSize(width: stringLength + ScreenUtils.getWidth(12), height: ScreenUtils.getHeight(20))
    }
}
extension ToDoViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .serverError:
            DOOToast.show(message: "서버오류", insetFromBottom: 80)
        case .unAuthorizedError:
            DOOToast.show(message: "토큰만료, 재로그인필요", insetFromBottom: 80)
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .userState(let code, let message):
            DOOToast.show(message: "\(code) : \(message)", insetFromBottom: 80)
        default:
            DOOToast.show(message: error.description, insetFromBottom: 80)
        }
    }
}

extension ToDoViewController {
    
    
    func getDetailToDoData() {
        Task {
            do {
                let myDetailToDoData = try await ToDoService.shared.getDetailToDoData(todoId: 9)
                data = myDetailToDoData
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
                print("todo detail \(error)")
            }
        }
    }
}
