import UIKit

class ManagerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let identifier = "ManagerCollectionViewCell"
    
    lazy var isEmpty: Bool = false

    var managerData: String? {
        didSet {
            guard let managerData = managerData else {return}
            self.isEmpty = managerData == StringLiterals.OurToDo.emptyAllocator ? true : false
            if self.isEmpty {
                self.managerLabel.isHidden = true
                self.emptyManagerLabel.isHidden = false
                self.emptyManagerLabel.text = managerData
                setLabelWithImage(label: self.emptyManagerLabel, string: managerData)
            } else {
                self.managerLabel.isHidden = false
                self.emptyManagerLabel.isHidden = true
                self.managerLabel.text = managerData
            }
        }
    }
    
    // MARK: - UI Properties
    
    var managerLabel: UILabel = {
        let label = DOOLabel(font: .pretendard(.detail2_regular), color: .clear, alignment: .center)
        label.backgroundColor = UIColor(resource: .gray50)
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 0.75
        label.layer.borderColor = UIColor(resource: .gray400).cgColor
        return label
    }()
    
    lazy var emptyManagerLabel: UILabel = {
        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let label = DOOLabel(font: .pretendard(.detail2_regular), color: UIColor(resource: .gray300), alignment: .center, padding: padding)
        label.clipsToBounds = true
        label.backgroundColor = UIColor(resource: .gray100)
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 0.75
        label.layer.borderColor = UIColor.clear.cgColor
        
        return label
    }()

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeLabelColor(color: UIColor) {
        managerLabel.textColor = color
        managerLabel.layer.borderColor = color.cgColor
    }
    
    func setLabelWithImage(label: UILabel, string: String) {
        
        let imageAttachment = NSTextAttachment(image: UIImage(resource: .icTagEmpty))
        // 이미지와 라벨 수직 정렬 맞춰주기
        imageAttachment.bounds = CGRect(x: 0, y: ScreenUtils.getHeight(-1), width: UIImage(resource: .icTagEmpty).size.width , height: UIImage(resource: .icTagEmpty).size.height)
        
        self.emptyManagerLabel.labelWithImg(composition: NSAttributedString(attachment: imageAttachment), NSAttributedString(string: " \(string)"))
    }
    
}

// MARK: - Private Method

private extension ManagerCollectionViewCell {
    
    func setHierarchy() {
        contentView.addSubviews(emptyManagerLabel, managerLabel)
    }
    
    func setLayout() {
       emptyManagerLabel.snp.makeConstraints{
           $0.edges.equalToSuperview()
        }
        
        managerLabel.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}


