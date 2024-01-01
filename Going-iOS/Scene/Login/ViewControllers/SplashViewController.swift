//
//  SplashViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import UIKit

import SnapKit

final class SplashViewController: UIViewController {
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.font = .pretendard(.detail3_regular)
        label.textColor = .white000
        return label
    }()

    private let testImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.Splash.splashLogo
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()

    }
    
    private func setHierarchy() {
        view.addSubview(testLabel)
        
    }
    
    private func setLayout() {
        testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        
    }

}
