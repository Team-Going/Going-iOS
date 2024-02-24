import UIKit

protocol DoubleButtonDelegate: AnyObject {
    func tapEditButton()
    func tapDeleteButton()
}

final class DoubleButtonView: UIView {

    // MARK: - UI Components
    
    private let backgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.backgroundColor = UIColor(resource: .white000)
        
        return stackView
    }()
    
    private lazy var button1: DOOButton = {
        let btn = DOOButton(type: .white, title: "삭제하기")
        btn.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    private lazy var button2: DOOButton = {
        let btn = DOOButton(type: .enabled, title: "수정하기")
        btn.addTarget(self, action: #selector(tapEditButton), for: .touchUpInside)
        btn.tag = 2
        return btn
    }()

    // MARK: - Properties
    
    weak var delegate: DoubleButtonDelegate?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierachy()
        setLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Method

private extension DoubleButtonView {
    
    func setHierachy() {
        self.addSubview(backgroundStackView)
        backgroundStackView.addArrangedSubviews(button1, button2)
    }
    
    func setLayout() {
        backgroundStackView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
    }
    
    @objc
    func tapEditButton() {
        self.delegate?.tapEditButton()
    }
    
    @objc
    func tapDeleteButton() {
        self.delegate?.tapDeleteButton()
    }
    
}

