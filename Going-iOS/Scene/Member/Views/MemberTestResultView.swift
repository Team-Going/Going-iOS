//
//  MemberTestResultView.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/14/24.
//

import UIKit

import SnapKit

final class MemberTestResultView: UIView {
    
    private let resultStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .equalSpacing
        return stack
    }()
    private let progressView1 = MemberProgressView()
    private let progressView2 = MemberProgressView()
    private let progressView3 = MemberProgressView()
    private let progressView4 = MemberProgressView()
    private let progressView5 = MemberProgressView()
    
    private lazy var dividingLine1: UIImageView = { setLineImage() }()
    private lazy var dividingLine2: UIImageView = { setLineImage() }()
    private lazy var dividingLine3: UIImageView = { setLineImage() }()
    private lazy var dividingLine4: UIImageView = { setLineImage() }()
    
    
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

private extension MemberTestResultView {
    func setStyle() {
        self.backgroundColor = .white000
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor.gray200.cgColor
        self.layer.borderWidth = 1
    }
    
    func setHierarchy() {
        self.addSubview(resultStackView)
        resultStackView.addArrangedSubviews(progressView1, dividingLine1,
                                            progressView2, dividingLine2,
                                            progressView3, dividingLine3,
                                            progressView4, dividingLine4,
                                            progressView5)
    }
    
    func setLayout() {
        resultStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
        
        [progressView1, progressView2, progressView3, progressView4, progressView5].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(ScreenUtils.getWidth(291))
                $0.height.equalTo(ScreenUtils.getHeight(73))
            }
        }
    }
    
    func setLineImage() -> UIImageView {
        let view = UIImageView()
        view.image = ImageLiterals.TripFriends.ticketLine
        view.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(293))
            $0.height.equalTo(1)
        }
        return view
    }
}

