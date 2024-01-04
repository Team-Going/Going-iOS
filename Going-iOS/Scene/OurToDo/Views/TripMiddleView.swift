import UIKit

class TripMiddleView: UIView {
    
    // MARK: - UI Property
    
    private var ticketBoxImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = ImageLiterals.OurToDo.ticketBox
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    private lazy var tripProgressLabel: UILabel = {setLabel(text: "우리 여행 진행률",textAlignment: .left)}()
    private lazy var percentageLabel: UILabel = {setLabel(textColor: UIColor.red400, textAlignment: NSTextAlignment.right)}()
    private var tripProgressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.trackTintColor = UIColor.gray100
        progressBar.progressTintColor = UIColor.red400
        progressBar.progressViewStyle = .default
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = 6
        return progressBar
    }()
    private var tripFriendsContainer: UIView = UIView()
    private lazy var tripFriendsLabel: UILabel = {setLabel(text: "여행 친구들", textAlignment: .left)
    }()
    private var tripFriendsBtn: UIButton = UIButton()
    private lazy var tripFriendsCollectionView: UICollectionView = {setCollectionView()}()
    private var addButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .gray50
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.gray100.cgColor
        btn.setImage(ImageLiterals.OurToDo.btnPlus, for: .normal)
        return btn
    }()
    private lazy var addLabel: UILabel = {setLabel(text: "추가하기", font: UIFont.pretendard(.detail3_regular), textColor: UIColor.gray500,  textAlignment: .center)}()
    var gradientView: UIView = UIView()
    var addStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .white000
        return stackView
    }()
    
    // MARK: - Property
    
    let absoluteWidth = UIScreen.main.bounds.width / 375
    let absoluteHeight = UIScreen.main.bounds.height / 812
    var friendProfile: [Friend] = []
    
    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setHierachy()
        registerCell()
        setLayout()
        setStyle()
        setAddTarget()
        setDelegate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
        func pushToAddFriendsView() {
        print("pushToAddFriendsView")
    }
    
    @objc
        func pushToInquiryFriendsView() {
        print("pushToInquiryFriendsView")
    }
    
    @objc
    func pushToFriendProfileView(_ sender: UITapGestureRecognizer) {
        print("pushToFriendProfileView")
    }
    
    func bindData(percentage: Int, friends: [Friend]) {
        self.percentageLabel.text = String(percentage) + "%"
        self.tripProgressBar.progress = Float(percentage) * 0.01
        self.friendProfile = friends
        self.tripFriendsCollectionView.reloadData()
    }
}

// MARK: - Private Method

private extension TripMiddleView {

    func setHierachy() {
        self.addSubview(ticketBoxImgView)
        ticketBoxImgView.addSubviews(tripProgressLabel, percentageLabel, tripProgressBar, tripFriendsContainer, tripFriendsCollectionView, gradientView, addStackView)
        tripFriendsContainer.addSubviews(tripFriendsLabel, tripFriendsBtn)
        addStackView.addArrangedSubviews(addButton, addLabel)
    }

    func setLayout() {
        ticketBoxImgView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(absoluteWidth * 25)
            $0.top.bottom.equalToSuperview()
        }
        tripProgressLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(absoluteHeight * 20)
            $0.leading.equalToSuperview().inset(absoluteWidth * 16)
            $0.width.equalTo(absoluteWidth * 100)
            $0.height.equalTo(absoluteHeight * 23)
        }
        percentageLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(absoluteHeight * 20)
            $0.trailing.equalToSuperview().inset(absoluteWidth * 16)
            $0.height.equalTo(absoluteHeight * 23)
        }
        tripProgressBar.snp.makeConstraints{
            $0.top.equalTo(tripProgressLabel.snp.bottom).offset(absoluteHeight * 12)
            $0.leading.trailing.equalToSuperview().inset(absoluteWidth * 16)
            $0.height.equalTo(absoluteHeight * 10)
        }
        tripFriendsContainer.snp.makeConstraints{
            $0.top.equalTo(tripProgressBar.snp.bottom).offset(absoluteHeight * 52)
            $0.leading.trailing.equalToSuperview().inset(absoluteWidth * 16)
            $0.height.equalTo(absoluteHeight * 23)
        }
        tripFriendsLabel.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(absoluteWidth * 70)
            $0.height.equalToSuperview()
        }
        tripFriendsBtn.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(tripFriendsLabel.snp.trailing)
        }
        
        tripFriendsCollectionView.snp.makeConstraints{
            $0.top.equalTo(tripFriendsContainer.snp.bottom).offset(absoluteHeight * 12)
            $0.leading.equalToSuperview().inset(absoluteWidth * 16)
            $0.trailing.equalToSuperview().inset(absoluteWidth * 64)
            $0.height.equalTo(absoluteHeight * 67)
        }
        
        addStackView.snp.makeConstraints{
            $0.top.equalTo(tripFriendsContainer.snp.bottom).offset(absoluteHeight * 12)
            $0.trailing.equalToSuperview().inset(absoluteWidth * 16)
            $0.width.equalTo(absoluteHeight * 48)
            $0.height.equalTo(absoluteHeight * 67)
        }
        
        gradientView.snp.makeConstraints{
            $0.top.equalTo(tripFriendsContainer.snp.bottom).offset(absoluteHeight * 12)
            $0.trailing.equalTo(addStackView.snp.leading)
            $0.width.equalTo(absoluteWidth * 40)
            $0.height.equalTo(absoluteHeight * 67)
        }
        
        addButton.snp.makeConstraints{
            $0.size.equalTo(absoluteHeight * 48)
        }
        
        addLabel.snp.makeConstraints{
            $0.height.equalTo(absoluteHeight * 17)
        }
    }

    func setStyle() {
        self.backgroundColor = UIColor.gray50
        tripFriendsContainer.backgroundColor = .white
        tripFriendsBtn.setImage(ImageLiterals.OurToDo.btnEnter, for: .normal)
        addButton.layer.cornerRadius = absoluteHeight * 23.5

    }
    
    func setLabel(text: String? = "", font: UIFont? = UIFont.pretendard(.body2_medi), textColor: UIColor? = UIColor.gray700, textAlignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        return label
    }
    
    func setAddTarget() {
        tripFriendsBtn.addTarget(self, action: #selector(pushToInquiryFriendsView), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(pushToAddFriendsView), for: .touchUpInside)
    }
    
    func setDelegate() {
        self.tripFriendsCollectionView.dataSource = self
        self.tripFriendsCollectionView.delegate = self
    }
    
    func setCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        collectionView.backgroundColor = UIColor.white000
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        return collectionView
    }
    
    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: absoluteHeight * 48 , height: absoluteHeight * 67)
        return flowLayout
    }
    
    func registerCell() {
        self.tripFriendsCollectionView.register(TripFriendsCollectionViewCell.self, forCellWithReuseIdentifier: TripFriendsCollectionViewCell.identifier)
    }
}


extension TripMiddleView: UICollectionViewDelegate{}

extension TripMiddleView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friendProfile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let friendsCell = collectionView.dequeueReusableCell(withReuseIdentifier: TripFriendsCollectionViewCell.identifier, for: indexPath) as? TripFriendsCollectionViewCell else {return UICollectionViewCell()}
        friendsCell.bindData(data: self.friendProfile[indexPath.row])
        
        // TODO: - 변수 만들어놓고 탭하면 담당자 id 세팅해주기
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pushToFriendProfileView(_:)))
        friendsCell.profileStackView.addGestureRecognizer(gesture)
        return friendsCell

    }
    
}

