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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let presentingViewController else { return }
        dimmedView.backgroundColor = .black000
        dimmedView.alpha = 0.6
        presentingViewController.view.addSubview(dimmedView)
        
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
