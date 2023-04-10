# gitplelive-chat-sdk-ios

### GitpleLive iOS SDK 1.0.2


## 최소 사양

- 사용 환경: iOS 15 이상

- 개발 환경: Xcode 14.3 이상, Swift 5 이상


## 라이브러리 설치 및 사용 방법

- 스위프트 패키지 추가: https://github.com/finset-io/gitplelive-chat-sdk-ios.git

        import GitpleLiveChat


## GitpleLiveChat SDK
 
- Sigleton Access Object: GitpleLiveChat.shared

        GitpleLiveChat.shared.setup(host: "guest.gitplelive.io", appId: "gitple")


### 커넥션 이벤트 델리게이트
    public var connectionEvent: ConnectionDelegate?

### 사용자 이벤트 델리게이트
    public var userEvent: UserDelegate?

### 그룹채널 이벤트 델리게이트
    public var groupChannelEvent: GroupChannelDelegate?
    
### 초기화: 1-1. setup
    public static func setup(host: String, appId: String)

### 초기화: 1-2. reset
    public func reset(host: String, appId: String)
        
### 연결: 2-1. connectUser (사용자 아이디와 세션토큰이 있는 경우)
    public func connectUser(userId: String, token: String)

### 연결: 2-2. connectUser (사용자 아이디 자동 생성)
    public func connectUser(userId: String)

### 연결 해제: 3. disconnectUser
    public func disconnectUser()
    
### 연결 조회: 4. isConnected
    public var isConnected: Bool
    
### 로그아웃: 5. logout (푸시 알림 해제)
    public func logout()
    
### FCM 토큰 설정: 6. setPushToken (푸시 알림 설정)
    public func setPushToken(pushToken: String)


    
    
## 사용자 SDK

- Signleton Access object: GitpleLiveChat.user

        GitpleLiveChat.user.me { user, errorType in
            ...
        }


### 조회: myInfo (내 정보)
    public var myInfo: BaseUser?
    
### 조회: isMemberOf (users에 내가 포함되어 있는지 비교)
    public func isMemberOf(users: [BaseUser]) -> Bool
    
### 조회: isMe (user가 나인지 비교)
    public func isMe(user: BaseUser?) -> Bool
    
### 조회: 1. me
    public func me(completion: ((BaseUser?, Int) -> ())? = nil)

### 수정: 2. updateUser
    public func updateUser(name: String, profile: String, completion: ((BaseUser?, Int) -> ())? = nil)
    
### 메타 데이터 수정: 3. updateMeta
    public func updateMeta(meta: [String:String], completion: ((BaseUser?, Int) -> ())? = nil)
    
### 메타 데이터 삭제: 4. deleteMeta
    public func deleteMeta(keys: [String], completion: ((BaseUser?, Int) -> ())? = nil)



## 그룹 채널 SDK

- Signleton Access object: GitpleLiveChat.groupChannel

        GitpleLiveChat.groupChannel.getChannelList { page, errorType in
            ...
        }
    
    
### 전체 목록: 1-1. getChannelList
    public func getChannelList(completion: ((ChannelPage?, Int) -> ())? = nil)

