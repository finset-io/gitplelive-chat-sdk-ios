//
//  UserApi.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class UserApi {
    
    var delegate: UserDelegate? {
        get {
            return ChatClient.shared.userEvent
        }
        set(value) {
            ChatClient.shared.userEvent = value
        }
    }
    
    public var sdk = UserSdk()
    public var myInfo: BaseUser?
    
    public func isMemberOf(users: [BaseUser]) -> Bool {
        return users.contains(where: {$0.user_id == myInfo?.user_id})
    }
    
    public func isMe(user: BaseUser?) -> Bool {
        guard let user = user else { return false }
        return user.user_id == myInfo?.user_id
    }
    
    //-----------------------------------------------------------------------
    // 사용자 조회: 1. me
    //-----------------------------------------------------------------------
    public func me(completion: ((BaseUser?, Int) -> ())? = nil) {
        if ChatClient.shared.isNotConnected { return }
        
        sdk.find() { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                self.myInfo = BaseUser.from(json: data)
                completion(self.myInfo, 0)
            }
            else if let error = error {
                if let responseError = ResponseError.from(json: error) {
                    completion(nil, responseError.code)
                }
                else {
                    print("[debug] response error", error)
                    completion(nil, ErrorType.UNKNOWN_ERROR)
                }
            }
            else {
                print("[debug] response error unknow")
                completion(nil, ErrorType.UNKNOWN_ERROR)
            }
        }
    }
    
    //-----------------------------------------------------------------------
    // 사용자 수정: 2. updateUser
    //-----------------------------------------------------------------------
    public func updateUser(name: String, profile: String, completion: ((BaseUser?, Int) -> ())? = nil) {
        if ChatClient.shared.isNotConnected { return }

        sdk.update(name: name, profile: profile) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                self.myInfo = BaseUser.from(json: data)
                completion(self.myInfo, 0)
            }
            else if let error = error {
                if let responseError = ResponseError.from(json: error) {
                    completion(nil, responseError.code)
                }
                else {
                    print("[debug] response error", error)
                    completion(nil, ErrorType.UNKNOWN_ERROR)
                }
            }
            else {
                print("[debug] response error unknow")
                completion(nil, ErrorType.UNKNOWN_ERROR)
            }
        }
    }

    //-----------------------------------------------------------------------
    // 사용자 메타 데이터 수정: 3. updateMeta
    //-----------------------------------------------------------------------
    public func updateMeta(meta: [String:String], completion: ((BaseUser?, Int) -> ())? = nil) {
        if ChatClient.shared.isNotConnected { return }

        sdk.updateMeta(meta: meta) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                self.myInfo = BaseUser.from(json: data)
                completion(self.myInfo, 0)
            }
            else if let error = error {
                if let responseError = ResponseError.from(json: error) {
                    completion(nil, responseError.code)
                }
                else {
                    print("[debug] response error", error)
                    completion(nil, ErrorType.UNKNOWN_ERROR)
                }
            }
            else {
                print("[debug] response error unknow")
                completion(nil, ErrorType.UNKNOWN_ERROR)
            }
        }
    }

    //-----------------------------------------------------------------------
    // 사용자 메타 데이터 삭제: 4. deleteMeta
    //-----------------------------------------------------------------------
    public func deleteMeta(keys: [String], completion: ((BaseUser?, Int) -> ())? = nil) {
        if ChatClient.shared.isNotConnected { return }

        sdk.deleteMeta(keys: keys) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                self.myInfo = BaseUser.from(json: data)
                completion(self.myInfo, 0)
            }
            else if let error = error {
                if let responseError = ResponseError.from(json: error) {
                    completion(nil, responseError.code)
                }
                else {
                    print("[debug] response error", error)
                    completion(nil, ErrorType.UNKNOWN_ERROR)
                }
            }
            else {
                print("[debug] response error unknow")
                completion(nil, ErrorType.UNKNOWN_ERROR)
            }
        }
    }
    
}
