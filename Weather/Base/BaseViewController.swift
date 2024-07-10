//
//  BaseViewController.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.backButtonDisplayMode = .minimal
        configureLayout()
    }
    
    func configureLayout() { }
}
