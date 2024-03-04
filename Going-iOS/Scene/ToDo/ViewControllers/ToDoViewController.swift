import UIKit

import SnapKit

final class ToDoViewController: UIViewController {

    private lazy var navigationBarView = DOONavigationBar(self, type: .backButtonWithTitle(StringLiterals.ToDo.inquiryToDo), backgroundColor: UIColor(resource: .white000))

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
    
    private let buttonView: UIView = UIView()
    
    private lazy var doubleButtonView = DoubleButtonView()
    
    
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
            self.todoTextFieldView.navigationBarTitle = navigationBarTitle
        }
    }
    
    lazy var fromOurTodoParticipants: [Participant] = [] {
        didSet {
            self.todoManagerView.fromOurTodoParticipants = fromOurTodoParticipants
        }
    }
//    
//    lazy var allocator: [Allocators] = [] {
//        didSet {
//            self.todoManagerView.allocators = allocator
//        }
//    }
    
    var data: GetDetailToDoResponseStuct? {
        didSet {
            guard let data else {return}
            self.todoTextFieldView.todoTextfield.text = data.title
            self.endDateView.deadlineTextfieldLabel.text = data.endDate
            self.todoManagerView.isSecret = data.secret
            if data.secret == true {
                self.todoManagerView.allocators = [Allocators(name: "혼자할일", isOwner: true), Allocators.EmptyData]
            } else {
                self.todoManagerView.allocators = data.allocators
            }
            navigationBarView.titleLabel.text = StringLiterals.ToDo.inquiryToDo
            setDefaultValue = [data.title, data.endDate, self.todoManagerView.allocators, data.memo ?? ""]
            setInquiryStyle()
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
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierachy()
        setLayout()
        setDelegate()
        setStyle()
        setStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationBarView.backgroundColor = UIColor(resource: .gray50)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNaviTitle()
    }
    
    func setNaviTitle() {
        navigationBarView.titleLabel.text = StringLiterals.ToDo.inquiryToDo
        self.todoManagerView.navigationBarTitle = StringLiterals.ToDo.inquiry
        self.getDetailToDoDatas(todoId: self.todoId)
    }
    
    func setStatus() {
        self.todoTextFieldView.todoTextfield.isUserInteractionEnabled = false
        self.endDateView.deadlineTextfieldLabel.isUserInteractionEnabled = false
        self.todoManagerView.todoManagerCollectionView.isUserInteractionEnabled = false
        self.memoTextView.isUserInteractionEnabled = false
    }

}

// MARK: - Prviate Methods

private extension ToDoViewController {
    
    func setHierachy() {
        self.view.addSubviews(navigationBarView, underlineView, scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(todoTextFieldView,
                                endDateView,
                                todoManagerView,
                                memoTextView,
                                buttonView)
        buttonView.addSubview(doubleButtonView)
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
        
        buttonView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.bottom.equalToSuperview().inset(40)
        }
        
        doubleButtonView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
        
    func setStyle() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor(resource: .white000)
        navigationBarView.backgroundColor = UIColor(resource: .white000)
    }
    
    func setDelegate() {
        doubleButtonView.delegate = self
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

}


// MARK: - Extension

extension ToDoViewController: DoubleButtonDelegate {
    func tapEditButton() {
//        DOOToast.show(message: "해당 기능은 추후 업데이트 예정이에요 :)", insetFromBottom: ScreenUtils.getHeight(107))
        let activateToDoVC = ActivateToDoViewController()
        activateToDoVC.navigationBarTitle = StringLiterals.ToDo.edit
        activateToDoVC.beforeVC = self.beforeVC
        if let data = self.data {
            activateToDoVC.data = GetDetailToDoResponseStuct(title: data.title, endDate: data.endDate, allocators: data.allocators, memo: data.memo, secret: data.secret)
        }
        activateToDoVC.fromOurTodoParticipants = self.fromOurTodoParticipants
        self.navigationController?.pushViewController(activateToDoVC, animated: false)
        
    }
    
    func tapDeleteButton() {
        deleteTodo()
    }
}

extension ToDoViewController: ViewControllerServiceable {
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

extension ToDoViewController {
    func getDetailToDoDatas(todoId: Int) {
        Task {
            do {
                self.data = try await ToDoService.shared.getDetailToDoData(todoId: todoId)
                print("detail \(self.data)")
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
    
    func deleteTodo() {
        Task {
            do {
                try await ToDoService.shared.deleteTodo(todoId: self.todoId)
                self.navigationController?.popViewController(animated: true)
            }
            DOOToast.show(message: "할일을 삭제했어요", insetFromBottom: ScreenUtils.getHeight(106))
        }
    }
}
