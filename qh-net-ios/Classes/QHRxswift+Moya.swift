//
//  QHRxswift+Moya.swift
//  boss-net-ios
//
//  Created by 高炀辉 on 2020/1/2.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
import Alamofire

#if DEBUG
let errorMsg = "解析失败, 请重试"
#else
let errorMsg = "请求失败, 请稍后重试"
#endif

private let disposeBag = DisposeBag()

public extension Reactive where Base: MoyaProviderType {
    
    /**
     拓展将请求序列化
     成功失败都返回成功序列,防止序列返回失败信号时,整个序列停止订阅
     */

    func QHrequest(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Result<Response, QHErrorModel>> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case let .success(response):
                    single(.success(.success(response)))
                case let .failure(error):
                    single(.success(.failure(QHErrorModel(error: error))))
                }
            }
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}
public extension PrimitiveSequence where Trait == SingleTrait, Element == Result<Response, QHErrorModel> {
    /**
     * 只有在返回结果是 {"ok": true} 时使用 不做任何操作 只关心成功失败时
     */
    func mapBool() -> Single<Result<Bool, QHErrorModel>> {
        return flatMap {result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                    let errorModel = QHErrorModel(fromJson: json)
                    if errorModel.isEffective() {
                        return Single.just(.failure(errorModel))
                    }
                    guard let jsonObjecet = json.dictionaryObject else {
                        return Single.just(.failure(.init(zhMessage:
                                                            errorMsg, errCode: 400)))
                    }
                    guard let isok = jsonObjecet["ok"] as? Bool else {
                        return Single.just(.failure(.init(zhMessage:
                                                            errorMsg, errCode: 400)))
                    }
                    return Single.just(.success(isok))
                } catch {
                    return Single.just(.failure(.init(zhMessage:
                                                        errorMsg, errCode: 400)))
                }
            case .failure(let QHErrorModel):
                return Single.just(.failure(QHErrorModel))
            }
        }
    }
    /**
     * 不转换
     */
    func mapSwiftJSON() -> Single<Result<JSON, QHErrorModel>> {
        return flatMap { result in
            switch result {
            case .failure(let errorModel):
                return Single.just(.failure(errorModel))
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                    
                    let errorModel = QHErrorModel(fromJson: json)
                    
                    if errorModel.isEffective() {
                        return Single.just(.failure(errorModel))
                    }
                    return Single.just(.success(json))
                } catch {
                    return Single.just(.failure(QHErrorModel(zhMessage: errorMsg, errCode: 400)))
                }
            }
            
        }
    }
    /**
     * 讲JSON转换成对象
     */
    func mapObject<T: QHModelProtocol>(objectType: T.Type) -> Single<Result<T, QHErrorModel>> {
        
        return flatMap { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                    let object = T(fromJson: json)
                    let errorModel = QHErrorModel(fromJson: json)
                    
                    if errorModel.isEffective() {
                        return Single.just(.failure(errorModel))
                    }
                    return Single.just(.success(object))
                } catch {
                    return Single.just(.failure(QHErrorModel(zhMessage: errorMsg, errCode: 400)))
                }
            case .failure(let QHErrorModel):
                return Single.just(.failure(QHErrorModel))
            }
            
        }
    }
    /**
     * 讲JSON转换成数组
     */
    func mapArray<T: QHModelProtocol>(dataType: T.Type) -> Single<Result<[T], QHErrorModel>> {
        return flatMap { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                    
                    let errorModel = QHErrorModel(fromJson: json)
                    
                    if errorModel.isEffective() {
                        return Single.just(.failure(errorModel))
                    }
                    
                    guard let data = json.dictionary?["data"] else {
                        return Single.just(.failure(QHErrorModel(zhMessage: errorMsg, errCode: 400)))
                    }
                    guard let jsonArray = data.array else {
                        return Single.just(.failure(QHErrorModel(zhMessage: errorMsg, errCode: 400)))
                    }
                    
                    let array = jsonArray.compactMap { T(fromJson: $0) }
                    return Single.just(.success(array))
                } catch {
                    return Single.just(.failure(QHErrorModel(zhMessage: errorMsg, errCode: 400)))
                }
            case .failure(let QHErrorModel):
                return Single.just(.failure(QHErrorModel))
            }
        }
    }
}
