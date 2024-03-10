import UIKit

protocol TripMiddleViewDelegate: AnyObject {
    func presentToInviteFriendVC()
    func pushToMemberVC(participantId: Int)
}

final class TripMiddleView: UIView {
    
    // MARK: - UI Property
    
    let userProfileImageSet: [UIImage] = [UIImage(resource: .imgProfileSrp),
                                          UIImage(resource: .imgProfileSri),
                                          UIImage(resource: .imgProfileSep),
                                          UIImage(resource: .imgProfileSei),
                                          UIImage(resource: .imgProfileArp),
                                          UIImage(resource: .imgProfileAri),
                                          UIImage(resource: .imgProfileAep),
                                          UIImage(resource: .imgProfileAei)]
    
    private let ticketBoxImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(resource: .ticketBox)
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    private lazy var tripProgressLabel: UILabel = DOOLabel(
        font: .pretendard(.body2_medi),
        color: UIColor(resource: .gray700),
        text: StringLiterals.OurToDo.ourProgress,
        alignment: .left
    )
    
    private lazy var percentageLabel: UILabel = DOOLabel(
        font: .pretendard(.body2_medi),
        color: UIColor(resource: .red500),
        alignment: .right
    )
    
    private var tripProgressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.trackTintColor = UIColor(resource: .gray100)
        progressBar.progressTintColor = UIColor(resource: .red500)
        progressBar.progressViewStyle = .default
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = 6
        return progressBar
    }()

    private lazy var tripFriendsContainer: UIView = {
        let view = UIView()
        let friendsLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        view.addGestureRecognizer(friendsLabelTapGestureRecognizer)
        return view
    }()
    
    private let tripFriendsLabel: DOOLabel = DOOLabel(
        font: .pretendard(.body2_medi),
        color: UIColor(resource: .gray700),
        text: StringLiterals.OurToDo.friends,
        alignment: .left
    )
   
    private lazy var tripFriendsBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pushToInquiryFriendsView), for: .touchUpInside)
        return btn
    }()
   
    private lazy var tripFriendsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: ScreenUtils.getHeight(48) , height: ScreenUtils.getHeight(67))
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white000
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
   
    private lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(resource: .gray50)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor(resource: .gray100).cgColor
        btn.setImage(UIImage(resource: .btnPlus), for: .normal)
        btn.addTarget(self, action: #selector(pushToAddFriendsView), for: .touchUpInside)
        return btn
    }()
    
    private lazy var addLabel: UILabel = DOOLabel(
        font: .pretendard(.detail3_regular),
        color: UIColor(resource: .gray500),
        text: StringLiterals.OurToDo.invite,
        alignment: .center
    )
   
    var gradientView: UIView = UIView()
    
    var addStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = UIColor(resource: .white000)
        return stackView
    }()
    
    
    // MARK: - Property
    
    private var userType: Int = 0
    
    var participantId: Int = 0
    
    var friendProfile: [Participant] = []
    
    weak var delegate: TripMiddleViewDelegate?
    
    var progress: Int? {
        didSet {
            guard let progress else {return}
            self.percentageLabel.text = String(progress) + "%"
            self.tripProgressBar.progress = Float(progress) * 0.01
        }
    }
    
    var participants: [Participant]? {
        didSet {
            guard let participants else {return}
            self.friendProfile = participants
            self.tripFriendsCollectionView.reloadData()
        }
    }
  
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setHierarchy()
        registerCell()
        setLayout()
        setStyle()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func pushToAddFriendsView() {
        self.delegate?.presentToInviteFriendVC()
    }
    
    @objc
    func pushToInquiryFriendsView() {
        self.delegate?.pushToMemberVC(participantId: participantId)
    }
    
    //친구라벨 눌렀을 때
    @objc 
    func didTapView(_ sender: UITapGestureRecognizer) {
        self.delegate?.pushToMemberVC(participantId: participantId)
    }
}

// MARK: - Private Method

private extension TripMiddleView {
    
    func setHierarchy() {
        self.addSubview(ticketBoxImgView)
        ticketBoxImgView.addSubviews(tripProgressLabel,
                                     percentageLabel,
                                     tripProgressBar,
                                     tripFriendsLabel,
                                     tripFriendsCollectionView,
                                     gradientView,
                                     addStackView)
        addStackView.addArrangedSubviews(addButton, addLabel)
    }
    
    func setLayout() {
        ticketBoxImgView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.top.bottom.equalToSuperview()
        }
        
        tripProgressLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(20))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.width.equalTo(ScreenUtils.getWidth(100))
            $0.height.equalTo(ScreenUtils.getHeight(23))
        }
        
        percentageLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(20))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.height.equalTo(ScreenUtils.getHeight(23))
        }
        
        tripProgressBar.snp.makeConstraints{
            $0.top.equalTo(tripProgressLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.height.equalTo(ScreenUtils.getHeight(10))
        }
        
        tripFriendsLabel.snp.makeConstraints{
            $0.top.equalTo(tripProgressBar.snp.bottom).offset(ScreenUtils.getHeight(32))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.width.equalTo(ScreenUtils.getWidth(100))
            $0.height.equalTo(ScreenUtils.getHeight(23))
        }
        
        tripFriendsCollectionView.snp.makeConstraints{
            $0.top.equalTo(tripFriendsLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(64))
            $0.height.equalTo(ScreenUtils.getHeight(67))
        }
        
        addStackView.snp.makeConstraints{
            $0.top.equalTo(tripFriendsLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(16))
            $0.width.equalTo(ScreenUtils.getHeight(45))
            $0.height.equalTo(ScreenUtils.getHeight(67))
        }
        
        gradientView.snp.makeConstraints{
            $0.top.equalTo(tripFriendsLabel.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.trailing.equalTo(addStackView.snp.leading)
            $0.width.equalTo(ScreenUtils.getWidth(45))
            $0.height.equalTo(ScreenUtils.getHeight(67))
        }
        
        addButton.snp.makeConstraints{
            $0.size.equalTo(ScreenUtils.getHeight(45))
        }
    }
    
    func setStyle() {
        self.backgroundColor = UIColor(resource: .gray50)
        tripFriendsContainer.backgroundColor = UIColor(resource: .white000)
        addButton.layer.cornerRadius = ScreenUtils.getHeight(22.5)
    }

    func setDelegate() {
        self.tripFriendsCollectionView.dataSource = self
        self.tripFriendsCollectionView.delegate = self
    }
    
    func registerCell() {
        self.tripFriendsCollectionView.register(TripFriendsCollectionViewCell.self, forCellWithReuseIdentifier: TripFriendsCollectionViewCell.identifier)
    }
}


// MARK: - Extension

extension TripMiddleView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.participantId = participants?[indexPath.row].participantId ?? 0
        self.delegate?.pushToMemberVC(participantId: self.participantId)
    }
}

extension TripMiddleView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friendProfile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let friendsCell = collectionView.dequeueReusableCell(withReuseIdentifier: TripFriendsCollectionViewCell.identifier, for: indexPath) as? TripFriendsCollectionViewCell else {return UICollectionViewCell()}
        friendsCell.bindData(data: self.friendProfile[indexPath.row])
        
        self.userType = participants?[indexPath.row].result ?? -2
        
        if userType >= 0 && userType < userProfileImageSet.count {
            friendsCell.profileImageView.image = userProfileImageSet[userType]
        } else {
            // 대체 이미지 설정 또는 기타 처리
            friendsCell.profileImageView.image = UIImage(resource: .imgProfileGuest)
        }
        return friendsCell
    }
}
