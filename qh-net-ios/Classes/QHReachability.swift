//
//  QHReachability.swift
//  qh-net-ios
//
//  Created by 高二豆 on 2021/1/9.
//

import Foundation
import Reachability
import RxSwift

/// 网络状态变化协议
public protocol QHReachabilityDelegate {
    /// 网络切换
    func whenReachable(reachability: Reachability)
    /// 网络不可用
    func whenUnreachable(reachability: Reachability)
}


public struct QHReachability {
    
    public static let manager = QHReachability()
    
    /// 网络状态变化代理
    public var delegate:QHReachabilityDelegate?
    
    /// 网络状态变化序列
    public let reachabilityObservable = PublishSubject<Reachability>()
    
    /// 网络管理类
    private var reachability: Reachability? {
        do {
            return try Reachability()
        } catch {
            print("Unable to create Reachability")
            return nil
        }
    }
    /// 网络状态 汉字
    public var currentReachabilityStatus: String?{
        guard let reachability = self.reachability else {
            return nil
        }
        switch reachability.connection {
        case .cellular:
            return "蜂窝数据"
        case .unavailable:
            return "无网络链接"
        case .wifi:
            return "Wifi"
        default:
            return "未知网络状态"
        }
    }
    /// 当前网络类型: Reachability.Connection
    public var connection: Reachability.Connection? {
        guard let reachability = self.reachability else {
            return nil
        }
        return reachability.connection
    }
    /// 开始订阅
    public func startNotifier() {
        guard let reachability = self.reachability, let delegate = self.delegate else {
            return
        }
        do {
            try reachability.startNotifier()
            reachability.whenReachable = { reachability in
                reachabilityObservable.onNext(reachability)
                delegate.whenReachable(reachability: reachability)
            }
            reachability.whenUnreachable = { reachability in
                reachabilityObservable.onNext(reachability)
                delegate.whenUnreachable(reachability: reachability)
            }
        } catch {
            print("Unable to start notifier")
        }
    }
}
