//
//  PopUpDimmedViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/9/24.
//

import UIKit

class PopUpDimmedViewController: UIViewController {
    private let dimmedView = UIView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = .overFullScreen
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGetsture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dimmedView.backgroundColor = UIColor.black000.withAlphaComponent(0.6)
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.dimmedView.alpha = 0.7
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.2) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dimmedView.removeFromSuperview()
        }
    }
}

// MARK: - Private methods

private extension PopUpDimmedViewController {
    /// dimmedView에 탭 제스처 추가
    func setGetsture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
        dimmedView.addGestureRecognizer(tapGesture)
        dimmedView.isUserInteractionEnabled = true
    }
    
    // MARK: - @objc methods
    
    @objc
    func dimmedViewTapped() {
        self.dismiss(animated: false)
    }
}
