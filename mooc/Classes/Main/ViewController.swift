//
//  ViewController.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/10.
//  Copyright © 2020 kilomind. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate lazy var btn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        btn.setTitle("朋友圈", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(btn)
    }

}
extension ViewController {
    @objc func click() {
        let vc = MomentsVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

