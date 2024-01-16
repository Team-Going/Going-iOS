//
//  MakeProfileViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/3/24.
//

import UIKit

import SnapKit

final class MakeProfileViewController: UIViewController {
    
    var socialToken: String?
    
    private var userProfileData = UserProfileAppData(name: "", intro: "", platform: "")
    
    private let nameLabel = DOOLabel(font: .pretendard(.body2_bold),
                                     color: .gray700,
                                     text: "이름")
    
    private lazy var navigationBar = DOONavigationBar(self, type: .titleLabelOnly("프로필 생성"))
    
    private let naviUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.setLeftPadding(amount: 12)
        textField.setPlaceholder(placeholder: "당신을 한줄로 표현해 보세요", fontColor: .gray200, font: .pretendard(.body3_medi))
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1
        textField.textColor = .gray700
        textField.font = .pretendard(.body3_medi)
        textField.layer.borderColor = UIColor.gray200.cgColor
        textField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let nameWarningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red400
        label.font = .pretendard(.detail2_regular)
        label.isHidden = true
        return label
    }()
    
    private var nameTextFieldCount: Int = 0
    
    private let nameTextFieldCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 3"
        label.font = .pretendard(.detail2_regular)
        label.textColor = .gray200
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "한 줄 소개"
        label.font = .pretendard(.body2_bold)
        label.textColor = .gray700
        return label
    }()
    
    private lazy var descTextField: UITextField = {
        let textField = UITextField()
        textField.setLeftPadding(amount: 12)
        textField.setPlaceholder(placeholder: "당신을 한줄로 표현해 보세요", fontColor: .gray200, font: .pretendard(.body3_medi))
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1
        textField.textColor = .gray700
        textField.font = .pretendard(.body3_medi)
        textField.layer.borderColor = UIColor.gray200.cgColor
        textField.addTarget(self, action: #selector(descTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private var descTextFieldCount: Int = 0
    
    private let descTextFieldCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 15"
        label.font = .pretendard(.detail2_regular)
        label.textColor = .gray200
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor.gray200, for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 6
        button.backgroundColor = .gray50
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        setDelegate()
        updateNextButtonState()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        setNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
    }
}

private extension MakeProfileViewController {
    func setHierarchy() {
        
        self.view.addSubviews(navigationBar,
                              naviUnderLineView,
                              nameLabel,
                              nameTextField,
                              nameTextFieldCountLabel,
                              nameWarningLabel,
                              descLabel,
                              descTextField,
                              descTextFieldCountLabel,
                              nextButton)
    }
    
    func setLayout() {
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.leading.trailing.equalToSuperview()
        }
        
