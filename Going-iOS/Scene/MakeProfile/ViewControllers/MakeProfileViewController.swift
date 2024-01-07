//
//  MakeProfileViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/3/24.
//

import UIKit

import SnapKit

//나중에 서버한테 넘겨줄 때
struct UserProfileData {
    var name: String
    var description: String
}

final class MakeProfileViewController: UIViewController {
    
    private let nameLabel = DOOLabel(font: .pretendard(.body2_bold), 
                                     color: .gray700,
                                     text: "이름")
  
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.setLeftPadding(amount: 12)
        textField.setPlaceholder(placeholder: "이름을 입력해주세요", fontColor: .gray200, font: .pretendard(.body3_medi))
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1
        textField.setPlaceholderColor(.gray700)
        textField.textColor = .gray700
        textField.font = .pretendard(.body3_medi)
        textField.layer.borderColor = UIColor.gray200.cgColor
        textField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let nameWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "이름을 입력해주세요"
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
        textField.setPlaceholder(placeholder: "당신을 한줄로 표현해보세요.", fontColor: .gray200, font: .pretendard(.body3_medi))
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
        button.setTitle("유형 검사 하러가기", for: .normal)
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
    
    @objc
    private func nameTextFieldDidChange() {
        guard let text = nameTextField.text else { return }
        nameTextFieldCount = text.count
        nameTextFieldCountLabel.text = "\(nameTextFieldCount) / 3"
        nameTextFieldBlankCheck()
        updateNextButtonState()
        
    }
    
    @objc
    private func descTextFieldDidChange() {
        guard let text = descTextField.text else { return }
        descTextFieldCount = text.count
        descTextFieldCountLabel.text = "\(descTextFieldCount) / 15"
        updateNextButtonState()
        
    }
    
    @objc
    private func nextButtonTapped() {
        
        //구조체에 넣어서 서버에 넘겨주기
        var userData = UserProfileData(name: "", description: "")
        
        if let nameText = nameTextField.text {
            userData.name = nameText
        }
        
        if let descText = descTextField.text {
            userData.description = descText
        }
        
        // userData를 출력 또는 다음 단계로 전달하는 등의 동작 수행
        print(userData.name)
        print(userData.description)
        //        let nextVC = LoginViewController()
        //        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
}

private extension MakeProfileViewController {
    func setHierarchy() {
        
        self.view.addSubviews(nameLabel,
                              nameTextField,
                              nameTextFieldCountLabel,
                              nameWarningLabel,
                              descLabel,
                              descTextField,
                              descTextFieldCountLabel,
                              nextButton)
    }
    
    func setLayout() {
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
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
            nextButton.titleLabel?.textColor = .white000
        } else {
            nextButton.backgroundColor = .gray50
            nextButton.titleLabel?.font = .pretendard(.body1_bold)
            nextButton.titleLabel?.textColor = .gray200
        }
    }
    
    
    func nameTextFieldBlankCheck() {
        guard let textEmpty = nameTextField.text?.isEmpty else { return }
        if textEmpty {
            nameTextField.layer.borderColor = UIColor.gray700.cgColor
            self.nameTextFieldCountLabel.textColor = .gray400
            nameWarningLabel.isHidden = true
        } else if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? false {
            nameTextField.layer.borderColor = UIColor.red400.cgColor
            self.nameTextFieldCountLabel.textColor = .red400
            nameWarningLabel.isHidden = false
        } else {
            nameTextField.layer.borderColor = UIColor.gray700.cgColor
            self.nameTextFieldCountLabel.textColor = .gray400
            nameWarningLabel.isHidden = true
        }
    }
}

extension MakeProfileViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 백스페이스 처리
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        switch textField {
        case nameTextField:
            guard textField.text!.count < 3 else { return false }
            
        case descTextField:
            guard textField.text!.count < 15 else { return false }
            
        default:
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            nameTextFieldBlankCheck()
            
        case descTextField:
            textField.layer.borderColor = UIColor.gray700.cgColor
            self.descTextFieldCountLabel.textColor = .gray400
            
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case nameTextField:
            nameTextFieldBlankCheck()
            if let text = textField.text, text.isEmpty {
                textField.layer.borderColor = UIColor.gray200.cgColor
            }
            
        case descTextField:
            if descTextField.isEmpty {
                descTextField.layer.borderColor = UIColor.gray200.cgColor
                descTextFieldCountLabel.textColor = .gray200
            } else {
                textField.layer.borderColor = UIColor.gray700.cgColor
                descTextFieldCountLabel.textColor = .gray400
            }
            
        default:
            return
        }
        
    }
}


