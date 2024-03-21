import UIKit

import SnapKit

final class ToDoManagerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ToDoManagerCollectionViewCell"
    
    // MARK: - UI Components
    
    lazy var managerButton: UIButton = {
        let btn = UIButton()
        btn.isSelected = false
        btn.titleLabel?.font = .pretendard(.detail2_regular)
        btn.setTitleColor(UIColor(resource: .gray300), for: .normal)
        btn.backgroundColor = UIColor(resource: .white000)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor(resource: .gray300).cgColor
        btn.layer.cornerRadius = 4
        return btn
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

}

// MARK: - Private Method

private extension ToDoManagerCollectionViewCell {
    
    func setHierarchy() {
        contentView.addSubview(managerButton)
    }
    
    func setLayout() {
        managerButton.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}

