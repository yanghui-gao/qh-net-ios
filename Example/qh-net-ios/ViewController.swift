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

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let reachability = QHReachability.manager
        reachability.startNotifier()
        print(reachability.currentReachabilityStatus ?? "")
        
        reachability.reachabilityObservable.subscribe(onNext: { res in
            print(res.connection.description)
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

