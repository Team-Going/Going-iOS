import UIKit

import SnapKit

class TripFriendsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let identifier = "TripFriendsCollectionViewCell"
    
    // MARK: - UI Properties
    
    var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .white
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    // TODO: - 서버통신 시 이미지 수정
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.OurToDo.icCalendar
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let friendNameLabel: UILabel = DOOLabel(font: .pretendard(.detail3_regular), color: .gray500, alignment: .center)

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //TODO: - 서버통신 할 때 이미지 세팅 수정 필요
    
    func bindData(data: Participant) {
        self.profileImageView.image = ImageLiterals.OurToDo.mainViewIcon
        self.friendNameLabel.text = data.name
    }
}

// MARK: - Private Method

private extension TripFriendsCollectionViewCell {
    
    func setHierarchy() {
        contentView.addSubview(profileStackView)
        profileStackView.addArrangedSubviews(profileImageView, friendNameLabel)
    }
    
    func setLayout() {
        profileStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints{
            $0.size.equalTo(ScreenUtils.getHeight(48))
        }
        
        friendNameLabel.snp.makeConstraints{
            $0.height.equalTo(ScreenUtils.getHeight(17))
        }
    }
    
    func setStyle() {
        profileImageView.layer.cornerRadius = ScreenUtils.getHeight(23.5)
    }
}

