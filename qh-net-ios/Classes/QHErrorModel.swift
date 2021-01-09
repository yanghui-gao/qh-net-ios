//
//	ErrorModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

/// 趣活统一错误模型
/// - errCode 错误码 后端返回错误码
/// - domain 错误信息 处理系统错误时处理
/// - UserInfo 错误信息 处理Error类型时存在
/// - zhMessage 后端返回错误信息 后端返回
public class QHErrorModel: NSObject, NSCoding, Error {

	public var errCode: Int!
	public var domain: String!
    public var userInfo: [String: Any]!
	public var zhMessage: String!
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	public init(fromJson json: JSON!) {
		if json.isEmpty {
			return
		}
		errCode = json["err_code"].intValue
		domain = json["err_name"].stringValue
		zhMessage = json["zh_message"].stringValue
	}
    
    public init(errCode: Int?, domain: String?, userInfo: [String: Any]?, zhMessage: String?) {

        self.errCode = errCode ?? 0
        self.domain = domain ?? ""
        self.userInfo = userInfo ?? [:]
        self.zhMessage = zhMessage ?? ""
    }
    
    public init(zhMessage: String?, errCode: Int? = 400) {

        self.errCode = errCode 
        self.domain = ""
        self.userInfo = [:]
        self.zhMessage = zhMessage ?? ""
    }

    public init(error: Error) {

        let nserr = error as NSError
        self.errCode = nserr.code
        self.domain = nserr.domain
        self.userInfo = nserr.userInfo
        self.zhMessage = nserr.localizedDescription
    }
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	public func toDictionary() -> [String: Any] {
		var dictionary = [String: Any]()
		if errCode != nil {
			dictionary["err_code"] = errCode
		}
		if domain != nil {
			dictionary["err_name"] = domain
		}
		if zhMessage != nil {
			dictionary["zh_message"] = zhMessage
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc public required init(coder aDecoder: NSCoder) {
         errCode = aDecoder.decodeObject(forKey: "err_code") as? Int
         domain = aDecoder.decodeObject(forKey: "err_name") as? String
         zhMessage = aDecoder.decodeObject(forKey: "zh_message") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    public func encode(with aCoder: NSCoder) {
		if errCode != nil {
			aCoder.encode(errCode, forKey: "err_code")
		}
		if domain != nil {
			aCoder.encode(domain, forKey: "err_name")
		}
		if zhMessage != nil {
			aCoder.encode(zhMessage, forKey: "zh_message")
		}

	}

}

extension QHErrorModel {
    /// 错误模型是否有效 有效则表示出错
    /// - Returns: 是否有效 true 出错 false 无效没有出错
    public func isEffective() -> Bool {
        if self.errCode != nil && !self.zhMessage.isEmpty {
            return true
        }
        return false
    }
}
