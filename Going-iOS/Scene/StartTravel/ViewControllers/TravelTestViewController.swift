//
//  TravelTestViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/6/24.
//

import UIKit

import SnapKit

final class TravelTestViewController: UIViewController {
    
    // MARK: - Properties
    
    private let travelTestDummy = TravelTestQuestionStruct.travelTestDummy
    
    /// 선택된 답변을 저장할 배열
    private lazy var selectedAnswers: [Int?] = Array(repeating: nil, count: travelTestDummy.count)
    
    // MARK: - UI Properties
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("이번 여행은!"))
    private let navigationUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private lazy var travelTestCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var nextButton: DOOButton = {
        let btn = DOOButton(type: .unabled, title: "저장하고 여행 시작하기")
        btn.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let gradientView = UIView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        setCollectionView()
        setDelegate()
        registerCell()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setGradient()
    }
}

// MARK: - Private Extension

private extension TravelTestViewController {
    func setStyle() {
        view.backgroundColor = .white000
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(travelTestCollectionView,
                         navigationBar,
                         navigationUnderlineView,
                         gradientView,
                         nextButton)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        navigationUnderlineView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        travelTestCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(40))
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
    }
    
    func setCollectionView() {
        travelTestCollectionView.backgroundColor = .gray50
        travelTestCollectionView.showsVerticalScrollIndicator = false
    }
    
    func setDelegate() {
        travelTestCollectionView.delegate = self
        travelTestCollectionView.dataSource = self
    }
    
    func registerCell() {
        travelTestCollectionView.register(TravelTestCollectionViewCell.self,
                                          forCellWithReuseIdentifier: TravelTestCollectionViewCell.cellIdentifier)
    }
    
    func setGradient() {
        gradientView.setGradient(firstColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0), secondColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), axis: .vertical)
    }
    
    ///  모든 답변이 완료되었는지 확인하는 메서드
    func checkIfAllAnswersCompleted() {
        // 모든 질문에 대한 답변이 있는지 확인
        let isAllAnswered = selectedAnswers.allSatisfy { $0 != nil }
        
        // 모든 답변이 완료되었으면 nextButton 활성화
        nextButton.currentType = isAllAnswered ? .enabled : .unabled
    }
    
    // MARK: - @objc Methods
    
    // TODO: - 분기처리 필요
    
    @objc
    func nextButtonTapped() {
        let vc = OurToDoViewController()
        navigationController?.pushViewController(vc, animated: true)
        print(selectedAnswers)
    }
}

// MARK: - Extensions  

extension TravelTestViewController: UICollectionViewDelegate { }

extension TravelTestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return travelTestDummy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = travelTestCollectionView.dequeueReusableCell(withReuseIdentifier: TravelTestCollectionViewCell.cellIdentifier, for: indexPath) as? TravelTestCollectionViewCell else { return UICollectionViewCell() }
        cell.travelTestData = travelTestDummy[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension TravelTestViewController: UICollectionViewDelegateFlowLayout {
    /// minimun item spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    /// cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ScreenUtils.getWidth(327)
        let height = ScreenUtils.getHeight(133)
        return CGSize(width: width, height: height)
    }
    
    /// content margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
    }
}

/// 선택된 답변 처리 메서드
extension TravelTestViewController: TravelTestCollectionViewCellDelegate {
    func didSelectAnswer(in cell: TravelTestCollectionViewCell, selectedAnswer: Int) {
        if let indexPath = travelTestCollectionView.indexPath(for: cell) {
            selectedAnswers[indexPath.row] = selectedAnswer
            checkIfAllAnswersCompleted()
        }
    }
}