        naviUnderLineView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(48))
        }
        
        nameTextFieldCountLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(nameTextField.snp.trailing).offset(-4)
        }
        
        nameWarningLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextFieldCountLabel.snp.top)
            $0.leading.equalTo(nameTextField.snp.leading).offset(4)
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(38)
            $0.leading.equalTo(nameLabel.snp.leading)
        }
        
        descTextField.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(48))
        }
        
        descTextFieldCountLabel.snp.makeConstraints {
            $0.top.equalTo(descTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(descTextField.snp.trailing).offset(-4)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
    }
    
    func setStyle() {
        self.view.backgroundColor = .white000
    }
    
    func setDelegate() {
        nameTextField.delegate = self
        descTextField.delegate = self
    }
    
    func updateNextButtonState() {
        // nameTextField와 descTextField의 텍스트가 비어 있지 않고 nameTextField가 빈칸처리 아닐 때, nextButton 활성화
        let isNameTextFieldEmpty = nameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty
        let isDescTextFieldEmpty = descTextField.text!.isEmpty
        
        nextButton.isEnabled = !isNameTextFieldEmpty && !isDescTextFieldEmpty
        if nextButton.isEnabled {
            nextButton.backgroundColor = .gray500
            nextButton.titleLabel?.font = .pretendard(.body1_bold)
            nextButton.setTitleColor(.white000, for: .normal)
        } else {
            nextButton.backgroundColor = .gray50
            nextButton.titleLabel?.font = .pretendard(.body1_bold)
            nextButton.setTitleColor(.white000, for: .normal)
            
        }
    }
    
    
    func nameTextFieldBlankCheck() {
        guard let textEmpty = nameTextField.text?.isEmpty else { return }
        if textEmpty {
            nameTextField.layer.borderColor = UIColor.gray200.cgColor
            self.nameTextFieldCountLabel.textColor = .gray200
            nameWarningLabel.isHidden = true
        } else if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? false {
            nameTextField.layer.borderColor = UIColor.red400.cgColor
            self.nameTextFieldCountLabel.textColor = .red400
            nameWarningLabel.text = "이름에는 공백만 입력할 수 없어요"
            nameWarningLabel.isHidden = false
        } else {
            nameTextField.layer.borderColor = UIColor.gray700.cgColor
            self.nameTextFieldCountLabel.textColor = .gray400
            nameWarningLabel.isHidden = true
        }
    }
    
    func descTextFieldBlankCheck() {
        guard let textEmpty = descTextField.text?.isEmpty else { return }
        if textEmpty {
            descTextField.layer.borderColor = UIColor.gray200.cgColor
            self.descTextFieldCountLabel.textColor = .gray200
        } else {
            descTextField.layer.borderColor = UIColor.gray700.cgColor
            self.descTextFieldCountLabel.textColor = .gray400
        }
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            // 키보드 높이
            let keyboardHeight = keyboardFrame.height
            
            // Bottom Safe Area 높이
            let safeAreaBottomInset = view.safeAreaInsets.bottom
            
            // createTravelButton을 키보드 높이만큼 위로 이동하는 애니메이션 설정
            UIView.animate(withDuration: 0.3) {
                self.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + safeAreaBottomInset)
            }
        }
    }
    
    /// 키보드에 따라 버튼 원래대로 움직이게 하는 메서드
    @objc
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.nextButton.transform = .identity
        }
    }
    
    @objc
    func nameTextFieldDidChange() {
        guard let text = nameTextField.text else { return }
        nameTextFieldCount = text.count
        nameTextFieldCountLabel.text = "\(nameTextFieldCount) / 3"
        nameTextFieldBlankCheck()
        updateNextButtonState()
    }
    
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func descTextFieldDidChange() {
        guard let text = descTextField.text else { return }
        descTextFieldCount = text.count
        descTextFieldCountLabel.text = "\(descTextFieldCount) / 15"
        descTextFieldBlankCheck()
        updateNextButtonState()
        
    }
    
    @objc
    func nextButtonTapped() {
                
        if let nameText = nameTextField.text {
            self.userProfileData.name = nameText
        }
        
        if let descText = descTextField.text {
            self.userProfileData.intro = descText
        }
        
        if UserDefaults.standard.bool(forKey: IsAppleLogined.isAppleLogin.rawValue) {
            self.userProfileData.platform = SocialPlatform.apple.rawValue
        } else {
            self.userProfileData.platform = SocialPlatform.kakao.rawValue
        }
        
        //회원가입API
        guard let token = self.socialToken else { return }
        let signUpBody = self.userProfileData.toDTOData()
        
        Task {
            do {
                let data = try await AuthService.shared.postSignUp(token: token, signUpBody: signUpBody)
                
                let nextVC = UserTestSplashViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
//        let nextVC = UserTestSplashViewController()
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension MakeProfileViewController: ViewControllerServiceable {
    //추후에 에러코드에 따른 토스트 메세지 구현해야됨
    func handleError(_ error: NetworkError) {
        switch error {
        case .serverError:
            DOOToast.show(message: "서버오류", insetFromBottom: 80)
        case .unAuthorizedError, .reIssueJWT:
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

extension MakeProfileViewController: UITextFieldDelegate {
    
    //TextField에 변경사항이 생기면, 화면의 TextField에 실제로 작성되기 전에 호출되는 함수
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        var maxLength = 0
        switch textField {
        case nameTextField:
            maxLength = 3
        case descTextField:
            maxLength = 15
        default:
            return false
        }
        
        //모든 예시는 NameTextField 기준으로 적음
        let oldText = textField.text ?? "" // 입력하기 전 textField에 표시되어있던 text 입니다.
        let addedText = string // 입력한 text 입니다.
        let newText = oldText + addedText // 입력하기 전 text와 입력한 후 text를 합칩니다.
        let newTextLength = newText.count // 합쳐진 text의 길이 입니다.
        
        if newTextLength <= maxLength {
            return true
        }
        
        
        //여기는 "곽성ㅈ" 처럼 3번째에 하나라도 뭔가 있으면 위의 If문을 무시하고 넘어온다.
        let lastWordOfOldText = String(oldText[oldText.index(before: oldText.endIndex)]) // 입력하기 전 text의 마지막 글자 입니다.
        let separatedCharacters = lastWordOfOldText.decomposedStringWithCanonicalMapping.unicodeScalars.map{ String($0) } // 입력하기 전 text의 마지막 글자를 자음과 모음으로 분리해줍니다.
        let separatedCharactersCount = separatedCharacters.count // 분리된 자음, 모음의 개수입니다.
        
        //입력되어 있는 마지막 글자의 자음 + 모음 개수가 1개이고, 새로 입력되는 글자가 자음이 아닐 경우 입력이 됨
        // ex)"곽성ㅈ" 에서 입력할 때!
        if separatedCharactersCount == 1 && !addedText.isConsonant {
            return true
        }
        
        //입력되어 있는 마지막 글자의 자음 + 모음 개수가 2개이고, 새로 입력되는 글자가 자음 혹은 모음일 경우 입력이 되도록 함
        // ex) "곽성주" 에서 입력할 때!
        if separatedCharactersCount == 2 {
            return true
        }
        
        //입력되어 있는 마지막 글자의 자음 + 모음 개수가 3개이고, 새로 입력되는 글자가 자음일 경우 입력이 되도록 함, 예를 들어 받침에 자음이 두개 들어가는 경우 밑에서 처리해줘야 됨
        // ex) "곽성준" 에서 입력할 때!
        if separatedCharactersCount == 3 && addedText.isConsonant {
            return true
        }
        return false
    }
    
    //TextField에 변경사항이 생기면, TextField에 작성된 후에 호출되는 메서드
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        var maxLength = 0
        switch textField {
        case nameTextField:
            maxLength = 3
        case descTextField:
            maxLength = 15
        default:
            return
        }
        
        if text.count > maxLength {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: maxLength - 1)
            let fixedText = String(text[startIndex...endIndex])
            textField.text = fixedText
            return
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            nameTextFieldBlankCheck()
        case descTextField:
            descTextFieldBlankCheck()
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            nameTextFieldBlankCheck()
        case descTextField:
            descTextFieldBlankCheck()
        default:
            return
        }
    }
    
    /// 엔터키 누르면 키보드 내리는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
