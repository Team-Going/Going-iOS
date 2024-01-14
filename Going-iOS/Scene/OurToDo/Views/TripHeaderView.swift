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
    lazy var tripNameLabel: UILabel = DOOLabel(font: .pretendard(.head2), color: .gray700, alignment: .left)
    lazy var tripDdayLabel: UILabel = DOOLabel(font: .pretendard(.head2), color: .gray700, alignment: .left)
    lazy var tripDateLabel: UILabel = DOOLabel(font: .pretendard(.body3_medi), color: .gray300, alignment: .left)
    let tripDateLabelAttachImg: NSTextAttachment = NSTextAttachment(image: ImageLiterals.OurToDo.icCalendar)

    // MARK: - Property
    
    //ourtodo header data
    var tripData: [String]? {
        didSet {
            guard let data = tripData else {return}
            self.tripNameLabel.text = data[0]
            self.tripDdayLabel.text = "여행일까지 \(data[1])일 남았어요!"
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
    
    //mytodo header data
    var myToDoHeaderData: [String]? {
        didSet {
            guard let data = myToDoHeaderData else {return}
            self.tripNameLabel.text = data[0]
            self.tripDdayLabel.text = "나에게 남은 할일 \(data[1])개"
            
            let text = tripDdayLabel.text ?? ""
            let firstString = NSMutableAttributedString(string: text)
            firstString.addAttribute(.foregroundColor, value: UIColor.gray700, range: (text as NSString).range(of: "나에게 남은 할일"))
            firstString.addAttribute(.foregroundColor, value: UIColor.red400, range: (text as NSString).range(of: String("\(data[1])개")))
            tripDdayLabel.attributedText = firstString
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
        self.addSubviews(tripHeaderStackView)
        tripHeaderStackView.addArrangedSubviews(tripNameLabel, tripDdayLabel, tripDateLabel)
    }

    func setLayout() {
        tripHeaderStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(25))
            $0.top.equalToSuperview()
            $0.height.equalToSuperview()
        }
        tripDateLabel.snp.makeConstraints{
            $0.height.equalTo(ScreenUtils.getHeight(21))
        }
    }
        
    func setStyle() {
        self.backgroundColor = UIColor.gray50
    }
}


