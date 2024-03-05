//
//  TravelDateView.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/1/24.
//

import UIKit

import SnapKit

final class TravelDateView: UIView {
    
    // MARK: - UI Properties
    
    private let travelDateLabel = DOOLabel(font: .pretendard(.body2_bold),
                                           color: UIColor(resource: .gray700),
                                           text: StringLiterals.CreateTravel.dateTitle)
    
    private let dateHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 6
        return stack
    }()
    
    let startDateLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.body3_medi),
                             color: UIColor(resource: .gray200),
                             text: "시작일",
                             padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0))
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(resource: .gray200).cgColor
        return label
    }()
    
    let endDateLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.body3_medi),
                             color: UIColor(resource: .gray200),
                             text: "종료일",
                             padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0))
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(resource: .gray200).cgColor
        return label
    }()
    
    private let dashLabel = DOOLabel(font: .pretendard(.detail2_regular),
                                     color: UIColor(resource: .gray700),
                                     text: "-")
    
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

private extension TravelDateView {
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
    }
    
    func setHierarchy() {
        addSubviews(travelDateLabel,
                    dateHorizontalStackView)
        
        dateHorizontalStackView.addArrangedSubviews(startDateLabel, 
                                                    dashLabel,
                                                    endDateLabel)
    }
    
    func setLayout() {
        travelDateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        dateHorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(travelDateLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        
        startDateLabel.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.width.equalTo(ScreenUtils.getWidth(154))
        }
        
        endDateLabel.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(48))
            $0.width.equalTo(ScreenUtils.getWidth(154))
        }
    }
}
