//
//  EditTravelTestViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/10/24.
//

import UIKit

import SnapKit

final class EditTravelTestViewController: UIViewController {
    
    // MARK: - Properties 
    
    var participantId: Int = 0
    
    var tripId: Int = 0
    
    var resultIntArray: [Int] = []
    
    var travelTestData: MemberProfileResponseStruct? {
        didSet {
            guard let data = travelTestData else { return }
            resultIntArray = [data.styleA, data.styleB, data.styleC, data.styleD, data.styleE]
            
            travelTestResultView.resultIntArray = resultIntArray
            travelTestResultView.travelTestCollectionView.reloadData()
        }
    }
    
    private var patchRequestBody: EditTravelTestRequestStruct = .init(styleA: 0, styleB: 0, styleC: 0, styleD: 0, styleE: 0)
    
    var editedTestResult: [Int] = []
    
    // MARK: - UI Properites
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("이번 여행은!"))
    
    private let navigationUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .gray100)
        return view
    }()
    
    private let travelTestResultView: TravelTestResultView = {
        let view = TravelTestResultView()
        return view
    }()
    
    lazy var editButton: DOOButton = {
        let btn = DOOButton(type: .unabled, title: "취향태그 수정하기")
        btn.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let gradientView = UIView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setHierarchy()
        setLayout()
        setDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTravelTestData()
        hideTabbar()
    }
}

// MARK: - Private Extensions

private extension EditTravelTestViewController {
    func setStyle() {
        view.backgroundColor = UIColor(resource: .white000)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func hideTabbar() {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func setHierarchy() {
        self.view.addSubviews(navigationBar,
                              navigationUnderlineView,
                              travelTestResultView,
                              gradientView,
                              editButton)
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
        
        travelTestResultView.snp.makeConstraints {
            $0.top.equalTo(navigationUnderlineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(editButton.snp.top)
        }
        
        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(editButton.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(40))
        }
        
        editButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
    }
    
    func setDelegate() {
        self.travelTestResultView.delegate = self
    }
    
    func setGradient() {
        gradientView.setGradient(firstColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0), 
                                 secondColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), 
                                 axis: .vertical)
    }
    
    // MARK: - @objc Methods
    
    @objc
    func editButtonTapped() {
        HapticService.impact(.medium).run()
        
        patchTravelTestData()
    }
}

extension EditTravelTestViewController: TravelTestResultViewDelegate {
    func retryButtonTapped() {
        return
    }
    
    func userDidSelectAnswer() {
        editButton.currentType = .enabled
        
        setPatchTravelTestData()
    }
    
    func retryTravelTestButton() { return }
}

extension EditTravelTestViewController {
    func setPatchTravelTestData() {
        // 변경된 resultIntArray를 바탕으로 patchRequestBody 세팅
        patchRequestBody.styleA = travelTestResultView.resultIntArray[0]
        patchRequestBody.styleB = travelTestResultView.resultIntArray[1]
        patchRequestBody.styleC = travelTestResultView.resultIntArray[2]
        patchRequestBody.styleD = travelTestResultView.resultIntArray[3]
        patchRequestBody.styleE = travelTestResultView.resultIntArray[4]
    }
}

// MARK: - Network

extension EditTravelTestViewController {
    func handleError(_ error: NetworkError) {
        switch error {
        case .serverError:
            DOOToast.show(message: "서버 오류", insetFromBottom: 80)
        case .unAuthorizedError, .reIssueJWT:
            DOOToast.show(message: "토큰만료, 재로그인필요", insetFromBottom: 80)
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            DOOToast.show(message: error.description, insetFromBottom: 80)
        }
    }
    
    func getTravelTestData() {
        Task {
            do {
                self.travelTestData = try await TravelProfileService.shared.getTravelProfileInfo(participantId: participantId)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
    
    func patchTravelTestData() {
        Task {
            do {
                try await TravelDetailService.shared.patchTravelTest(tripId: tripId, requestBody: patchRequestBody)
            }
            self.navigationController?.popViewController(animated: false)
            DOOToast.show(message: "취향태그를 수정했어요", insetFromBottom: ScreenUtils.getHeight(103))
        }
    }
}
