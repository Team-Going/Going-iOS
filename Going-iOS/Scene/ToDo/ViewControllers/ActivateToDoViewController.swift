//
//  ActivateToDoViewController.swift
//  Going-iOS
//
//  Created by 윤희슬 on 2/28/24.
//

import UIKit

final class ActivateToDoViewController: UIViewController {

    private lazy var navigationBarView = DOONavigationBar(self, 
                                                          type: .rightItemWithTitle(StringLiterals.ToDo.edit),
                                                          backgroundColor: UIColor(resource: .white000))

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .gray100)
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(resource: .white000)
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .white000)
        return view
    }()
    
    private let todoTextFieldView = ToDoTextFieldView()
    
    private let endDateView = EndDateView()
    
    private let bottomSheetVC = DatePickerBottomSheetViewController()
    
    private let todoManagerView = ToDoManagerView()
    
    private let memoTextView = MemoTextView()
    
    
    // MARK: - Properties
    
    //데이트피커에서 받은 데이트
    var selectedDate: Date?
    
    // MARK: - Network
    
    var tripId: Int = 0
    
    var myId: Int = 0
    
    private var toDorequestData = CreateToDoRequestStruct(title: "", endDate: "", allocators: [], memo: "", secret: false)
    
    private var saveToDoData: CreateToDoRequestStruct = .init(title: "", endDate: "", allocators: [], memo: "", secret: false)

    
    // MARK: - UI Components
    
    var todoId: Int = 0
    
    var idSet: [Int] = []
    
    var buttonIndex: [Int] = []
    
    lazy var beforeVC: String = "" {
        didSet {
            self.todoManagerView.beforeVC = beforeVC
            if navigationBarTitle == "추가" && beforeVC == "my" {
                self.todoManagerView.allocators = [.init(name: "혼자할일", isOwner: true)]
            }
        }
    }
    
    lazy var navigationBarTitle: String = "" {
        didSet {
            self.todoManagerView.navigationBarTitle = navigationBarTitle
        }
    }
    
    lazy var fromOurTodoParticipants: [Participant] = [] {
        didSet {
            self.todoManagerView.fromOurTodoParticipants = fromOurTodoParticipants
        }
    }
    
    lazy var manager: [Allocators] = [] {
        didSet {
            self.todoManagerView.allocators = manager
        }
    }
    
    var data: GetDetailToDoResponseStuct? {
        didSet {
            guard let data else {return}
            print("data \(data)")
            self.todoTextFieldView.todoTextfield.text = data.title
            self.endDateView.deadlineTextfieldLabel.text = data.endDate
            self.todoManagerView.allocators = data.allocators
            self.todoManagerView.isSecret = data.secret
            if data.secret == true {
                self.todoManagerView.allocators[0].name = "혼자할일"
                self.todoManagerView.allocators.append(Allocators.EmptyData)
            }
            if navigationBarTitle == StringLiterals.ToDo.edit {
                setInquiryStyle()
            }
            self.memoTextView.memoTextView.text = data.memo
            
            self.todoManagerView.todoManagerCollectionView.reloadData()
        }
    }
    
    var setDefaultValue: [Any]? {
        didSet {
            guard let value = setDefaultValue else {return}
            self.todoTextFieldView.todoTextfieldPlaceholder = value[0] as? String ?? ""
            self.todoTextFieldView.todoTextfield.placeholder = value[0] as? String ?? ""
            self.endDateView.deadlineTextfieldLabel.text = value[1] as? String
            self.todoManagerView.allocators = value[2] as? [Allocators] ?? []
            self.memoTextView.memoTextviewPlaceholder = value[3] as? String ?? ""
            self.memoTextView.memoTextView.text = value[3] as? String ?? ""
        }
    }
    
    var isActivateView: Bool? = false {
        didSet {
            guard let isActivateView else {return}
//            self.todoManagerView.isActivateView = isActivateView
            if self.navigationBarTitle == StringLiterals.ToDo.edit {
                self.todoManagerView.navigationBarTitle = StringLiterals.ToDo.edit
            } else {
                self.todoManagerView.navigationBarTitle = StringLiterals.ToDo.add
            }
            self.todoTextFieldView.todoTextfield.isUserInteractionEnabled = isActivateView ? true : false
            self.endDateView.deadlineTextfieldLabel.isUserInteractionEnabled = isActivateView ? true : false
            self.todoManagerView.todoManagerCollectionView.isUserInteractionEnabled = isActivateView ? true : false
            self.memoTextView.isUserInteractionEnabled = isActivateView ? true : false
        }
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierachy()
        setLayout()
        setDelegate()
        setStyle()
        setInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNaviTitle()
        addNotification()
    }
    
    func setInfo() {
        if navigationBarTitle == "추가" {
            navigationBarView.titleLabel.text = "할일 추가"
            setDefaultValue = ["할일을 입력해 주세요", "날짜를 선택해 주세요", self.todoManagerView.allocators, "메모를 입력해 주세요"]
        }

    }
    
    func setNaviTitle() {
        switch navigationBarTitle {
        case "수정":
            navigationBarView.titleLabel.text = "할일 수정"
            self.tabBarController?.tabBar.isHidden = true
        default:
            return
        }
    }
    
    // 키보드 관련 알림 등록
    func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // 키보드 관련 알림 등록
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    // MARK: - @objc Methods
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        if self.memoTextView.memoTextView.isFirstResponder {
            // memoTextView가 FirstResponder인 경우 contentInset을 조절
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height - ScreenUtils.getHeight(60), right: 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset

            let rect = self.memoTextView.convert(self.memoTextView.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // 컴포넌트의 Auto Layout 초기 상태로 복원
        // 키보드가 사라질 때 scrollView의 contentInset 초기화
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        // 화면을 탭하면 키보드가 닫히도록 함
        view.endEditing(true)
    }
        
    @objc
    func todoTextFieldDidChange() {
        guard let text = self.todoTextFieldView.todoTextfield.text else { return }
        self.todoTextFieldView.todoTextFieldCount = text.count
        self.todoTextFieldView.countToDoCharacterLabel.text = "\(self.todoTextFieldView.todoTextFieldCount)/15"
        self.todoTextFieldView.todoTextFieldCheck()
        updateSaveButtonState()
    }
}

