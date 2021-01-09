//
//  MQTTManager.swift
//  qh-net-ios
//
//  Created by 高二豆 on 2021/1/8.
//

import Foundation
import MQTTClient

/// 代理协议
public protocol QHMQTTManagerDelegate: class {
    /// 连接状态已经改变
    func sessionManager(_ sessionManager: MQTTSessionManager!, didChange newState: MQTTSessionManagerState)
    /// 回调消息
    func handleMessage(_ data: Data!, onTopic topic: String!, retained: Bool)
}
/// MQTT 管理器
/// 对 MQTTClient 封装
public class QHMQTTManager: NSObject {
    /// 初始化 QHMQTTManager
    public static let manager = QHMQTTManager()
    
    /// MQTTSessionManager
    private let QHMQTTSessionManager = MQTTSessionManager()
    
    /// 链接代理
    public weak var delegate: QHMQTTManagerDelegate?
    
    /// 是否链接成功
    public var isConnect: Bool {
        switch self.QHMQTTSessionManager.state {
        case .connected:
            return true
        default:
            return false
        }
    }
    /// function_parameter_count
    /// 链接MQTT
    public func connect(
        to host: String?,
        port: Int,
        tls: Bool,
        keepalive: Int,
        clean: Bool,
        auth: Bool,
        user: String?,
        pass: String?,
        will: Bool,
        willTopic: String?,
        willMsg: Data?,
        willQos: MQTTQosLevel,
        willRetainFlag: Bool,
        withClientId: String?,
        securityPolicy: MQTTSSLSecurityPolicy?,
        certificates: [AnyHashable]?,
        protocolLevel: MQTTProtocolVersion,
        connectHandler: @escaping MQTTConnectHandler
    ) {
        self.QHMQTTSessionManager.connect(to: host, port: port, tls: tls, keepalive: keepalive, clean: clean, auth: auth, user: user, pass: pass, will: will, willTopic: willTopic, willMsg: willMsg, willQos: willQos, willRetainFlag: willRetainFlag, withClientId: withClientId, securityPolicy: securityPolicy, certificates: certificates, protocolLevel: protocolLevel, connectHandler: connectHandler)
        self.QHMQTTSessionManager.delegate = self
    }
    /// 断开链接
    public func disconnect() {
        self.QHMQTTSessionManager.disconnect { error in
            print("链接断开: error:", error.debugDescription)
        }
        self.QHMQTTSessionManager.delegate = nil
    }
    /// 发布消息
    func send(_ data: Data?, topic: String?, qos: MQTTQosLevel, retain retainFlag: Bool) {
        self.QHMQTTSessionManager.send(data, topic: topic, qos: qos, retain: retainFlag)
    }
}
/// 代理设置
extension QHMQTTManager: MQTTSessionManagerDelegate {
    public func sessionManager(_ sessionManager: MQTTSessionManager!, didChange newState: MQTTSessionManagerState) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.sessionManager(sessionManager, didChange: newState)
    }
    public func handleMessage(_ data: Data!, onTopic topic: String!, retained: Bool) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.handleMessage(data, onTopic: topic, retained: retained)
    }
}
