import UIKit

class OurToDoHeaderView: UIView {
    
    //MARK: - Property
    
    static let identifier = "OurToDoHeaderView"
    let absoluteWidth = UIScreen.main.bounds.width / 375
    let absoluteHeight = UIScreen.main.bounds.height / 812
    
    //MARK: - UI Property
    
    let segmentedControl: UnderlineSegmentedControlView = {
        let segmentedControl = UnderlineSegmentedControlView(items: ["미완료 todo", "   완료 todo"])
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray200,
            .font: UIFont.pretendard(.body2_bold)], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray500,
            .font: UIFont.pretendard(.body2_bold)], for: .selected)
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    private let underlineView: UIView = UIView()

    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierachy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - private method

private extension OurToDoHeaderView {
    
    func setHierachy() {
        self.addSubviews(underlineView, segmentedControl)
    }
    
    func setLayout() {
        underlineView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(absoluteHeight * 1)
        }
        segmentedControl.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(underlineView)
            $0.width.equalTo(absoluteWidth * 147)
            $0.height.equalTo(absoluteHeight * 49)
        }
    }
    
    func setStyle() {
        self.backgroundColor = .white000
        underlineView.backgroundColor = .gray200
        segmentedControl.setWidth(absoluteWidth * 375 / 2, forSegmentAt: 0)
        segmentedControl.setWidth(absoluteWidth * 375 / 2, forSegmentAt: 1)
    }
}

