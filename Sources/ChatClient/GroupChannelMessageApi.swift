//
//  GroupChannelMessageApi.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

class GroupChannelMessageApi {
    
    private var sdk = GroupChannelMessageSdk()
    
    //-----------------------------------------------------------------------
    // 그룹 채널 메시지 목록: 1-1. getMessageList
    //-----------------------------------------------------------------------
    func getMessageList(channelId: String, completion: (([BaseMessage]?, Int) -> ())? = nil) {
        if ChatClient.shared.isNotConnected { return }

        sdk.get(channelId: channelId, messageId: 0, mode: nil, type: nil, limit: 0, content: nil) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                if let page = MessagePage.from(json: data) {
                    completion(page.messages, 0)
                }
                else {
                    print("[debug] response error unknow")
                    completion(nil, ErrorType.UNKNOWN_ERROR)
                }
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
    // 그룹 채널 메시지 목록: 1-2. getMessageList (filtered)
    //-----------------------------------------------------------------------
    func getMessageList(channelId: String,
                        limit: Int,
                        mode: String,
                        type: String? = nil,
                        content: String? = nil,
                        messageId: Int64,
                        completion: (([BaseMessage]?, Int) -> ())? = nil) {
        if ChatClient.shared.isNotConnected { return }

        sdk.get(channelId: channelId, messageId: messageId, mode: mode, type: type, limit: limit, content: content) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                if let page = MessagePage.from(json: data) {
                    completion(page.messages, 0)
                }
                else {
                    print("[debug] response error unknow")
                    completion(nil, ErrorType.UNKNOWN_ERROR)
                }
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
    // 그룹 채널 메시지 생성: 2-1. sendMessage (텍스트)
    //-----------------------------------------------------------------------
    func sendMessage(channelId: String, text: String, meta: [String:String]? = nil, completion: ((BaseMessage?, Int) -> ())? = nil) {
        if ChatClient.shared.isNotConnected { return }

        sdk.create(channelId: channelId, type: "text", content: text, meta: meta) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                completion(BaseMessage.from(json: data), 0)
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
    // 그룹 채널 메시지 생성: 2-2. sendMessage (파일)
    //-----------------------------------------------------------------------
    func sendMessage(channelId: String, file: String, meta: [String:String]? = nil, completion: ((BaseMessage?, Int) -> ())? = nil) {
        if ChatClient.shared.isNotConnected { return }

        let url = sdk.url_group_channels + channelId + "/messages"
        
        NetworkHelper.upload(url: url, fileName: file, headers: ChatClient.shared.headers) { data, error in
            if let data = data, let message = BaseMessage.from(json: data), let meta = meta {
                self.updateMessageMeta(channelId: channelId, messageId: message.message_id, meta: meta, completion: completion)
            }
            guard let completion = completion else { return }
            
            if let data = data, let message = BaseMessage.from(json: data) {
                completion(message, 0)
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
    // 그룹 채널 메시지 삭제: 3. deleteMessage
    //-----------------------------------------------------------------------
    func deleteMessage(channelId: String, messageId: Int64, completion: ((Bool, Int) -> ())? = nil) {
        if ChatClient.shared.isNotConnected { return }

        sdk.delete(channelId: channelId, messageId: messageId) { data, error in
            guard let completion = completion else { return }
            
            if let error = error {
                if let responseError = ResponseError.from(json: error) {
                    completion(false, responseError.code)
                }
                else {
                    print("[debug] response error", error)
                    completion(false, ErrorType.UNKNOWN_ERROR)
                }
            }
            else {
                completion(true, 0)
            }
        }
    }

    //-----------------------------------------------------------------------
    // 그룹 채널 메시지 메타 데이터 수정: 4. updateMessageMeta
    //-----------------------------------------------------------------------
    func updateMessageMeta(channelId: String, messageId: Int64, meta: [String:String], completion: ((BaseMessage?, Int) -> ())? = nil) {
        if ChatClient.shared.isNotConnected { return }

        sdk.updateMeta(channelId: channelId, messageId: messageId, meta: meta) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                completion(BaseMessage.from(json: data), 0)
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
    // 그룹 채널 메시지 메타 데이터 삭제: 5. deleteMessageMeta
    //-----------------------------------------------------------------------
    func deleteMessageMeta(channelId: String, messageId: Int64, keys: [String], completion: ((BaseMessage?, Int) -> ())? = nil) {
        if ChatClient.shared.isNotConnected { return }

        sdk.deleteMeta(channelId: channelId, messageId: messageId, keys: keys) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                completion(BaseMessage.from(json: data), 0)
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
