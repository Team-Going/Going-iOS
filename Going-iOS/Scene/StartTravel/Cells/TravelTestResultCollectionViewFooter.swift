//
//  TravelTestResultCollectionViewFooter.swift
//  Going-iOS
//
//  Created by 곽성준 on 3/12/24.
//

import UIKit

// MARK: - Protocol

protocol TravelTestResultCollectionViewFooterProtocol: AnyObject {
    func retryTravelTestButton()
}
    
final class TravelTestResultCollectionViewFooter: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier: String = "TravelTestResultCollectionViewFooter"
    
    weak var delegate: TravelTestResultCollectionViewFooterProtocol?
    
    // MARK: - UI Properties
    
    lazy var retryTravelTestButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시 해볼래요", for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_regular)
        button.setTitleColor(UIColor(resource: .gray300), for: .normal)
        button.setUnderline()
        button.addTarget(self, action: #selector(retryTravelTestButtonTapped), for: .touchUpInside)
        return button
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

// MARK: - Private Extensions

private extension TravelTestResultCollectionViewFooter {
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
    }
    
    func setHierarchy() {
        self.addSubview(retryTravelTestButton)
    }
    
    func setLayout() {
        retryTravelTestButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(15)
        }
    }
    
    // MARK: - @objc methods
    
    @objc
    func retryTravelTestButtonTapped() {
        delegate?.retryTravelTestButton()
    }
}