// MARK: - Prviate Methods

private extension ActivateToDoViewController {
    
    func setHierachy() {
        self.view.addSubviews(navigationBarView, underlineView, scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(todoTextFieldView,
                                endDateView,
                                todoManagerView,
                                memoTextView)
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
        
        scrollView.snp.makeConstraints{
            $0.top.equalTo(underlineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints{
            $0.top.equalTo(scrollView)
            $0.width.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(scrollView.snp.height).priority(.low)
        }

        todoTextFieldView.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(ScreenUtils.getHeight(40))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.height.equalTo(ScreenUtils.getHeight(101))
        }
        
        endDateView.snp.makeConstraints {
            $0.top.equalTo(todoTextFieldView.snp.bottom).offset(ScreenUtils.getHeight(16))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.height.equalTo(ScreenUtils.getHeight(79))
        }
        
        todoManagerView.snp.makeConstraints {
            $0.top.equalTo(endDateView.snp.bottom).offset(ScreenUtils.getHeight(38))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.height.equalTo(ScreenUtils.getHeight(55))
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(todoManagerView.snp.bottom).offset(ScreenUtils.getHeight(38))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.height.equalTo(ScreenUtils.getHeight(192))
        }

    }
        
    func setStyle() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor(resource: .white000)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)

        navigationBarView.backgroundColor = UIColor(resource: .white000)
    }
    
    func setDelegate() {
        todoTextFieldView.delegate = self
        endDateView.delegate = self
        todoManagerView.delegate = self
        memoTextView.delegate = self
        bottomSheetVC.delegate = self
    }
    
    // 조회 뷰 스타일 세팅 메서드
    func setInquiryStyle() {
        self.todoTextFieldView.setInquiryTextFieldStyle()
        self.endDateView.setInquiryEndDateStyle()
        self.memoTextView.setInquiryMemoStyle()
    }
    
    /// 텍스트 필드에 들어갈 텍스트를 DateFormatter로  변환하는 메서드
    func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter.string(from: date)
    }
    
    /// DatePicker Presnet 하는 메서드
    func showDatePicker() {
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }

    func compareDate(userDate: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 32400)
        
        //유저가 입력한 날짜를 스트링으로 바꿈
        let formattedDateString = dateFormatter.string(from: userDate)
        self.endDateView.deadlineTextfieldLabel.text = formattedDateString
        
        //유저가 선택한 날짜
        let userPickedDate = userDate
        
        //유저의 위치 날짜
        let today = Date()
        
        // 정확한 비교를 위해 시-분-초 절삭한 시간대
        let calendar = Calendar.current
        let deletedUser = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: userPickedDate)
        let deletedToday = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: today)
        
        // 두 날짜 비교
        if let deletedUser = deletedUser, let deletedToday = deletedToday, deletedUser < deletedToday {
            return false
        } else {
            return true
        }
    }

    func updateSaveButtonState() {
        let isAllocatorFilled = ((beforeVC == "our") && (buttonIndex.isEmpty == false)) || (beforeVC == "my")
        let isTodoTextFieldEmpty = self.todoTextFieldView.todoTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isDateSet = self.endDateView.deadlineTextfieldLabel.text != "날짜를 선택해 주세요"
        
        if !isTodoTextFieldEmpty 
            && self.todoTextFieldView.todoTextfield.text?.count ?? 0 <= 15
            && isDateSet
            && isAllocatorFilled
            && self.memoTextView.memoTextView.text.count <= 1000 {
            self.navigationBarView.saveTextButton.setTitleColor(.gray200, for: .normal)
            self.navigationBarView.saveTextButton.isEnabled = true
        } else {
            self.navigationBarView.saveTextButton.setTitleColor(.red500, for: .normal)
            self.navigationBarView.saveTextButton.isEnabled = false
        }
    }
}


