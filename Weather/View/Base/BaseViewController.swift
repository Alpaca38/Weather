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
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .white
        configureLayout()
    }
    
    func configureLayout() { }
}
