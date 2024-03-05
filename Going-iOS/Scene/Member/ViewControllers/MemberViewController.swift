//
//  MemberViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/14/24.
//

import UIKit

import SnapKit

class MemberViewController: UIViewController {
    
    // MARK: - Network
    
    var tripId: Int = 0
    
    let userProfileImageSet: [UIImage] = [UIImage(resource: .imgProfileSrp),
                                          UIImage(resource: .imgProfileSri),
                                          UIImage(resource: .imgProfileSep),
                                          UIImage(resource: .imgProfileSei),
                                          UIImage(resource: .imgProfileArp),
                                          UIImage(resource: .imgProfileAri),
                                          UIImage(resource: .imgProfileAep),
                                          UIImage(resource: .imgProfileAei)]
    
    private var userType: Int = 0
    var memberData: MemberResponseStruct? {
        didSet {
            self.membersProfileCollectionView.reloadData() 
            self.ourTestResultView.progressView1.testResultData = memberData?.styles[0]
            self.ourTestResultView.progressView2.testResultData = memberData?.styles[1]
            self.ourTestResultView.progressView3.testResultData = memberData?.styles[2]
            self.ourTestResultView.progressView4.testResultData = memberData?.styles[3]
            self.ourTestResultView.progressView5.testResultData = memberData?.styles[4]
        }
    }
    
    // MARK: - UI Properties

    private let memberScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()

    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("우리의 여행 취향"))
    
    private let navigationUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .gray100)
        return view
    }()
    
    private let tasteDescBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .gray50)
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    
    private let commonTasteLabel = DOOLabel(font: .pretendard(.detail1_bold), 
                                            color: UIColor(resource: .red500),
                                            text: "식당, 여행 계획")
    
    private lazy var tasteDescLabel = DOOLabel(font: .pretendard(.detail1_bold), 
                                               color: UIColor(resource: .gray700),
                                               text: "취향이 잘 맞는 조합이네요!",
                                               alignment: .center)

    private let memberProfileDescLabel = DOOLabel(font: .pretendard(.detail3_regular),
                                             color: UIColor(resource: .gray400),
                                             text: "프로필 사진을 눌러서 친구의 취향을 구경해보세요")
    
    private lazy var membersProfileCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        view.backgroundColor = UIColor(resource: .white000)
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        return view
    }()
    
    private let ourTestResultView = MemberTestResultView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setHierarchy()
        setLayout()
        registerCell()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabbar()
        getAllData()
    }
}

// MARK: - Private Extension

private extension MemberViewController {
    func setStyle() {
        self.view.backgroundColor = UIColor(resource: .white000)
    }
    
    func hideTabbar() {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, 
                         navigationUnderLineView,
                         memberScrollView)
        
        memberScrollView.addSubview(contentView)
        
        contentView.addSubviews(tasteDescBackgroundView,
                                memberProfileDescLabel,
                                membersProfileCollectionView,
                                ourTestResultView)
        
        tasteDescBackgroundView.addSubviews(commonTasteLabel, tasteDescLabel)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        navigationUnderLineView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        memberScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationUnderLineView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(memberScrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
        }
        
        tasteDescBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.height.equalTo(ScreenUtils.getHeight(48))
        }
        
        tasteDescLabel.snp.makeConstraints {
            $0.center.equalTo(tasteDescBackgroundView)
        }
        
        memberProfileDescLabel.snp.makeConstraints {
            $0.top.equalTo(tasteDescBackgroundView.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        membersProfileCollectionView.snp.makeConstraints {
            $0.top.equalTo(memberProfileDescLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(315))
            $0.height.equalTo(ScreenUtils.getHeight(67))
        }
        
        ourTestResultView.snp.makeConstraints {
            $0.top.equalTo(membersProfileCollectionView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.itemSize = CGSize(width: ScreenUtils.getHeight(48) , height: ScreenUtils.getHeight(67))
        return flowLayout
    }
    
    func registerCell() {
        membersProfileCollectionView.register(TripFriendsCollectionViewCell.self, forCellWithReuseIdentifier: TripFriendsCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        membersProfileCollectionView.delegate = self
        membersProfileCollectionView.dataSource = self
    }
}

extension MemberViewController: UICollectionViewDelegateFlowLayout { }

extension MemberViewController: UICollectionViewDelegate { }

extension MemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberData?.participants.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = membersProfileCollectionView.dequeueReusableCell(withReuseIdentifier: TripFriendsCollectionViewCell.cellIdentifier, for: indexPath) as? TripFriendsCollectionViewCell 
        else { return UICollectionViewCell() }
        
        cell.friendNameLabel.text = memberData?.participants[indexPath.row].name
        userType = memberData?.participants[indexPath.row].result ?? 0
        cell.profileImageView.image = userProfileImageSet[userType]
        return cell
    }
}

extension MemberViewController {
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
    
    func getAllData() {
        Task {
            do {
                self.memberData = try await MemberService.shared.getMemberInfo(tripId: tripId)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}

extension MemberViewController {
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
}
