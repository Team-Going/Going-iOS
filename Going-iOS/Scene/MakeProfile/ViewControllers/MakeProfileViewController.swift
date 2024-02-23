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
    
    private var userName: String?
    
    private var isNameTextFieldGood: Bool = false
    private var isDescTextFieldGood: Bool = false
    
    private var userProfileData = UserProfileAppData(name: "", intro: "", platform: "")
    
    private let nameLabel = DOOLabel(font: .pretendard(.body2_bold),
                                     color: .gray700,
                                     text: "닉네임")
    
    private lazy var navigationBar = DOONavigationBar(self, type: .titleLabelOnly("프로필 생성"))
    
    private let naviUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.setLeftPadding(amount: 12)
        textField.setPlaceholder(placeholder: "3글자 이내로 작성해 주세요", fontColor: .gray200, font: .pretendard(.body3_medi))
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
        label.text = "0/3"
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
        textField.setPlaceholder(placeholder: "여행을 떠나기 전 설레는 마음을 적어볼까요?", fontColor: .gray200, font: .pretendard(.body3_medi))
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
        label.text = "0/20"
        label.font = .pretendard(.detail2_regular)
        label.textColor = .gray200
        return label
    }()
    
    private let descWarningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red400
        label.font = .pretendard(.detail2_regular)
        label.isHidden = true
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
    
    private lazy var keyboardLayoutGuide = view.keyboardLayoutGuide
    
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
                              descWarningLabel,
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
        
        descWarningLabel.snp.makeConstraints {
            $0.top.equalTo(descTextFieldCountLabel.snp.top)
            $0.leading.equalTo(descTextField.snp.leading).offset(4)
        }
        
        nextButton.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-6)
        }
    }
    
    func setStyle() {
        self.view.backgroundColor = .white000
    }
    
    func setDelegate() {
        nameTextField.delegate = self
        descTextField.delegate = self
    }
    
    func nameTextFieldCheck() {
        guard let text = nameTextField.text else { return }

            if text.count > 3 {
                nameTextField.layer.borderColor = UIColor.red500.cgColor
                nameTextFieldCountLabel.textColor = .red500
                nameWarningLabel.text = "닉네임은 3자 이하여야 합니다"
                nameWarningLabel.isHidden = false
                self.isNameTextFieldGood = false

            } else if text.count == 0 {
                nameTextField.layer.borderColor = UIColor.gray200.cgColor
                nameTextFieldCountLabel.textColor = .gray200
                nameWarningLabel.isHidden = true
                self.isNameTextFieldGood = false

            } else if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.isNameTextFieldGood = false

                nameTextField.layer.borderColor = UIColor.red500.cgColor
                nameTextFieldCountLabel.textColor = .red500
                nameWarningLabel.text = "닉네임에는 공백만 입력할 수 없어요"
                nameWarningLabel.isHidden = false
            }  else {
                nameTextField.layer.borderColor = UIColor.gray700.cgColor
                nameTextFieldCountLabel.textColor = .gray700
                nameWarningLabel.isHidden = true
                self.isNameTextFieldGood = true
            }
        
        nameTextFieldCountLabel.text = "\(text.count) / 3"
            updateNextButtonState()
    }
    
    @objc
    func nameTextFieldDidChange() {
        nameTextFieldCheck()
    }
    
    @objc
    func descTextFieldDidChange() {
        descTextFieldCheck()
    }
    
    func descTextFieldCheck() {
        guard let text = descTextField.text else { return }
      
        descTextFieldCountLabel.text = "\(text.count) / 20"
     
        if text.count > 20 {
            descTextField.layer.borderColor = UIColor.red500.cgColor
            descTextFieldCountLabel.textColor = .red500
            descWarningLabel.text = "소개는 20자를 초과할 수 없어요"
            descWarningLabel.isHidden = false
            isDescTextFieldGood = false
        } else if text.count == 0 {
            descTextField.layer.borderColor = UIColor.gray200.cgColor
            descTextFieldCountLabel.textColor = .gray200
            descWarningLabel.isHidden = true
            isDescTextFieldGood = false
        } else {
            self.isDescTextFieldGood = true
            descTextField.layer.borderColor = UIColor.gray700.cgColor
            descTextFieldCountLabel.textColor = .gray400
            descWarningLabel.isHidden = true
        }
        
        updateNextButtonState()
    }

    
    func updateNextButtonState() {
        // nameTextField와 descTextField의 텍스트가 비어 있지 않고 nameTextField가 빈칸처리 아닐 때, nextButton 활성화
 
        if isNameTextFieldGood == true && isDescTextFieldGood == true/* && !isNameTextFieldEmpty &&  !isDescTextFieldEmpty && nameTextField.text!.count < 3*/ {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .gray500
            nextButton.titleLabel?.font = .pretendard(.body1_bold)
            nextButton.setTitleColor(.white000, for: .normal)
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .gray50
            nextButton.titleLabel?.font = .pretendard(.body1_bold)
            nextButton.setTitleColor(.white000, for: .normal)
        }
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
        self.userName = nameTextField.text
        
        
        Task {
            do {
                try await AuthService.shared.postSignUp(token: token, signUpBody: signUpBody)
                let nextVC = UserTestSplashViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
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
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameTextFieldCheck()
        descTextFieldCheck()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextFieldCheck()
        descTextFieldCheck()
    }
    
    /// 엔터키 누르면 키보드 내리는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
