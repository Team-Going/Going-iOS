//
//  DatePickerView.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/5/24.
//

import UIKit

import SnapKit

final class DatePickerView: UIView {
    
    // MARK: - Size
    
    let absoluteHeight = UIScreen.main.bounds.height
    
    // MARK: - UI Properties
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.isUserInteractionEnabled = true
        picker.locale = Locale(identifier: "ko-KR")
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        return picker
    }()
        
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setStyle()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension DatePickerView {
    
    func setStyle() {
        self.backgroundColor = .white000
    }
    
    func setHierachy() {
        addSubview(datePicker)
    }
    
    func setLayout() {
        datePicker.snp.makeConstraints {
            $0.height.equalTo(absoluteHeight / 812 * 159)
            $0.top.equalToSuperview().inset(37)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
