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
    
    private enum Size {
        static let textFieldHeight: CGFloat = 48 / 327
        static let nextButtonHeight: CGFloat = 50 / 327

    }

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = .pretendard(.body2_bold)
        label.textColor = .gray700
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.setLeftPadding(amount: 12)
        textField.setPlaceholder(placeholder: "이름을 입력해주세요", fontColor: .gray200, font: .pretendard(.body3_medi))
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1
        textField.textColor = .gray700
        textField.font = .pretendard(.body3_medi)
        textField.layer.borderColor = UIColor.gray200.cgColor
        return textField
    }()
    
    private var nameTextFieldCount: Int = 0
    
    private lazy var nameTextFieldCountLabel: UILabel = {
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
    
    private let descTextField: UITextField = {
        let textField = UITextField()
        textField.setLeftPadding(amount: 12)
        textField.setPlaceholder(placeholder: "당신을 한줄로 표현해보세요.", fontColor: .gray200, font: .pretendard(.body3_medi))
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1
        textField.textColor = .gray700
        textField.font = .pretendard(.body3_medi)
        textField.layer.borderColor = UIColor.gray200.cgColor
        return textField
    }()
    
    private var descTextFieldCount: Int = 0
    
    private lazy var descTextFieldCountLabel: UILabel = {
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
//        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 6
        button.backgroundColor = .gray50
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    private func setHierarchy() {
        
        self.view.addSubviews(nameLabel, nameTextField, nameTextFieldCountLabel, descLabel, descTextField, descTextFieldCountLabel, nextButton)
        
    }
    
    private func setLayout() {
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(nameTextField.snp.width).multipliedBy(Size.textFieldHeight)
        }
        
        nameTextFieldCountLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(nameTextField.snp.trailing).offset(-4)
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(38)
            $0.leading.equalTo(nameLabel.snp.leading)
        }
        
        descTextField.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(descTextField.snp.width).multipliedBy(Size.textFieldHeight)
        }
        
        descTextFieldCountLabel.snp.makeConstraints {
            $0.top.equalTo(descTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(descTextField.snp.trailing).offset(-4)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(nextButton.snp.width).multipliedBy(Size.nextButtonHeight)
        }
        
    }
    
    private func setStyle() {
        self.view.backgroundColor = .white
    }

}


