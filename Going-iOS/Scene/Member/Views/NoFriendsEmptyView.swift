//
//  NoFriendsEmptyView.swift
//  Going-iOS
//
//  Created by 곽성준 on 3/12/24.
//

import UIKit

protocol NoFriendsEmptyViewProtocol: AnyObject {
    func inviteFriendButtonTapped()
}

final class NoFriendsEmptyView: UIView {
    
    weak var delegate: NoFriendsEmptyViewProtocol?
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .noFriendsEmpty)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let emptyLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.body3_medi),
                             color: UIColor(resource: .gray200),
                             text: "아직 함께하는 친구들이 없어요! \n친구를 초대하고 함께 여행 취향을 알아보세요" ,
                             numberOfLine: 2,
                             alignment: .center)
        return label
    }()
    
    private lazy var inviteFriendButton: DOOButton = {
        let button = DOOButton(type: .enabled, title: "여행 친구 초대하기")
        button.addTarget(self, action: #selector(inviteFriendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func inviteFriendButtonTapped() {
        delegate?.inviteFriendButtonTapped()
    }
}

private extension NoFriendsEmptyView {
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
    }
    
    func setHierarchy() {
        self.addSubviews(emptyImageView,
                         emptyLabel,
                         inviteFriendButton)
    }
    
    func setLayout() {
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(166)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(218))
            $0.height.equalTo(ScreenUtils.getHeight(139))
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        inviteFriendButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-6)
            $0.width.equalTo(UIScreen.main.bounds.width - 48)
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.centerX.equalToSuperview()
        }
    }
}
