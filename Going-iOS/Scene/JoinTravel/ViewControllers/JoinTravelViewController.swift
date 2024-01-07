//
//  JoinTravelViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/5/24.
//

import UIKit

import SnapKit

final class JoinTravelViewController: UIViewController {
    
    // TODO: - Dummy Data 생성
    
    // MARK: - UI Properties
    
    private let navigationBar: NavigationView = {
        let nav = NavigationView()
        nav.titleLabel.text = "여행 입장하기"
        return nav
    }()

    private let codeTitleLabel = DOOLabel(font: .pretendard(.body2_bold), color: .gray700, text: StringLiterals.JoinTravel.inviteCodeTitle)
    
    private let codeTextField: UITextField = {
        let field = UITextField()
        field.setLeftPadding(amount: 12)
        field.font = .pretendard(.body3_medi)
        field.setTextField(forPlaceholder: StringLiterals.JoinTravel.placeHolder, forBorderColor: .gray200, forCornerRadius: 6)
        field.keyboardType = .numberPad
        return field
    }()
    
    private let characterCountLabel = DOOLabel(font: .pretendard(.detail2_regular), color: .gray200, text: "0/6")
    
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
        setNotification()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
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
        let vc = JoiningSuccessViewController()
        navigationController?.pushViewController(vc, animated: true)
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
                         codeTitleLabel,
                         codeTextField,
                         characterCountLabel,
                         nextButton)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
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
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(codeTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(codeTextField.snp.trailing).offset(4)
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
        let isCodeTextFieldEmpty = codeTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty
        nextButton.currentType = (!isCodeTextFieldEmpty) ? .enabled : .unabled
    }
}

extension JoinTravelViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == codeTextField {
            /// 현재 텍스트 필드의 텍스트와 입력된 문자를 합쳐서 길이를 계산
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let maxLength = 6
            characterCountLabel.text = "\(newText.count)/\(maxLength)"
            
            if newText.count >= 1 {
                textField.layer.borderColor = UIColor.gray700.cgColor
                characterCountLabel.textColor = .gray400
                updateNextButtonState()
            } else {
                textField.layer.borderColor = UIColor.gray200.cgColor
            }
            
            // 최대 길이를 초과하면 입력을 막음
            return newText.count <= maxLength
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == codeTextField {
            updateNextButtonState()
        }
    }
}
