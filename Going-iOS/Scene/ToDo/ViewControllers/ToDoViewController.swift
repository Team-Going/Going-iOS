import UIKit

import SnapKit

class ToDoViewController: UIViewController {

    // MARK: - UI Components

    private let navigationBarView = {
        let navView = NavigationView()
        navView.titleLabel.text = "할일 추가"
        navView.backButton.addTarget(self, action: #selector(popToOurToDoView), for: .touchUpInside)
        return navView
    }()

    
    // MARK: - Properties
    
    private lazy var navigationBarTitle: String = ""
    private lazy var isActivateView: Bool = true

    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setHierachy()
        setLayout()
        setStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationBarView.backgroundColor = .gray50
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - @objc Methods

    @objc
    func popToOurToDoView() {
        self.navigationController?.popViewController(animated: false)
    }
}

// MARK: - Prviate Methods

private extension ToDoViewController {
    
    func setHierachy() {
        self.view.addSubviews(navigationBarView)

    }
    
    func setLayout() {
        navigationBarView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
//            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(44))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
    }
    
    // TODO: - 할일 조회 일 경우 placeholder 값이 이전에 세팅된 값이어야 함
    
    func setStyle() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white000
    }
    
}

