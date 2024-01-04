import UIKit

class UnderlineSegmentedControlView: UISegmentedControl {

    // MARK: - UI Property
    
    private lazy var underlineView: UIView = {
        let width = absoluteWidth * 375 / 2
        let height = absoluteHeight * 2
        let xPosition = CGFloat(self.selectedSegmentIndex) * width
        let yPosition = self.bounds.size.height - 2.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: CGFloat(height))
        let view = UIView(frame: frame)
        view.backgroundColor = .gray500
        self.addSubview(view)
        return view
    }()
    
    // MARK: - Property
    
    let absoluteWidth = UIScreen.main.bounds.width / 375
    let absoluteHeight = UIScreen.main.bounds.height / 812
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeBackgroundAndDivider()
    }

    override init(items: [Any]?) {
        super.init(items: items)
        self.removeBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let underlineFinalXPosition = underlineView.bounds.width * CGFloat(self.selectedSegmentIndex)
        UIView.animate(
          withDuration: 0.1,
          animations: {
            self.underlineView.frame.origin.x = underlineFinalXPosition
          }
        )
    }
}

// MARK: - private method

private extension UnderlineSegmentedControlView {
    func removeBackgroundAndDivider() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
}

