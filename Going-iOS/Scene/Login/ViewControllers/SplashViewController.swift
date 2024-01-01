//
//  SplashViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import UIKit

import SnapKit

final class SplashViewController: UIViewController {
    
    private enum Size {
        static let logoHeight: CGFloat = 66 / 194
    }

    private let splashLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.Splash.splashLogo
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()

    }
    
    private func setStyle() {
        self.view.backgroundColor = .red400
    }
    
    private func setHierarchy() {
        view.addSubview(splashLogoImageView)
        
    }
    
    private func setLayout() {
        
        splashLogoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.leading.equalToSuperview().inset(90)
            $0.height.equalTo(splashLogoImageView.snp.width).multipliedBy(Size.logoHeight)
        }
    }

}
