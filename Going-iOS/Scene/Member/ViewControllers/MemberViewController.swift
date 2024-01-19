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
    
    let userProfileImageSet: [UIImage] = [ImageLiterals.Profile.imgHeartSRP,
                                          ImageLiterals.Profile.imgSnowmanSRI,
                                          ImageLiterals.Profile.imgTriangleSEP,
                                          ImageLiterals.Profile.imgSquareSEI,
                                          ImageLiterals.Profile.imgCloverARP,
                                          ImageLiterals.Profile.imgCloudARI,
                                          ImageLiterals.Profile.imgHexagonAEP,
                                          ImageLiterals.Profile.imgCircleAEI]
    
    private var userType: Int = 0
    var memberData: MemberResponseStruct? {
        didSet {
            self.tripFriendsCollectionView.reloadData() 
            self.ourTestResultView.progressView1.testResultData = memberData?.styles[0]
            self.ourTestResultView.progressView2.testResultData = memberData?.styles[1]
            self.ourTestResultView.progressView3.testResultData = memberData?.styles[2]
            self.ourTestResultView.progressView4.testResultData = memberData?.styles[3]
            self.ourTestResultView.progressView5.testResultData = memberData?.styles[4]
        }
    }
    
    private let memberScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()

    // MARK: - UI Properties
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("함께 하는 친구들"))
    private let navigationUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let memeberTitleLabel = DOOLabel(font: .pretendard(.body3_bold), color: .gray700, text: "멤버")
    
    private lazy var tripFriendsCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        view.backgroundColor = UIColor.white000
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        return view
    }()
    
    private let ourTasteTitleLabel = DOOLabel(font: .pretendard(.body3_bold), color: .gray700, text: "우리의 이번 여행은!")
    
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
        self.view.backgroundColor = .white000
    }
    
    func hideTabbar() {
        self.navigationController?.tabBarController?.tabBar.isHidden = true

    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, navigationUnderLineView, memberScrollView)
        memberScrollView.addSubview(contentView)
        contentView.addSubviews( memeberTitleLabel,
                         tripFriendsCollectionView,
                         ourTasteTitleLabel,
                         ourTestResultView)
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
        
        memeberTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(23))
        }
        
        tripFriendsCollectionView.snp.makeConstraints {
            $0.top.equalTo(memeberTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(67))
        }
        
        ourTasteTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tripFriendsCollectionView.snp.bottom).offset(26)
            $0.leading.equalToSuperview().inset(24)
        }
        
        ourTestResultView.snp.makeConstraints {
            $0.top.equalTo(ourTasteTitleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(23)
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
        tripFriendsCollectionView.register(TripFriendsCollectionViewCell.self, forCellWithReuseIdentifier: TripFriendsCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        tripFriendsCollectionView.delegate = self
        tripFriendsCollectionView.dataSource = self
    }
}

extension MemberViewController: UICollectionViewDelegateFlowLayout { }

extension MemberViewController: UICollectionViewDelegate { }

extension MemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberData?.participants.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tripFriendsCollectionView.dequeueReusableCell(withReuseIdentifier: TripFriendsCollectionViewCell.cellIdentifier, for: indexPath) as? TripFriendsCollectionViewCell else { return UICollectionViewCell() }
        
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
