//
//  EmptyUserTestView.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/3/24.
//

import UIKit

import SnapKit

final class EmptyUserTestView: UIView {
    
    // MARK: - UI Properties
    
    private let emptyImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(resource: .imgTestEmpty)
        return img
    }()
    
    private let emptyDescLabel = DOOLabel(font: .pretendard(.body3_medi),
                                          color: .gray200,
                                          text: "여행 캐릭터 검사를 아직 진행하지 않았어요\n지금 바로 나를 대신 할 여행 캐릭터를 만나보세요!",
                                          numberOfLine: 2,
                                          alignment: .center)
    
    private lazy var doUserTestButton: DOOButton = {
        let btn = DOOButton(type: .enabled, title: "여행 캐릭터 검사하러 가기")
        btn.addTarget(self, action: #selector(doUserTestButtonTapped), for: .touchUpInside)
        return btn
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

private extension EmptyUserTestView {
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
    }
    
    func setHierarchy() {
        addSubviews(emptyImageView,
                    emptyDescLabel,
                    doUserTestButton)
    }
    
    func setLayout() {
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.equalToSuperview().inset(118)
            $0.width.equalTo(ScreenUtils.getWidth(124))
            $0.height.equalTo(ScreenUtils.getHeight(144))
        }
        
        emptyDescLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(54)
        }
        
        doUserTestButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - @objc methods
    
    @objc
    func doUserTestButtonTapped() {
        print("tapped")
    }
}
