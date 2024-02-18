//
//  DashBoardHeaderView.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/7/24.
//

import UIKit

final class DashBoardHeaderView: UIView {
        
    // MARK: - UI Properties
    
    let segmentedControl: UnderlineSegmentedControlView = {
        let segmentedControl = UnderlineSegmentedControlView(items: ["진행 중인 여행", "지나간 여행"])
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor(resource: .gray200),
            .font: UIFont.pretendard(.body2_bold)], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor(resource: .gray500),
            .font: UIFont.pretendard(.body2_bold)], for: .selected)
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let underlineView: UIView = UIView()

    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension DashBoardHeaderView {
    
    func setHierarchy() {
        self.addSubviews(underlineView, segmentedControl)
    }
    
    func setLayout() {
        underlineView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        segmentedControl.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(underlineView)
            $0.width.equalTo(ScreenUtils.getWidth(187))
            $0.height.equalTo(ScreenUtils.getHeight(49))
        }
    }
    
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
        underlineView.backgroundColor = UIColor(resource: .gray200)
        segmentedControl.setWidth(ScreenUtils.getWidth(375) / 2, forSegmentAt: 0)
        segmentedControl.setWidth(ScreenUtils.getWidth(375) / 2, forSegmentAt: 1)
    }
}
