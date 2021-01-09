//
//  ViewController.swift
//  qh-net-ios
//
//  Created by 974929538@qq.com on 01/08/2021.
//  Copyright (c) 2021 974929538@qq.com. All rights reserved.
//

import UIKit
import qh_net_ios
import RxSwift
import Reachability

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var reachability = QHReachability.manager
        reachability.delegate = self
        reachability.startNotifier()
        print(reachability.currentReachabilityStatus ?? "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ViewController: QHReachabilityDelegate {
    func whenReachable(reachability: Reachability) {
        print(reachability.connection.description)
    }
    
    func whenUnreachable(reachability: Reachability) {
        print(reachability.connection.description)
    }
}
