//
//  TravelTestResultView.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/10/24.
//

import UIKit

import SnapKit

protocol TravelTestResultViewDelegate: AnyObject {
    func retryTravelTestButton()
    func userDidSelectAnswer()
}

final class TravelTestResultView: UIView {
    
    // MARK: - Properties
    
    var resultIntArray: [Int] = []
    
    weak var delegate: TravelTestResultViewDelegate?
    
    private let travelTestQuestionDummy = TravelTestQuestionStruct.travelTestDummy
    
    // MARK: - UI Properties
    
    lazy var travelTestCollectionView: UICollectionView = {
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
        cell.delegate = self
        cell.travelTestData = travelTestQuestionDummy[indexPath.row]

        // 여기서 유저의 이전 선택을 해당 셀에 반영
        if resultIntArray.count > 0 {
            let selectedAnswerIndex = resultIntArray[indexPath.row] // 유저가 선택한 인덱스
            cell.configureButtonColors(with: selectedAnswerIndex)
        }

        return cell
    }
}

extension TravelTestResultView: TravelTestCollectionViewCellDelegate {
    func didSelectAnswer(in cell: TravelTestCollectionViewCell, selectedAnswer: Int) {
        guard let indexPath = travelTestCollectionView.indexPath(for: cell) else { return }
        resultIntArray[indexPath.row] = selectedAnswer - 1 // 유저의 새로운 선택으로 업데이트

        delegate?.userDidSelectAnswer()
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
