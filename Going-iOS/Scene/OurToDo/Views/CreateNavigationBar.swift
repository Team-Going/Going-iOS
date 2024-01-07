import UIKit

import SnapKit

protocol NavigationBarDelegate: AnyObject {
    func popToPreviousView()
}

final class CreateNavigationBar: UIView {

    // MARK: - UI Property

    lazy var navigationBarView: UIView = {setView()}()
    lazy var backButton: UIButton = {setBackButton()}()
    lazy var navigationTitleLabel: UILabel = {setLabel()}()
    lazy var rightItem: UIButton = UIButton()

    // MARK: - Property
    
    weak var delegate: NavigationBarDelegate?
    let absoluteWidth = UIScreen.main.bounds.width / 375
    let absoluteHeight = UIScreen.main.bounds.height / 812
    
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
    
    @objc
    func setAddTarget() {
        delegate?.popToPreviousView()
    }
}


// MARK: - Private method

private extension CreateNavigationBar {
    
    func setHierarchy() {
        self.addSubview(navigationBarView)
        navigationBarView.addSubviews(backButton, navigationTitleLabel, rightItem)
    }
    
    func setLayout() {
        navigationBarView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        backButton.snp.makeConstraints{
            $0.leading.centerY.equalToSuperview()
            $0.width.equalTo(absoluteWidth * 48)
            $0.height.equalTo(absoluteHeight * 48)
        }
        navigationTitleLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
//            $0.height.equalTo(absoluteHeight * 48)
            $0.leading.equalTo(backButton.snp.trailing).offset(absoluteWidth * 18)
        }
        rightItem.snp.makeConstraints{
            $0.centerY.trailing.equalToSuperview()
            $0.height.equalTo(absoluteHeight * 18)
        }
    }
    
    func setStyle() {
        self.backgroundColor = UIColor.gray50
    }
    
    func setView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func setBackButton() -> UIButton {
        let btn = UIButton()
        btn.setImage(ImageLiterals.OurToDo.btnBack, for: .normal)
        btn.tintColor = UIColor.gray400
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(setAddTarget), for: .touchUpInside)
        return btn
    }
    
    func setLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.gray700
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.backgroundColor = .clear
        return label
    }
}

