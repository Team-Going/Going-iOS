//
//  ViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 12/21/23.
//

import UIKit

import SnapKit

final class ViewController: UIViewController {

    let viewtest = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewtest.backgroundColor = .systemBlue
        self.view.addSubview(viewtest)
        
        viewtest.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    
        
    }


}

