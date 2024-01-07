//
//  DashBoardCollectionViewCell.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/7/24.
//

import UIKit

final class DashBoardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    var travelDetailData: TravelDetailStruct? {
        didSet {
            guard let detailData = travelDetailData else { return }
            
            self.travelTitleLabel.text = detailData.travelTitle
            self.travelDateLabel.text = "\(detailData.startDate) - \(detailData.endDate)"
            self.travelStateLabel.text = detailData.travelStatus
            
            if detailData.dueDate < 0 { // 완료된 여행
                self.travelTitleLabel.textColor = .gray300
                self.travelDateLabel.textColor = .gray200
                self.calendarImageView.tintColor = .gray200
                self.travelStateBackgroundView.backgroundColor = .gray100
                self.travelStateLabel.textColor = .gray200
            } else {
                self.travelTitleLabel.textColor = .gray700
                self.travelDateLabel.textColor = .gray300
                self.calendarImageView.tintColor = .gray300
                self.travelStateBackgroundView.backgroundColor = .red100
                self.travelStateLabel.textColor = .red500
            }
        }
    }

    // MARK: - UI Components

    private let travelTitleLabel = DOOLabel(font: .pretendard(.body2_medi), color: .gray700)

    private let calendarImageView: UIImageView = {
        let img = UIImageView()
        img.image = ImageLiterals.OurToDo.icCalendar
        return img
    }()
    
    private let travelDateLabel = DOOLabel(font: .pretendard(.detail3_regular), color: .gray300)
    
    private let travelStateBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .red100
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let travelStateLabel = DOOLabel(font: .pretendard(.detail2_bold), color: .red500)

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
        self.backgroundColor = .white000
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor.gray100.cgColor
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
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(37)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(12))
            $0.top.equalTo(travelTitleLabel.snp.bottom).offset(7)
            $0.leading.equalTo(travelTitleLabel)
        }
        
        travelDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(calendarImageView)
            $0.leading.equalTo(calendarImageView.snp.trailing).offset(4)
        }
        
        travelStateBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(ScreenUtils.getWidth(58))
            $0.height.equalTo(ScreenUtils.getHeight(20))
        }
        
        travelStateLabel.snp.makeConstraints {
            $0.center.equalTo(travelStateBackgroundView)
        }
    }
}
