import UIKit

import SnapKit

final class InviteFriendPopUpViewController: PopUpDimmedViewController {
    
    private let popUpView = DOOPopUpContainerView()
    
    private let inviteTitleLabel = DOOLabel(font: .pretendard(.body1_bold), color: .gray600, text: "초대하기")
    private let inviteSubLabel = DOOLabel(font: .pretendard(.detail2_regular), color: .gray300, text: "초대 코드를 보내 여행 친구를 추가해 보세요")
    private let codeBackgroundView = {
        let view = UIView()
        view.backgroundColor = .gray50
        view.layer.cornerRadius = 6
        return view
    }()
    // TODO: - 초대코드 받아온 걸로 수정
    let codeLabel = DOOLabel(font: .pretendard(.head4), color: .gray700)
    private lazy var copyButton: UIButton = {
        let button = UIButton()
        button.setTitle("초대코드 복사하기", for: .normal)
        button.setTitleColor(.gray300, for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_regular)
        button.backgroundColor = .gray50
        button.setImage(ImageLiterals.CreateTravel.buttonCopy, for: .normal)
        button.tintColor = .gray300
        button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    private let underlineView = {
        let view = UIView()
        view.backgroundColor = .gray300
        return view
    }()
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white000, for: .normal)
        button.titleLabel?.font = .pretendard(.body1_bold)
        button.backgroundColor = .gray500
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()

    }
}

private extension InviteFriendPopUpViewController {
    
    func setHierarchy() {
        view.addSubview(popUpView)
        popUpView.addSubviews(
            inviteTitleLabel,
            inviteSubLabel,
            codeBackgroundView,
            completeButton
        )
        codeBackgroundView.addSubviews(codeLabel, copyButton, underlineView)
        
    }
    
    func setLayout() {
        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(270))
            $0.height.equalTo(ScreenUtils.getHeight(232))
        }
        
        inviteTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(22))
        }
        
        inviteSubLabel.snp.makeConstraints {
            $0.top.equalTo(inviteTitleLabel.snp.bottom).offset(4)
            $0.height.equalTo(ScreenUtils.getHeight(18))
            $0.centerX.equalToSuperview()
        }
        
        codeBackgroundView.snp.makeConstraints {
            $0.top.equalTo(inviteSubLabel.snp.bottom).offset(16)
            $0.height.equalTo(ScreenUtils.getHeight(71))
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        codeLabel.snp.makeConstraints {
            $0.top.equalTo(codeBackgroundView).inset(9)
            $0.height.equalTo(ScreenUtils.getHeight(27))
            $0.centerX.equalToSuperview()
        }
        
        copyButton.snp.makeConstraints {
            $0.top.equalTo(codeLabel.snp.bottom)
            $0.height.equalTo(ScreenUtils.getHeight(20))
            $0.width.equalTo(ScreenUtils.getWidth(102))
            $0.centerX.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints{
            $0.top.equalTo(copyButton.snp.bottom)
            $0.width.equalTo(ScreenUtils.getWidth(102))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        completeButton.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(53))
        }
    }
    
    @objc
    func copyButtonTapped() {
        UIPasteboard.general.string = self.codeLabel.text
        DOOToast.show(message: "초대코드가 복사되었어요", insetFromBottom: ScreenUtils.getHeight(101))
    }
    
    @objc
    func completeButtonTapped() {
        self.dismiss(animated: false)
    }
}

