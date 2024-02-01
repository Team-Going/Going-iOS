import UIKit

final class OurToDoHeaderView: UIView {
    
    //MARK: - Property
    
    static let identifier = "OurToDoHeaderView"
     
    
    //MARK: - UI Property
    
    let segmentedControl: UnderlineSegmentedControlView = {
        let segmentedControl = UnderlineSegmentedControlView(items: ["해야 해요", "완료했어요"])
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
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - private method

private extension OurToDoHeaderView {
    
    func setHierarchy() {
        self.addSubviews(underlineView, segmentedControl)
    }
    
    func setLayout() {
        underlineView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        segmentedControl.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(underlineView)
            $0.height.equalTo(ScreenUtils.getHeight(49))
        }
    }
    
    func setStyle() {
        self.backgroundColor = .white000
        underlineView.backgroundColor = .gray200
        segmentedControl.setWidth(ScreenUtils.getWidth(375) / 2, forSegmentAt: 0)
        segmentedControl.setWidth(ScreenUtils.getWidth(375) / 2, forSegmentAt: 1)
    }
}

