import UIKit

import SnapKit

final class TripHeaderView: UIView {
    
    // MARK: - UI Property
    
    private var tripHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor.gray50
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.isUserInteractionEnabled = true
        stackView.spacing = 8
        return stackView
    }()
    lazy var tripNameLabel: UILabel = {setLabel()}()
    lazy var tripDdayLabel: UILabel = {setLabel()}()
    lazy var tripDateLabel: UILabel = {setLabel(font: UIFont.pretendard(.body3_medi), textColor: UIColor.gray300)}()
    private lazy var editTripButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.gray50
        btn.setImage(ImageLiterals.OurToDo.btnOurToDoEdit, for: .normal)
        btn.isUserInteractionEnabled = false
        btn.addTarget(self, action: #selector(pushToEditTripView(_:)), for: .touchUpInside)
        return btn
    }()
    private let tripDateLabelAttachImg: NSTextAttachment = NSTextAttachment(image: ImageLiterals.OurToDo.icCalendar)

    // MARK: - Property
    
    var tripData: [String]? {
        didSet {
            guard let data = tripData else {return}
            self.tripNameLabel.text = data[0]
            self.tripDdayLabel.text = data[1]
            self.tripDateLabel.text = data[2] + " - " + data[3]
            
            let text = tripDdayLabel.text ?? ""
            let splitText = tripDdayLabel.text?.split(separator: " ") ?? []
            let firstString = NSMutableAttributedString(string: text)
            firstString.addAttribute(.foregroundColor, value: UIColor.gray700, range: (text as NSString).range(of: String(splitText[0])))
            firstString.addAttribute(.foregroundColor, value: UIColor.red400, range: (text as NSString).range(of: String(splitText[1])))
            firstString.addAttribute(.foregroundColor, value: UIColor.gray700, range: (text as NSString).range(of: String(splitText[2])))
            tripDdayLabel.attributedText = firstString
            
            let string = self.tripDateLabel.text ?? ""
            let date = NSAttributedString(string: " \(string)" )
            let attachImg = NSAttributedString(attachment: tripDateLabelAttachImg)
            tripDateLabel.labelWithImg(composition: attachImg, date)
        }
    }

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
    func pushToEditTripView(_ sender: UITapGestureRecognizer) {
        print("pushToEditTripView")
    }
}


// MARK: - Private Method

private extension TripHeaderView {

    func setHierarchy() {
        self.addSubviews(tripHeaderStackView, editTripButton)
        tripHeaderStackView.addArrangedSubviews(tripNameLabel, tripDdayLabel, tripDateLabel)
    }

    func setLayout() {
        tripHeaderStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(25))
            $0.top.equalToSuperview()
            $0.height.equalToSuperview()
        }
        tripNameLabel.snp.makeConstraints{
            $0.height.equalTo(ScreenUtils.getHeight(28))
        }
        tripDdayLabel.snp.makeConstraints{
            $0.leading.centerY.top.bottom.equalToSuperview()
        }
        editTripButton.snp.makeConstraints{
            $0.leading.equalTo(tripDdayLabel.snp.trailing).offset(3)
            $0.size.equalTo(ScreenUtils.getHeight(28))
            $0.centerY.equalTo(tripDdayLabel)
        }
        tripDateLabel.snp.makeConstraints{
            $0.height.equalTo(ScreenUtils.getHeight(21))
        }
    }
        
    func setStyle() {
        self.backgroundColor = UIColor.gray50
    }
    
    func setLabel(font: UIFont? = UIFont.pretendard(.head2), textColor: UIColor? = UIColor.gray700) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.textAlignment = .left
        return label
    }
}


