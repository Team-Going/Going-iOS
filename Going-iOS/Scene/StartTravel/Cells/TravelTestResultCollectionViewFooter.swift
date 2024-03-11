//
//  TravelTestResultCollectionViewFooter.swift
//  Going-iOS
//
//  Created by 곽성준 on 3/12/24.
//

import UIKit

protocol TravelTestResultCollectionViewFooterProtocol: AnyObject {
    func retryTravelTestButton()
}
    
final class TravelTestResultCollectionViewFooter: UICollectionReusableView {
    
    static let identifier: String = "TravelTestResultCollectionViewFooter"
    
    weak var delegate: TravelTestResultCollectionViewFooterProtocol?

    lazy var retryTravelTestButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시 해볼래요", for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_regular)
        button.setTitleColor(UIColor(resource: .gray300), for: .normal)
        button.setUnderline()
        button.addTarget(self, action: #selector(retryTravelTestButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        self.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        self.addSubviews(retryTravelTestButton)
        
        retryTravelTestButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(15)
        }
    }
    
    @objc
    func retryTravelTestButtonTapped() {
        delegate?.retryTravelTestButton()
    }
}
