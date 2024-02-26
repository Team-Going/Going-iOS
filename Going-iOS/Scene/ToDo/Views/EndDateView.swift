//
//  EndDateView.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/24/24.
//

import UIKit

protocol EndDateViewDelegate: AnyObject {
    func presentToDatePicker()
}

class EndDateView: UIView {

    private let deadlineLabel = DOOLabel(
        font: .pretendard(.body2_bold),
        color: UIColor(resource: .gray700),
        text: StringLiterals.ToDo.deadline
    )
    
    lazy var deadlineTextfieldLabel: DOOLabel = {
        let label = DOOLabel(
            font: .pretendard(.body3_medi),
            color: UIColor(resource: .gray200),
            alignment: .left,
            padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        )
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectEndDate))
        label.backgroundColor = UIColor(resource: .white000)
        label.layer.borderColor = UIColor(resource: .gray200).cgColor
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
        return label
    }()
    
    lazy var dropdownButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.ToDo.disabledDropdown, for: .normal)
        btn.backgroundColor = UIColor(resource: .white000)
        btn.addTarget(self, action: #selector(selectEndDate), for: .touchUpInside)
        return btn
    }()
    
    
    weak var delegate: EndDateViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInquiryEndDateStyle() {
        deadlineTextfieldLabel.layer.borderColor = UIColor(resource: .gray700).cgColor
        deadlineTextfieldLabel.textColor = UIColor(resource: .gray700)
        dropdownButton.setImage(ImageLiterals.ToDo.enabledDropdown, for: .normal)
    }
    
    @objc
    func selectEndDate() {
        self.delegate?.presentToDatePicker()
    }
    
}

private extension EndDateView {
    
    func setHierarchy() {
        self.addSubviews(deadlineLabel, deadlineTextfieldLabel)
        deadlineTextfieldLabel.addSubview(dropdownButton)
    }
    
    func setLayout() {
        deadlineLabel.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(23))
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
    }
    
}
