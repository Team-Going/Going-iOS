//
//  TravelNameView.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/1/24.
//

import UIKit

import SnapKit

final class TravelNameView: UIView {
        
    // MARK: - UI Properties
    
    private let travelNameLabel = DOOLabel(font: .pretendard(.body2_bold),
                                           color: UIColor(resource: .gray700),
                                           text: StringLiterals.CreateTravel.nameTitle)
    
    lazy var travelNameTextField: UITextField = {
        let field = UITextField()
        if let clearButton = field.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(resource: .btnDelete), for: .normal)
        }
        field.setLeftPadding(amount: 12)
        field.font = .pretendard(.body3_medi)
        field.setTextField(forPlaceholder: StringLiterals.CreateTravel.namePlaceHolder, forBorderColor: UIColor(resource: .gray200))
        field.setPlaceholderColor(UIColor(resource: .gray200))
        field.layer.cornerRadius = 6
        field.textColor = UIColor(resource: .gray700)
        field.clearButtonMode = UITextField.ViewMode.whileEditing
        return field
    }()
    
    let characterCountLabel = DOOLabel(font: .pretendard(.detail2_regular),
                                               color: UIColor(resource: .gray200),
                                               text: "0/15")
    
    let warningLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.body3_medi), color: UIColor(resource: .red500))
        label.isHidden = true
        return label
    }()
    
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension TravelNameView {
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
    }
    
    func setHierarchy() {
        addSubviews(travelNameLabel,
                    travelNameTextField,
                    characterCountLabel,
                    warningLabel)
    }
    
    func setLayout() {
        travelNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        travelNameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(travelNameLabel.snp.bottom).offset(8)
            $0.width.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(48))
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(travelNameTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(travelNameTextField.snp.trailing).offset(4)
        }
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(travelNameTextField.snp.bottom).offset(4)
            $0.leading.equalTo(travelNameTextField.snp.leading).offset(4)
        }
    }
}
