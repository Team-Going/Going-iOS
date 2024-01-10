import UIKit

class ManagerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let identifier = "ManagerCollectionViewCell"
    var manager: [String] = []
    var managerData: String? {
        didSet {
            guard let managerData = managerData else {return}
            self.managerLabel.text = managerData
        }
    }
    
    // MARK: - UI Properties
    
    var managerLabel: UILabel = {
        let label = DOOLabel(font: .pretendard(.detail2_regular), color: .clear, alignment: .center)
        label.backgroundColor = UIColor.gray50
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 0.75
        label.layer.borderColor = UIColor.gray400.cgColor
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
}

// MARK: - Private Method

private extension ManagerCollectionViewCell {
    
    func setHierarchy() {
        contentView.addSubview(managerLabel)
    }
    
    func setLayout() {
        managerLabel.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}


