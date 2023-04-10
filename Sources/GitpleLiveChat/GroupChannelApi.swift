//
//  GroupChannelApi.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class GroupChannelApi {
    
    public var delegate: GroupChannelDelegate? {
        get {
            return GitpleLiveChat.shared.groupChannelEvent
        }
        set(value) {
            GitpleLiveChat.shared.groupChannelEvent = value
        }
    }
    
    public var sdk = GroupChannelSdk()
    
    //-----------------------------------------------------------------------
    // 그룹 채널 전체 목록: 1-1. getChannelList
    //-----------------------------------------------------------------------
    public func getChannelList(completion: ((ChannelPage?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.findAll() { data, error in
            guard let completion = completion else { return }
            
            if let data = data, let page = ChannelPage.from(json: data) {
                completion(page, 0)
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
    // 그룹 채널 전체 목록: 1-2. getChannelList (filtered)
    //-----------------------------------------------------------------------
    public func getChannelList(limit: Int,
                        showMembers: Bool,
                        showManagers: Bool,
                        showReadReceipt: Bool,
                        showDeliveryReceipt: Bool,
                        showUnread: Bool,
                        showLastMessage: Bool,
                        name: String?,
                        include_members: String?,
                        next: String?,
                        completion: ((ChannelPage?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.findAll(next: next,
                    limit: limit,
                    showMembers: showMembers,
                    showManagers: showManagers,
                    showReadReceipt: showReadReceipt,
                    showDeliveryReceipt: showDeliveryReceipt,
                    showUnread: showUnread,
                    showLastMessage: showLastMessage,
                    name: name,
                    include_members: include_members) { data, error in
            guard let completion = completion else { return }
                        
            if let data = data, let page = ChannelPage.from(json: data) {
                completion(page, 0)
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
    // 그룹 채널 참가한 목록: 2. getJoinedChannelList
    //-----------------------------------------------------------------------
    public func getJoinedChannelList(limit: Int = 15,
                              showMembers: Bool = true,
                              showManagers: Bool = true,
                              showReadReceipt: Bool = true,
                              showDeliveryReceipt: Bool = true,
                              showUnread: Bool = true,
                              showLastMessage: Bool = true,
                              name: String? = nil,
                              include_members: String? = nil,
                              next: String? = nil,
                              completion: ((ChannelPage?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.findAllJoined( next: next,
                           limit: limit,
                           showMembers: showMembers,
                           showManagers: showManagers,
                           showReadReceipt: showReadReceipt,
                           showDeliveryReceipt: showDeliveryReceipt,
                           showUnread: showUnread,
                           showLastMessage: showLastMessage,
                           name: name,
                           include_members: include_members) { data, error in
            guard let completion = completion else { return }
            
            if let data = data, let page = ChannelPage.from(json: data) {
                completion(page, 0)
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
    // 그룹 채널 정보: 3. getChannel
    //-----------------------------------------------------------------------
    public func getChannel(channelId: String, completion: ((GroupChannel?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.findOne(channelId: channelId) { data, error in
            guard let completion = completion else { return }
            
            if let data = data, let channel = GroupChannel.from(json: data) {
                completion(channel, 0)
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
    // 그룹 채널 생성: 4-1. createChannel
    //-----------------------------------------------------------------------
    public func createChannel(channelId: String,
                       name: String,
                       profile: String? = nil,
                       members: [String],
                       reuse: Bool = false,
                       meta: [String:String]? = nil,
                       completion: ((GroupChannel?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.create( channelId: channelId, name: name, profile: profile, members: members, reuse: reuse, meta: meta) { data, error in
            guard let completion = completion else { return }
            
            if let data = data, let channel = GroupChannel.from(json: data) {
                completion(channel, 0)
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
    // 그룹 채널 생성: 4-2. createChannel (아이디 자동 생성)
    //-----------------------------------------------------------------------
    public func createChannel(name: String,
                       profile: String? = nil,
                       members: [String],
                       reuse: Bool = false,
                       meta: [String:String]? = nil,
                       completion: ((GroupChannel?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        let channelId = "ch_" + Util.randomString(length: 9)

        createChannel(channelId: channelId, name: name, profile: profile, members: members, reuse: reuse, meta: meta, completion: completion)
    }

    //-----------------------------------------------------------------------
    // 그룹 채널 수정: 5. updateChannel
    //-----------------------------------------------------------------------
    public func updateChannel(channelId: String, name: String, profile: String, completion: ((GroupChannel?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.update(channelId: channelId, name: name, profile: profile) { data, error in
            guard let completion = completion else { return }
            
            if let data = data, let channel = GroupChannel.from(json: data) {
                completion(channel, 0)
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
    // 그룹 채널 삭제: 6. deleteChannel
    //-----------------------------------------------------------------------
    public func deleteChannel(channelId: String, completion: ((Bool, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.delete(channelId: channelId) { data, error in
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
    // 그룹 채널 참가자 목록: 7. getMemberList
    //-----------------------------------------------------------------------
    public func getMemberList(channelId: String, completion: (([BaseUser]?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.findMembers(channelId: channelId) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                if let array = data.deserializeToArray {
                    var list = [BaseUser]()
                    array.forEach { dict in
                        if let json = dict.json, let baseUser = BaseUser.from(json: json) {
                            list.append(baseUser)
                        }
                    }
                    completion(list, 0)
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
    // 그룹 채널 채널 입장: 8. joinChannel
    //-----------------------------------------------------------------------
    public func joinChannel(channelId: String, completion: ((Bool, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.join(channelId: channelId) { data, error in
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
    // 그룹 채널 채널 퇴장: 9. leaveChannel
    //-----------------------------------------------------------------------
    public func leaveChannel(channelId: String, completion: ((Bool, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.leave(channelId: channelId) { data, error in
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
    // 그룹 채널 매니저 목록: 10. getManagerList
    //-----------------------------------------------------------------------
    public func getManagerList(channelId: String, completion: (([BaseUser]?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.findManagers(channelId: channelId) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                if let array = data.deserializeToArray {
                    var list = [BaseUser]()
                    array.forEach { dict in
                        if let json = dict.json, let baseUser = BaseUser.from(json: json) {
                            list.append(baseUser)
                        }
                    }
                    completion(list, 0)
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
    // 그룹 채널 매니저 등재: 11. registerManager
    //-----------------------------------------------------------------------
    public func registerManager(channelId: String, userId: String, completion: ((Bool, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.registerManager(channelId: channelId, userId: userId) { data, error in
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
    // 그룹 채널 매니저 삭제: 12. deleteManager
    //-----------------------------------------------------------------------
    public func deleteManager(channelId: String, userId: String, completion: ((Bool, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.unregisterManager(channelId: channelId, userId: userId) { data, error in
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
    // 그룹 채널 메시지 읽음 확인 처리(특정 채널): 13. readMessage
    //-----------------------------------------------------------------------
    public func readMessage(channelId: String, completion: ((Bool, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.read(channelId: channelId) { data, error in
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
    // 그룹 채널 메시지 읽음 확인 처리(다수 채널 일괄 처리): 14. readMessage
    //-----------------------------------------------------------------------
    public func readMessage(channelIds: [String], completion: ((Bool, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        GitpleLiveChat.user.sdk.read(channels: channelIds) { data, error in
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
    // 그룹 채널 메시지 수식 확인 처리: 15. deliveredMessage
    //-----------------------------------------------------------------------
    public func deliveredMessage(channelId: String, completion: ((Bool, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.delivered(channelId: channelId) { data, error in
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
    // 그룹 채널 메타 데이터 수정: 16. updateMeta
    //-----------------------------------------------------------------------
    public func updateMeta(channelId: String, meta: [String:String], completion: ((GroupChannel?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.updateMeta(channelId: channelId, meta: meta) { data, error in
            guard let completion = completion else { return }
            
            if let data = data, let channel = GroupChannel.from(json: data) {
                completion(channel, 0)
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
    // 그룹 채널 메타 데이터 삭제: 17. deleteMeta
    //-----------------------------------------------------------------------
    public func deleteMeta(channelId: String, keys: [String], completion: ((GroupChannel?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.deleteMeta(channelId: channelId, keys: keys) { data, error in
            guard let completion = completion else { return }
            
            if let data = data, let channel = GroupChannel.from(json: data) {
                completion(channel, 0)
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
    // 그룹 채널 활성 사용자 조회: 18. getOnlineMemberList
    //-----------------------------------------------------------------------
    public func getOnlineMemberList(channelId: String, completion: (([String]?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.findOnlineMembers(channelId: channelId) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                if let array = Util.array(from: data) {
                    completion(array, 0)
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
    // 그룹 채널 중재(채널 동결 / 해제): 19. freezeChannel
    //-----------------------------------------------------------------------
    public func freezeChannel(channelId: String, freeze: Bool, completion: ((GroupChannel?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.freeze(channelId: channelId, freeze: freeze) { data, error in
            guard let completion = completion else { return }
            
            if let data = data, let channel = GroupChannel.from(json: data) {
                completion(channel, 0)
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
    // 그룹 채널 중재(사용자 금지): 20. ban
    //-----------------------------------------------------------------------
    public func ban(channelId: String, userId: String, seconds: Int? = nil, reason: String? = nil, completion: ((BanInfo?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.ban(channelId: channelId, userId: userId, seconds: seconds, reason: reason) { data, error in
            guard let completion = completion else { return }
            
            if let data = data, let banInfo = BanInfo.from(json: data) {
                completion(banInfo, 0)
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
    // 그룹 채널 중재(사용자 금지 해제): 21. unban
    //-----------------------------------------------------------------------
    public func unban(channelId: String, userId: String, completion: ((Bool, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.unban(channelId: channelId, userId: userId) { data, error in
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
    // 그룹 채널 중재(사용자 금지 목록 조회): 22. getBannedList
    //-----------------------------------------------------------------------
    public func getBannedList(channelId: String, completion: (([BanInfo]?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk.findBanList(channelId: channelId) { data, error in
            guard let completion = completion else { return }
            
            if let data = data {
                if let array = data.deserializeToArray {
                    var list = [BanInfo]()
                    array.forEach { dict in
                        if let json = dict.json, let baseUser = BanInfo.from(json: json) {
                            list.append(baseUser)
                        }
                    }
                    completion(list, 0)
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
    
    public var sdk2 = GroupChannelMessageSdk()
    
    //-----------------------------------------------------------------------
    // 그룹 채널 메시지 목록: 1-1. getMessageList
    //-----------------------------------------------------------------------
    public func getMessageList(channelId: String, completion: (([BaseMessage]?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk2.get(channelId: channelId, messageId: 0, mode: nil, type: nil, limit: 0, content: nil) { data, error in
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
    public func getMessageList(channelId: String,
                        limit: Int,
                        mode: String,
                        type: String? = nil,
                        content: String? = nil,
                        messageId: Int64,
                        completion: (([BaseMessage]?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk2.get(channelId: channelId, messageId: messageId, mode: mode, type: type, limit: limit, content: content) { data, error in
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
    public func sendMessage(channelId: String, text: String, meta: [String:String]? = nil, completion: ((BaseMessage?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk2.create(channelId: channelId, type: "text", content: text, meta: meta) { data, error in
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
    public func sendMessage(channelId: String, file: String, meta: [String:String]? = nil, completion: ((BaseMessage?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        let url = sdk2.url_group_channels + channelId + "/messages"
        
        NetworkHelper.upload(url: url, fileName: file, headers: GitpleLiveChat.shared.headers) { data, error in
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
    public func deleteMessage(channelId: String, messageId: Int64, completion: ((Bool, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk2.delete(channelId: channelId, messageId: messageId) { data, error in
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
    public func updateMessageMeta(channelId: String, messageId: Int64, meta: [String:String], completion: ((BaseMessage?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk2.updateMeta(channelId: channelId, messageId: messageId, meta: meta) { data, error in
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
    public func deleteMessageMeta(channelId: String, messageId: Int64, keys: [String], completion: ((BaseMessage?, Int) -> ())? = nil) {
        if GitpleLiveChat.shared.isNotConnected { return }

        sdk2.deleteMeta(channelId: channelId, messageId: messageId, keys: keys) { data, error in
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
