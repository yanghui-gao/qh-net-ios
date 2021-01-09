//
//  MQTTManager.swift
//  qh-net-ios
//
//  Created by 高二豆 on 2021/1/8.
//

import Foundation
import MQTTClient
/// MQTT 管理器
/// 对 MQTTClient 封装
public struct QHMQTTManager {
    /// 初始化 QHMQTTManager
    public static let manager = QHMQTTManager()
    
    /// MQTTSessionManager
    private let QHMQTTSessionManager = MQTTSessionManager()
    
    /// 是否链接成功
    public var isConnect: Bool {
        switch self.QHMQTTSessionManager.state {
        case .connected:
            return true
        default:
            return false
        }
        return false
    }
    
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
    }
    /// 断开链接
    public func disconnect() {
//        if self.QHMQTTSessionManager
        self.QHMQTTSessionManager.disconnect { error in
            print("链接断开: error:", error.debugDescription)
        }
        self.QHMQTTSessionManager.delegate = nil
        self.QHMQTTSessionManager = nil
    }
}
