//
//  UserTestResultScrollView.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/3/24.
//

import UIKit

import SnapKit

final class UserTestResultScrollView: UIScrollView {
    
    // MARK: - UI Properties
    
    private let contentView = UIView()
    
    let resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(resource: .white000)
        return imageView
    }()
    
    let myResultView: TestResultView = {
        let view = TestResultView()
        view.nameLabel.isHidden = true
        view.userTypeLabel.font = .pretendard(.body1_bold)
        view.userTypeLabel.textColor = UIColor(resource: .gray700)
        view.typeDescLabel.font = .pretendard(.detail3_regular)
        view.typeDescLabel.textColor = UIColor(resource: .gray300)
        return view
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

private extension UserTestResultScrollView {
    func setStyle() {
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor(resource: .white000)
    }
    
    func setHierarchy() {
        addSubview(contentView)
        
        contentView.addSubviews(resultImageView, myResultView)
    }
    
    func setLayout() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(self.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
        }
        
        resultImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(228)
            $0.width.equalTo(Constant.Screen.width)
        }
        
        myResultView.snp.makeConstraints {
            $0.top.equalTo(resultImageView.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