### 전체 목록: 1-2. getChannelList (filtered)    
    public func getChannelList( limit: Int,
                                showMembers: Bool,
                                showManagers: Bool,
                                showReadReceipt: Bool,
                                showDeliveryReceipt: Bool,
                                showUnread: Bool,
                                showLastMessage: Bool,
                                name: String?,
                                include_members: String?,
                                next: String?,

### 참가한 목록: 2. getJoinedChannelList
    public func getJoinedChannelList( limit: Int = 15,
                                      showMembers: Bool = true,
                                      showManagers: Bool = true,
                                      showReadReceipt: Bool = true,
                                      showDeliveryReceipt: Bool = true,
                                      showUnread: Bool = true,
                                      showLastMessage: Bool = true,
                                      name: String? = nil,
                                      include_members: String? = nil,
                                      next: String? = nil,
                                      completion: ((ChannelPage?, Int) -> ())? = nil)

### 정보: 3. getChannel
    public func getChannel(channelId: String, completion: ((GroupChannel?, Int) -> ())? = nil)

### 생성: 4-1. createChannel
    public func createChannel( channelId: String,
                               name: String,
                               profile: String? = nil,
                               members: [String],
                               reuse: Bool = false,
                               meta: [String:String]? = nil,
                               completion: ((GroupChannel?, Int) -> ())? = nil)

### 생성: 4-2. createChannel (아이디 자동 생성)
    public func createChannel( name: String,
                               profile: String? = nil,
                               members: [String],
                               reuse: Bool = false,
                               meta: [String:String]? = nil,
                               completion: ((GroupChannel?, Int) -> ())? = nil)

### 수정: 5. updateChannel
    public func updateChannel(channelId: String, name: String, profile: String, completion: ((GroupChannel?, Int) -> ())? = nil)

### 삭제: 6. deleteChannel
    public func deleteChannel(channelId: String, completion: ((Bool, Int) -> ())? = nil)
    
### 그룹 채널 참가자 목록: 7. getMemberList
    public func getMemberList(channelId: String, completion: (([BaseUser]?, Int) -> ())? = nil)
    
### 그룹 채널 채널 입장: 8. joinChannel
    public func joinChannel(channelId: String, completion: ((Bool, Int) -> ())? = nil)
    
### 그룹 채널 채널 퇴장: 9. leaveChannel
    public func leaveChannel(channelId: String, completion: ((Bool, Int) -> ())? = nil) 
    
### 그룹 채널 매니저 목록: 10. getManagerList
    public func getManagerList(channelId: String, completion: (([BaseUser]?, Int) -> ())? = nil) 
    
### 룹 채널 매니저 등재: 11. registerManager
    public func registerManager(channelId: String, userId: String, completion: ((Bool, Int) -> ())? = nil)
    
### 그룹 채널 매니저 삭제: 12. deleteManager
    public func deleteManager(channelId: String, userId: String, completion: ((Bool, Int) -> ())? = nil)
    
### 그룹 채널 메시지 읽음 확인 처리(특정 채널): 13. readMessage
    public func readMessage(channelId: String, completion: ((Bool, Int) -> ())? = nil)
    
### 그룹 채널 메시지 읽음 확인 처리(다수 채널 일괄 처리): 14. readMessage
    public func readMessage(channelIds: [String], completion: ((Bool, Int) -> ())? = nil)
    
### 그룹 채널 메시지 수식 확인 처리: 15. deliveredMessage
    public func deliveredMessage(channelId: String, completion: ((Bool, Int) -> ())? = nil)
    
### 그룹 채널 메타 데이터 수정: 16. updateMeta
    public func updateMeta(channelId: String, meta: [String:String], completion: ((GroupChannel?, Int) -> ())? = nil)
    
### 룹 채널 메타 데이터 삭제: 17. deleteMeta
    public func deleteMeta(channelId: String, keys: [String], completion: ((GroupChannel?, Int) -> ())? = nil)
    
### 그룹 채널 활성 사용자 조회: 18. getOnlineMemberList
    public func getOnlineMemberList(channelId: String, completion: (([String]?, Int) -> ())? = nil)
    
### 그룹 채널 중재(채널 동결 / 해제): 19. freezeChannel
    public func freezeChannel(channelId: String, freeze: Bool, completion: ((GroupChannel?, Int) -> ())? = nil) 
    
### 그룹 채널 중재(사용자 금지): 20. ban
    public func ban(channelId: String, userId: String, seconds: Int? = nil, reason: String? = nil, completion: ((BanInfo?, Int) -> ())? = nil)
    
### 그룹 채널 중재(사용자 금지 해제): 21. unban
    public func unban(channelId: String, userId: String, completion: ((Bool, Int) -> ())? = nil)
    
### 그룹 채널 중재(사용자 금지 목록 조회): 22. getBannedList
    public func getBannedList(channelId: String, completion: (([BanInfo]?, Int) -> ())? = nil)



## 그룹 채널 메시지 SDK
    
- Signleton Access object: GitpleLiveChat.groupChannel

        GitpleLiveChat.groupChannel.getMessageList { messages, errorType in
            ...
        }
    

### 그룹 채널 메시지 목록: 1-1. getMessageList
    public func getMessageList(channelId: String, completion: (([BaseMessage]?, Int) -> ())? = nil) 
    
### 룹 채널 메시지 목록: 1-2. getMessageList (filtered)
    public func getMessageList(channelId: String,
                        limit: Int,
                        mode: String,
                        type: String? = nil,
                        content: String? = nil,
                        messageId: Int64,
                        completion: (([BaseMessage]?, Int) -> ())? = nil)
                        
### 그룹 채널 메시지 생성: 2-1. sendMessage (텍스트)
    public func sendMessage(channelId: String, text: String, meta: [String:String]? = nil, completion: ((BaseMessage?, Int) -> ())? = nil)


### 그룹 채널 메시지 생성: 2-2. sendMessage (파일)
    public func sendMessage(channelId: String, file: String, meta: [String:String]? = nil, completion: ((BaseMessage?, Int) -> ())? = nil)
    
### 그룹 채널 메시지 삭제: 3. deleteMessage
    public func deleteMessage(channelId: String, messageId: Int64, completion: ((Bool, Int) -> ())? = nil)
    
### 그룹 채널 메시지 메타 데이터 수정: 4. updateMessageMeta
    public func updateMessageMeta(channelId: String, messageId: Int64, meta: [String:String], completion: ((BaseMessage?, Int) -> ())? = nil)
    
### 그룹 채널 메시지 메타 데이터 삭제: 5. deleteMessageMeta
    public func deleteMessageMeta(channelId: String, messageId: Int64, keys: [String], completion: ((BaseMessage?, Int) -> ())? = nil)



## 커넥션 이벤트 델리게이트

    public protocol ConnectionDelegate {

        func onError(errorType: Int)
        
        func onConnected(status: String)
        
        func onReconnected(status: String)
        
        func onDisconnected(status: String)

    }



## 사용자 이벤트 델리게이트

    public protocol UserDelegate {

        func onUpdate(user: BaseUser)
        
        func onDelete(user: BaseUser)
        
        func onJoined(channel: GroupChannel, user: BaseUser)
        
        func onManager(channel: GroupChannel, user: BaseUser)
        
    }



## 그룹 채널 이벤트 델리게이트

    public protocol GroupChannelDelegate {

        func onUpdated(channel: GroupChannel)
        
        func onDeleted(channel: GroupChannel)
        
        func onJoined(channel: GroupChannel, user: BaseUser)
        
        func onLeft(channel: GroupChannel, user: BaseUser)
        
        func onManagerCreated(channel: GroupChannel, user: BaseUser)
        
        func onManagerDeleted(channel: GroupChannel, user: BaseUser)
        
        func onFrozen(channel: GroupChannel)
        
        func onUnfrozen(channel: GroupChannel)
        
        func onUserBanned(channel: GroupChannel, user: BaseUser, banInfo: BanInfo)
        
        func onUserUnbanned(channel: GroupChannel, user: BaseUser)
        
        func onMessageCreated(channel: GroupChannel, message: BaseMessage)
        
        func onMessageUpdated(channel: GroupChannel, message: BaseMessage)
        
        func onMessageDeleted(channel: GroupChannel, message: BaseMessage)
        
        func onMessageRead(channel: GroupChannel)
        
        func onMessageDelivered(channel: GroupChannel)

    }
