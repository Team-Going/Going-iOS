//
//  TravelTestResultView.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/10/24.
//

import UIKit

import SnapKit

protocol RetryTestResultViewDelegate: AnyObject {
    func retryTravelTestButton()
}

final class TravelTestResultView: UIView {
    
    // MARK: - Properties
        
    var beforVC: String = ""

    var participantId: Int = 0

    var styleResult: [Int] = [] {
        didSet {
            self.travelTestCollectionView.reloadData()
        }
    }
        
    weak var delegate: RetryTestResultViewDelegate?
    
    private let travelTestQuestionDummy = TravelTestQuestionStruct.travelTestDummy
    
    // MARK: - UI Properties
    
    private lazy var travelTestCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(resource: .white000)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

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
        registerCell()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TravelTestResultView {
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
    }
    
    func setHierarchy() {
        addSubviews(travelTestCollectionView, retryTravelTestButton)
    }
    
    func setLayout() {
        travelTestCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        retryTravelTestButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(ScreenUtils.getHeight(18))
            $0.width.equalTo(ScreenUtils.getWidth(66))
        }
    }

    func registerCell() {
        self.travelTestCollectionView.register(TravelTestCollectionViewCell.self,
                                               forCellWithReuseIdentifier: TravelTestCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        travelTestCollectionView.delegate = self
        travelTestCollectionView.dataSource = self
    }
    
    @objc
    func retryTravelTestButtonTapped() {
        delegate?.retryTravelTestButton()
    }
}

extension TravelTestResultView: UICollectionViewDelegate { }

extension TravelTestResultView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return travelTestQuestionDummy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = travelTestCollectionView.dequeueReusableCell(withReuseIdentifier: TravelTestCollectionViewCell.cellIdentifier, for: indexPath) as? TravelTestCollectionViewCell else { return UICollectionViewCell() }
        cell.travelTestData = travelTestQuestionDummy[indexPath.row]

        if beforVC == "MyTravelProfile" && !styleResult.isEmpty{
            cell.styleResult = styleResult[indexPath.row]
            cell.setButtonDisable()
        }
        
        return cell
    }
}

extension TravelTestResultView: UICollectionViewDelegateFlowLayout {
    /// minimun item spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    /// cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ScreenUtils.getWidth(327)
        let height = ScreenUtils.getHeight(133)
        return CGSize(width: width, height: height)
    }
    
    /// content margin
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
    }
}
