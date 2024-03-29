//
//  DashBoardCollectionViewCell.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/7/24.
//

import UIKit

final class DashBoardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var tripStatus: String = ""

    var travelDetailData: Trip? {
        didSet {
            guard let detailData = travelDetailData else { return }
            
            self.travelTitleLabel.text = detailData.title
            self.travelDateLabel.text = "\(detailData.startDate) - \(detailData.endDate)"
            self.travelStateLabel.text = detailData.travelStatus
            
            if self.tripStatus == "complete" {
                self.travelTitleLabel.textColor = UIColor(resource: .gray300)
                self.travelDateLabel.textColor = UIColor(resource: .gray200)
                self.calendarImageView.tintColor = UIColor(resource: .gray200)
                self.travelStateBackgroundView.backgroundColor = UIColor(resource: .gray100)
                self.travelStateLabel.textColor = UIColor(resource: .gray200)
           
            } else {
                if detailData.day <= 0 {
                    self.travelStateLabel.text = "여행 중"
                } else {
                    self.travelStateLabel.text = "D-\(detailData.day)"
                }
                self.travelTitleLabel.textColor = UIColor(resource: .gray700)
                self.travelDateLabel.textColor = UIColor(resource: .gray300)
                self.calendarImageView.tintColor = UIColor(resource: .gray300)
                self.travelStateBackgroundView.backgroundColor = UIColor(resource: .red100)
                self.travelStateLabel.textColor = UIColor(resource: .red500)
            }
        }
    }

    // MARK: - UI Components

    private let travelTitleLabel = DOOLabel(font: .pretendard(.body2_medi), color: UIColor(resource: .gray700))

    private let calendarImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(resource: .icCalendar)
        return img
    }()
    
    private let travelDateLabel = DOOLabel(font: .pretendard(.detail3_regular), color: UIColor(resource: .gray300))
    
    private let travelStateBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .red100)
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let travelStateLabel = DOOLabel(font: .pretendard(.detail2_bold), color: UIColor(resource: .red500))

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

private extension DashBoardCollectionViewCell {
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor(resource: .gray100).cgColor
        self.layer.borderWidth = 1
    }
    
    func setHierarchy() {
        self.addSubviews(travelTitleLabel,
                         calendarImageView,
                         travelDateLabel,
                         travelStateBackgroundView)
        travelStateBackgroundView.addSubview(travelStateLabel)
    }
    
    func setLayout() {
        travelTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(16))
        }
        
        calendarImageView.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(12))
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(16))
            $0.leading.equalTo(travelTitleLabel)
        }
        
        travelDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(calendarImageView)
            $0.leading.equalTo(calendarImageView.snp.trailing).offset(ScreenUtils.getWidth(4))
        }
        
        travelStateBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.width.equalTo(ScreenUtils.getWidth(58))
            $0.height.equalTo(ScreenUtils.getHeight(20))
        }
        
        travelStateLabel.snp.makeConstraints {
            $0.center.equalTo(travelStateBackgroundView)
        }
    }
}
