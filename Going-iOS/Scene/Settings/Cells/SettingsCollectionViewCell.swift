//
//  SettingsCollectionViewCell.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/9/24.
//

import UIKit

import SnapKit

final class SettingsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var settingsData: SettingsItem? {
        didSet {
            guard let data = settingsData else { return }
            self.titleLabel.text = data.title
            
            if data.title == "서비스 방침" {
                self.settingsIcon.isHidden = true
                self.versionInfoLabel.isHidden = false
            } else if data.title == "로그아웃" {
                self.settingsIcon.isHidden = true
                self.versionInfoLabel.isHidden = true
                self.titleLabel.textColor = .red500
            } 
        }
    }
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body1_medi)
        label.textColor = .gray700
        return label
    }()
    
    private let settingsIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = ImageLiterals.Settings.btnEnterLarge
        icon.isHidden = false
        return icon
    }()
    
    private let versionInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.detail1_regular)
        label.textColor = .gray300
        label.text = "v1.0"
        label.isHidden = true
        return label
    }()
    
    // MARK: - Life Cycle
    
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

// MARK: - Private Extension

private extension SettingsCollectionViewCell {
    func setStyle() {
        self.backgroundColor = .white000
        self.layer.cornerRadius = 6
    }
    
    func setHierarchy() {
        self.addSubviews(titleLabel, settingsIcon, versionInfoLabel)
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        settingsIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(ScreenUtils.getWidth(25))
        }
        
        versionInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
