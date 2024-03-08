//
//  TravelInfoViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/2/24.
//

import UIKit

import SnapKit

final class TravelInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    var tripId: Int = 0
    
    var travelData: TravelDetailResponseStruct? {
        didSet {
            self.travelNameView.travelNameTextField.placeholder = travelData?.title
            self.travelDateView.startDateLabel.text = travelData?.startDate
            self.travelDateView.endDateLabel.text = travelData?.endDate
            self.travelNameView.characterCountLabel.text = "\(travelData?.title.count ?? 0)" + "/15"
        }
    }

    // MARK: - UI Properites
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("여행 정보"))
    
    private let navigationUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .gray100)
        return view
    }()
    
    private lazy var travelNameView: TravelNameView = {
        let view = TravelNameView()
        view.travelNameTextField.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var travelDateView = TravelDateView()
    
    private let buttonHorizStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 7
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var quitTravelButton: DOOButton = {
        let btn = DOOButton(type: .white, title: "나가기")
        btn.addTarget(self, action: #selector(quitTravelButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var editTravelButton: DOOButton = {
        let btn = DOOButton(type: .enabled, title: "수정하기")
        btn.addTarget(self, action: #selector(editTravelButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabbar()
        getAllTravelData(tripId: tripId)
        setColor()
    }
}

// MARK: - Private Methods

private extension TravelInfoViewController {
    func setStyle() {
        self.view.backgroundColor = UIColor(resource: .white000)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         navigationUnderlineView,
                         travelNameView,
                         travelDateView,
                         buttonHorizStackView)
        
        buttonHorizStackView.addArrangedSubviews(quitTravelButton, editTravelButton)
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
        
        travelNameView.snp.makeConstraints {
            $0.top.equalTo(navigationUnderlineView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(101))
        }
        
        travelDateView.snp.makeConstraints {
            $0.top.equalTo(travelNameView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(79))
        }
        
        buttonHorizStackView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-6)
        }
        
        quitTravelButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(160))
        }
        
        editTravelButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(160))
        }
    }
    
    func hideTabbar() {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func setColor() {
        self.travelNameView.travelNameTextField.setPlaceholderColor(UIColor(resource: .gray700))
        self.travelNameView.travelNameTextField.layer.borderColor = UIColor(resource: .gray700).cgColor
        self.travelNameView.characterCountLabel.textColor = UIColor(resource: .gray700)
        
        self.travelDateView.endDateLabel.textColor = UIColor(resource: .gray700)
        self.travelDateView.endDateLabel.layer.borderColor = UIColor(resource: .gray700).cgColor
        
        self.travelDateView.startDateLabel.textColor = UIColor(resource: .gray700)
        self.travelDateView.startDateLabel.layer.borderColor = UIColor(resource: .gray700).cgColor
    }
    
    // MARK: - @objc Methods
    
    @objc
    func quitTravelButtonTapped() {
        let vc = QuitTravelPopUpViewController()
        self.present(vc, animated: false)
    }
    
    @objc
    func editTravelButtonTapped() {
        let vc = EditTravelViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TravelInfoViewController {
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
    
    func reIssueJWTToken() {
        Task {
            do {
                try await AuthService.shared.postReIssueJWTToken()
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
    
    // MARK: - Network
    
    func getAllTravelData(tripId: Int) {
        Task {
            do {
                self.travelData = try await TravelDetailService.shared.getTravelDetailInfo(tripId: tripId)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}

