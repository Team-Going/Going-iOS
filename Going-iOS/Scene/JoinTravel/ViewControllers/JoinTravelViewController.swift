//
//  JoinTravelViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/5/24.
//

import UIKit

import SnapKit

final class JoinTravelViewController: UIViewController {
    
    // MARK: - Properties
    
    
    private var code: String = ""
    
    private var codeCheckData: JoiningSuccessAppData? {
        didSet {
            if codeCheckData == nil {
                codeTextField.layer.borderColor = UIColor.red500.cgColor
                warningLabel.isHidden = false
                characterCountLabel.textColor = .red500
            } else {
                let vc = JoiningSuccessViewController()
                vc.joinSuccessData = codeCheckData
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("여행 입장하기"))
    private let navigationUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let codeTitleLabel = DOOLabel(font: .pretendard(.body2_bold), color: .gray700, text: StringLiterals.JoinTravel.inviteCodeTitle)
    
    private let codeTextField: UITextField = {
        let field = UITextField()
        field.setLeftPadding(amount: 12)
        field.font = .pretendard(.body3_medi)
        field.setTextField(forPlaceholder: StringLiterals.JoinTravel.placeHolder, forBorderColor: .gray200, forCornerRadius: 6)
        field.setPlaceholderColor(.gray200)
        field.textColor = .gray700
        field.autocapitalizationType = .none
        return field
    }()
    
    private let characterCountLabel = DOOLabel(font: .pretendard(.detail2_regular), color: .gray200, text: "0/6")
    private let warningLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.detail2_regular), color: .red500, text:"잘못된 초대코드예요")
        label.isHidden = true
        return label
    }()
    
    private lazy var nextButton: DOOButton = {
        let btn = DOOButton(type: .unabled, title: "다음")
        btn.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        setDelegate()
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

// MARK: - Private Extension

private extension JoinTravelViewController {
    func setStyle() {
        view.backgroundColor = .white000
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         navigationUnderlineView,
                         codeTitleLabel,
                         codeTextField,
                         warningLabel,
                         characterCountLabel,
                         nextButton)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        navigationUnderlineView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        codeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        codeTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(codeTitleLabel.snp.bottom).offset(8)
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.height.equalTo(ScreenUtils.getHeight(48))
        }
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(codeTextField.snp.bottom).offset(4)
            $0.leading.equalTo(codeTextField.snp.leading).offset(4)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(codeTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(codeTextField.snp.trailing).offset(-4)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
    }
    
    func setDelegate() {
        codeTextField.delegate = self
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func updateNextButtonState() {
        let isCodeTextFieldIsFilled = codeTextField.text!.trimmingCharacters(in: .whitespaces).count == 6
        nextButton.currentType = (isCodeTextFieldIsFilled) ? .enabled : .unabled
    }
    
    // MARK: - @objc Methods
    
    /// 키보드에 따라 버튼 위로 움직이게 하는 메서드
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
    func nextButtonTapped() {
        guard let text = codeTextField.text else { return }
        self.code = text
        checkCode()
    }
}

extension JoinTravelViewController: UITextFieldDelegate {
    func  textField ( _  textField : UITextField, shouldChangeCharactersIn  range : NSRange , replacementString  string : String ) -> Bool {
        guard let text = textField.text else { return  false }
        
        let newLength = text.count + string.count - range.length
        let maxLength = 6
        
        if newLength == 0 {
            textField.layer.borderColor =  UIColor.gray200.cgColor
            characterCountLabel.textColor = .gray200
            characterCountLabel.text = "\(newLength)/" + "\(maxLength)"
            warningLabel.isHidden = true
        } else if newLength < maxLength + 1 {
            textField.layer.borderColor =  UIColor.gray700.cgColor
            characterCountLabel.textColor = .gray700
            characterCountLabel.text = "\(newLength)/" + "\(maxLength)"
            warningLabel.isHidden = true
        }
        return  !(newLength > maxLength)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateNextButtonState()
    }
}

extension JoinTravelViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .serverError:
            DOOToast.show(message: "서버오류", insetFromBottom: 80)
        case .unAuthorizedError, .reIssueJWT:
            DOOToast.show(message: "토큰만료, 재로그인필요", insetFromBottom: 80)
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .userState(let code, let message):
            if code == "e4043" {
                warningLabel.isHidden = false
                codeTextField.layer.borderColor = UIColor.red500.cgColor
                characterCountLabel.textColor = .red500
                
            } else {
                DOOToast.show(message: message, insetFromBottom: 80)
            }
        default:
            DOOToast.show(message: error.description, insetFromBottom: 80)
        }
    }
}

extension JoinTravelViewController {
    func checkCode() {
        Task {
            do {
                self.codeCheckData = try await TravelService.shared.postInviteCode(code: self.code)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}