// MARK: - Extension

extension ActivateToDoViewController: ToDoTextFieldDelegate {
    func checkTextFieldState() {
        self.updateSaveButtonState()
    }
}

extension ActivateToDoViewController: EndDateViewDelegate {
    func presentToDatePicker() {
        showDatePicker()
        self.endDateView.dropdownButton.setImage(UIImage(resource: .tapIcDropdown), for: .normal)
    }
}

extension ActivateToDoViewController: ToDoManagerViewDelegate {
    func tapToDoManagerButton(_ sender: UIButton) {
        self.todoManagerView.changeButtonConfig(isSelected: sender.isSelected, btn: sender)
        
        // 아워투두의 할일 추가의 경우
        
        if beforeVC == "our" {
            if sender.isSelected {
                buttonIndex.removeAll(where: { $0 == sender.tag })
            } else {
                buttonIndex.append(sender.tag)
            }
        }
        updateSaveButtonState()
        sender.isSelected = !sender.isSelected
    }
}

extension ActivateToDoViewController: MemoTextViewDelegate {
    func checkMemoState() {
        self.updateSaveButtonState()
    }
}

extension ActivateToDoViewController: BottomSheetDelegate {
    
    func datePickerDidChanged(date: Date) { return }
    
    func didSelectDate(date: Date) {
        self.selectedDate = date
        
        let formattedDate = dateFormat(date: date)

        self.endDateView.deadlineTextfieldLabel.text = formattedDate
        self.endDateView.deadlineTextfieldLabel.textColor = UIColor(resource: .gray700)
        self.endDateView.deadlineTextfieldLabel.layer.borderColor = UIColor(resource: .gray700).cgColor
        self.endDateView.dropdownButton.setImage(UIImage(resource: .enabledIcDropdown), for: .normal)
        
        if compareDate(userDate: date) {
            updateSaveButtonState()
        }
    }
}

extension ActivateToDoViewController: DOONavigationBarDelegate {

    // 저장 버튼 탭 시 데이터를 배열에 담아주고 메인 뷰로 돌아가는 메서드

    func saveTextButtonTapped() {
        let todo = self.todoTextFieldView.todoTextfield.text ?? ""
        let deadline = (self.endDateView.deadlineTextfieldLabel.text == "날짜를 선택해 주세요" ? "" : self.endDateView.deadlineTextfieldLabel.text) ?? ""
        let memo = (self.memoTextView.memoTextView.text == self.memoTextView.memoTextviewPlaceholder ? "" : self.memoTextView.memoTextView.text) ?? ""
        let secret = beforeVC == "our" ? false : true
        if !todo.isEmpty && !deadline.isEmpty {
            if !buttonIndex.isEmpty {
                for i in buttonIndex {
                    idSet.append(self.todoManagerView.fromOurTodoParticipants[i].participantId)
                }
            }
            if beforeVC == "my" {
                idSet = [myId]
            } else {
                
            }
            
            self.saveToDoData = CreateToDoRequestStruct(title: todo, endDate: deadline, allocators: idSet, memo: memo, secret: secret)
            print(self.saveToDoData)
            
            if navigationBarTitle == "할일 추가" {
                postToDoData()
            } else {
                //수정 서버 통신
            }
        }
    }
    
    
}

extension ActivateToDoViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .serverError:
            DOOToast.show(message: "서버오류", insetFromBottom: ScreenUtils.getHeight(80))
        case .unAuthorizedError, .reIssueJWT:
            DOOToast.show(message: "토큰만료, 재로그인필요", insetFromBottom: ScreenUtils.getHeight(80))
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .userState(let code, let message):
            DOOToast.show(message: "\(code) : \(message)", insetFromBottom: ScreenUtils.getHeight(80))
        default:
            DOOToast.show(message: error.description, insetFromBottom: ScreenUtils.getHeight(80))
        }
    }
}

extension ActivateToDoViewController {
    func getDetailToDoDatas(todoId: Int) {
        Task {
            do {
                self.data = try await ToDoService.shared.getDetailToDoData(todoId: todoId)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
    
    func postToDoData() {
        Task {
            do {
                try await ToDoService.shared.postCreateToDo(tripId: tripId, requestBody: saveToDoData)
                self.navigationController?.popViewController(animated: true)
            }
            DOOToast.show(message: "할일을 추가했어요", insetFromBottom: ScreenUtils.getHeight(106))
        }
    }

}

