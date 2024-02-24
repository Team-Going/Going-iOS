import UIKit

import SnapKit

final class TripHeaderView: UIView {
    
    // MARK: - UI Property
    
    private var tripHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor(resource: .gray50)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.isUserInteractionEnabled = true
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var tripNameLabel: UILabel = DOOLabel(
        font: .pretendard(.head2),
        color: UIColor(resource: .gray700),
        alignment: .left
    )
    
    lazy var tripDdayLabel: UILabel = DOOLabel(
        font: .pretendard(.head2),
        color: UIColor(resource: .gray700),
        alignment: .left
    )
    
    lazy var tripDateLabel: UILabel = DOOLabel(
        font: .pretendard(.body3_medi),
        color: UIColor(resource: .gray300),
        alignment: .left
    )
    
    let tripDateLabelAttachImg: NSTextAttachment = NSTextAttachment(image: ImageLiterals.OurToDo.icCalendar)
    
    
    // MARK: - Property
    
    private var dDay: Int = 0

    var tripData: OurToDoHeaderAppData? {
        didSet {
            guard let data = tripData else {return}
            self.tripNameLabel.text = data.title
            
            if data.isComplete == true {
                let minusText = "여행이 완료되었어요!"
                
                let attributedString = NSMutableAttributedString(string: minusText)
                
                let range = NSRange(location: 4, length: 2)
                
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(resource: .red500), range: range)
                
                self.tripDdayLabel.attributedText = attributedString
            }
            else {
                if data.day <= 0 {
                    let dDayText = "여행 중이에요!"
                    
                    let attributedString = NSMutableAttributedString(string: dDayText)
                    
                    let range = NSRange(location: 0, length: 4)
                    
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(resource: .red500), range: range)
                    self.tripDdayLabel.attributedText = attributedString
                    
                } else {
                    
                    let numText = "\(data.day)"
                    
                    let plusTest = "여행일까지 \(numText)일 남았어요!"
                    
                    let attributedString = NSMutableAttributedString(string: plusTest)
                    
                    let range = NSRange(location: 6, length: numText.count + 1)
                    
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(resource: .red500), range: range)
                    self.tripDdayLabel.attributedText = attributedString
                }
            }
            let splitStartDate = data.startDate.split(separator: ".")
            let newStartDate = "\(splitStartDate[1])월 \(splitStartDate[2])일"
            let splitEndDate = data.endDate.split(separator: ".")
            let newEndDate = "\(splitEndDate[1])월 \(splitEndDate[2])일"
            
            self.tripDateLabel.text = newStartDate + " - " + newEndDate
            
            let string = self.tripDateLabel.text ?? ""
            let date = NSAttributedString(string: " \(string)" )
            let attachImg = NSAttributedString(attachment: tripDateLabelAttachImg)
            tripDateLabel.labelWithImg(composition: attachImg, date)
        }
    }
    
    var myToDoHeaderData: [String]? {
        didSet {
            guard let data = myToDoHeaderData else {return}
            self.tripNameLabel.text = data[0]
            self.tripDdayLabel.text = "나에게 남은 할일 \(data[1])개"
            
            let text = tripDdayLabel.text ?? ""
            let firstString = NSMutableAttributedString(string: text)
            firstString.addAttribute(.foregroundColor, value: UIColor(resource: .gray700), range: (text as NSString).range(of: "나에게 남은 할일"))
            firstString.addAttribute(.foregroundColor, value: UIColor(resource: .red500), range: (text as NSString).range(of: String("\(data[1])개")))
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
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(24))
            $0.top.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        tripDateLabel.snp.makeConstraints{
            $0.height.equalTo(ScreenUtils.getHeight(21))
        }
    }
        
    func setStyle() {
        self.backgroundColor = UIColor(resource: .gray50)
    }
}
