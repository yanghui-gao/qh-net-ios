import SwiftyJSON

/// 对象协议如果需要自定义map时需要将对象符合此协议
public protocol QHModelProtocol {
    init(fromJson json: JSON!)
}
