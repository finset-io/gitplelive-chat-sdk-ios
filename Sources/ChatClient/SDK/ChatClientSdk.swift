//
//  ChatClientSdk.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation
import MQTTNIO

class ChatClientSdk: NSObject {
    
    private let VERSION = "v1.0.0"
    private let OS = "ios"
    
    public var host: String!
    public var appId: String!
    public var userId: String!
    public var headers = [String:String]()
    
    private var mqttClient: MQTTClient?
    private var connected = false
    private let topicPrefix = "mqtt/topic/gitple/live"
    
    private var userSdk = UserSdk()
    private var groupChannelSdk = GroupChannelSdk()
    private var groupChannelMessageSdk = GroupChannelMessageSdk()
    private var tokenInfo: TokenInfo!
    private var pushToken: String?
    
    var connectionEvent: ConnectionDelegate?
    var userEvent: UserDelegate?
    var groupChannelEvent: GroupChannelDelegate?
        
    var isConnected: Bool {
        return mqttClient != nil && connected
    }

    var isNotConnected: Bool {
        if mqttClient == nil || !connected {
            connectionEvent?.onError(errorType: ErrorType.NOT_CONNECTED)
            return true
        }
        return false
    }
    
    var newPushToken: String? {
        if let pushToken = pushToken, pushToken == Util.load("new_push_token")  {
            return nil
        }
        else {
            pushToken = Util.load("new_push_token")
            return pushToken
        }
    }
    
    private func setHeader(appId: String? = nil, userId: String? = nil, token: String? = nil) {
        if let appId = appId {
            headers["APP_ID"] = appId
        }
        if let userId = userId {
            headers["USER_ID"] = userId
        }
        if let token = token {
            headers["Authorization"] = "Bearer " + token
        }
    }

    func logout() {
        guard let mqttClient = mqttClient else { return }
        
        userSdk.deleteDeviceToken(clientId: mqttClient.configuration.clientId) { data, error in
            print("[debug] deleteDeviceToken", data ?? "", error ?? "")
        }
    }
    
    //-----------------------------------------------------------------------
    // API: 1-1. 초기화
    //-----------------------------------------------------------------------
    init(host: String, appId: String) {
        self.host = host
        self.appId = appId
    }
    
    //-----------------------------------------------------------------------
    // API: 1-2. 초기화
    //-----------------------------------------------------------------------
    func reset(host: String, appId: String) {
        self.host = host
        self.appId = appId
        self.pushToken = nil
    }
    
    //-----------------------------------------------------------------------
    // API: 2-3. 초기화
    //-----------------------------------------------------------------------
    func setPushToken(pushToken: String) {
        Util.save("new_push_token", pushToken)
    }
    
    //-----------------------------------------------------------------------
    // API: 2-1. 서버접속
    //-----------------------------------------------------------------------
    func connectUser(userId: String, token: String) {
        if (!Util.isNetwork) {
            connectionEvent?.onError(errorType: ErrorType.UNABLE_CONNECT_ERROR)
            return
        }
        if (mqttClient != nil) {
            return
        }
        self.userId = userId
        self.setHeader(appId: appId, userId: userId, token: token)
        
        let jwt = JWT()
        if jwt.decode(jwtToken: token)["user_id"] == nil {
            connectionEvent?.onError(errorType: ErrorType.INVALID_TOKEN)
            return
        }
        print("[debug] sessionToken:", jwt.decode(jwtToken: token))
        
        userSdk.refreshToken() { data, error in
            if let data = data, let tokenInfo = TokenInfo.from(json: data) {
                self.setToken(tokenInfo: tokenInfo)
                self.connect()
            }
            else if let error = error, let responseError = ResponseError.from(json: error) {
                self.connectionEvent?.onError(errorType: responseError.code)
            }
            else {
                self.connectionEvent?.onError(errorType: ErrorType.UNKNOWN_ERROR)
            }
        }
    }
    
    //-----------------------------------------------------------------------
    // API: 2-2. 서버접속
    //-----------------------------------------------------------------------
    func connectUser(userId: String) {
        if (!Util.isNetwork) {
            connectionEvent?.onError(errorType: ErrorType.UNABLE_CONNECT_ERROR)
            return
        }
        if (mqttClient != nil) {
            return
        }
        self.userId = userId
        self.setHeader(appId: appId, userId: userId)
        self.connect()
    }
    
    //-----------------------------------------------------------------------
    // API: 3. 접속해제
    //-----------------------------------------------------------------------
    func disconnectUser() {
        if let mqttClient = mqttClient {
            mqttClient.disconnect()
        }
        mqttClient = nil
        tokenInfo = nil
        connected = false
    }
    
    private func getServerUrl(host: String) -> URL? {
        if let url = URL(string: "wss://\(host)/ws") {
            print("[debug] ChatClientSDK serverUrl =", url)
            return url
        }
        return nil
    }
    
    private func getClientId(address: String) -> String {
        let date = Date.currentTimeStamp
        let clientId = "\(appId!)::\(userId!)::\(VERSION)::\(date)::\(address)::\(OS)::\(DeviceInfo.deviceId)"
        print("[debug] ChatClientSDK clientId =", clientId)
        return clientId
    }
    
    private func connect() {
        getHealth() { reponse, error in
            if let reponse = reponse {
                self.connect(address: reponse)
            }
            else {
                print("[debug] connectUser error", error ?? "N/A")
            }
        }
    }
    
    //-----------------------------------------------------------------------
    // 내부용: 1. 서버 상태 확인 및 Client IP 조회용
    //-----------------------------------------------------------------------
    private func getHealth(completion: @escaping (String?, String?) -> ()) {
        let url = "https://" + host + "/health"

        NetworkHelper.getRequest(url: url, headers: nil) { data, error in
            if let data = data {
                completion(data, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
            else {
                completion(nil, "N/A")
            }
        }
    }

    private func connect(address: String) {
        guard let url = getServerUrl(host: host) else { return }
        let clientId = getClientId(address: address)
        mqttClient = MQTTClient(configuration: MQTTConfiguration(url: url, clientId: clientId))
        
        guard let mqttClient = mqttClient else { return }
        
        mqttClient.configuration.protocolVersion = .version3_1_1
        mqttClient.configuration.clean = true
        mqttClient.configuration.keepAliveInterval = .seconds(30)
        mqttClient.configuration.reconnectMode = .retry(minimumDelay: .seconds(5), maximumDelay: .seconds(5))
        mqttClient.configuration.connectionTimeoutInterval = .seconds(3)
        mqttClient.configuration.credentials = MQTTConfiguration.Credentials(username: userId, password: tokenInfo?.token)
        mqttClient.connect()
        
        mqttClient.whenConnected { response in
            print("[debug] MQTT whenConnected isSessionPresent: \(response.isSessionPresent)")
            
            self.connected = true
            
            if response.isSessionPresent {
                DispatchQueue.main.async {
                    self.connectionEvent?.onReconnected(status: "success")
                }
            }
            else if self.tokenInfo != nil {
                self.onConnect()
            }
            else {
                self.getToken()
            }
        }
        
        mqttClient.whenConnectionFailure { reason in
            print("[debug] MQTT ConnectionFailure: \(reason)")
            if "\(reason)".contains("badUsernameOrPassword") {

                self.disconnectUser()

                DispatchQueue.main.async {
                    self.connectionEvent?.onError(errorType: ErrorType.INVALID_TOKEN)
                }
            }
        }
        
        mqttClient.whenDisconnected { reason in
            print("[debug] MQTT Disconnected: \(reason)")
            
            self.connected = false
            
            DispatchQueue.main.async {
                self.connectionEvent?.onDisconnected(status: "\(reason)")
            }
        }
        
        mqttClient.whenMessage { message in
            guard let json = message.payload.string, let payload = MessagePayload.from(json: json) else {
                print("[debug] MQTT Message: \(message.topic) payload parsing error")
                return
            }
            print("[debug] MQTT Message: \(message.topic)\n", payload.category, payload.json)
            DispatchQueue.main.async {
                self.parsePayload(payload)
            }
        }
    }
    
    private func getToken() {
        userSdk.generateTokenBySession(clientId: mqttClient!.configuration.clientId) { response, error in
            if let response = response, let tokenInfo = TokenInfo.from(json: response) {
                self.setToken(tokenInfo: tokenInfo)
                self.onConnect()
            }
            else {
                print(error ?? "N/A")
            }
        }
    }
    
    private func setToken(tokenInfo: TokenInfo) {
        self.tokenInfo = tokenInfo
        setHeader(token: tokenInfo.token)
        Timer.scheduledTimer(withTimeInterval: 2 * 60 * 60, repeats: false) { timer in self.refreshToken() }
    }
    
    private func refreshToken() {
        userSdk.refreshToken() { data, error in
            if let data = data, let tokenInfo = TokenInfo.from(json: data) {
                self.setToken(tokenInfo: tokenInfo)
            }
            else if let error = error, let responseError = ResponseError.from(json: error) {
                self.connectionEvent?.onError(errorType: responseError.code)
            }
            else {
                self.connectionEvent?.onError(errorType: ErrorType.UNKNOWN_ERROR)
            }
        }
    }
    
    func onConnect() {
        ChatClient.user.me() { user, errorType in
            if errorType > 0 {
                print(ErrorType.message(errorType: errorType))
            }
            else if let pushToken = self.newPushToken {
                self.registerDeviceToken(pushToken: pushToken)
            }
            else {
                self.findAllJoined()
            }
        }
    }
    
    func registerDeviceToken(pushToken: String) {
        userSdk.registerDeviceToken(clientId: mqttClient!.configuration.clientId, pushToken: pushToken) { data, error in
            if let error = error {
                print("[debug] registerDeviceToken error:", error)
                self.connectionEvent?.onConnected(status: "failed")
            }
            else {
                self.findAllJoined()
            }
        }
    }

    func findAllJoined() {
        ChatClient.shared.groupChannelSdk.findAllJoined() { data, error in
            if let data = data {
                if let page = ChannelPage.from(json: data) {
                    self.subscribe(channels: page.channels)
                }
            }
            else {
                print("[debug] findAllJoined error: \(error ?? "")")
                self.connectionEvent?.onConnected(status: "failed")
            }
        }
    }
    
    func subscribe(channels: [GroupChannel]) {
        var topics = [String]()
        
        // 사용자 이벤트 수신용 토픽
        topics.append("\(topicPrefix)/\(appId!)/user/all/\(userId!)/#")
        
        channels.forEach() { channel in
            let topic = "\(topicPrefix)/\(appId!)/channel/\(channel.type)/\(channel.channel_id)"
            
            // 참가자 권한 채널 이벤트 수신용 토픽
            topics.append(topic + "/all/#")
            
            if let managers = channel.managers, ChatClient.user.isMemberOf(users: managers) {
                // 매니저 권한 채널 이벤트 수신용 토픽
                topics.append(topic + "/manager/#")
            }
        }
        
        topics.forEach() { topic in
            mqttClient!.subscribe(to: topic).whenSuccess { response in
                print("[debug] MQTT subscribe", "\(response.result)".split("(")[0], topic)
            }
        }
        
        connectionEvent?.onConnected(status: "success")
    }
    
    func subscribe(_ channel: GroupChannel, _ user: String) {
        let topic = "\(topicPrefix)/\(appId!)/channel/\(channel.type)/\(channel.channel_id)/\(user)/#"
        
        mqttClient!.subscribe(to: topic).whenSuccess { response in
            print("[debug] MQTT subscribe", "\(response.result)".split("(")[0], topic)
        }
    }
    
    func unsubscribe(_ channel: GroupChannel, _ user: String) {
        let topic = "\(topicPrefix)/\(appId!)/channel/\(channel.type)/\(channel.channel_id)/\(user)/#"
        
        mqttClient!.unsubscribe(from: topic).whenSuccess { response in
            print("[debug] MQTT unsubscribe", "\(response.result)".split("(")[0], topic)
        }
    }
    
    func parsePayload(_ payload: MessagePayload) {
        switch (payload.category) {
        case "user_update":
            userEvent?.onUpdate(user: payload.user!)
            break
            
        case "user_delete":
            userEvent?.onDelete(user: payload.user!)
            if ChatClient.user.isMe(user: payload.user!) {
                connectionEvent?.onDisconnected(status: "user_delete")
                disconnectUser()
            }
            break
            
        case "user_joined_channel":
            if ChatClient.user.isMe(user: payload.user!) {
                subscribe(payload.channel!, "all")
            }
            userEvent?.onJoined(channel: payload.channel!, user: payload.user!)
            break
            
        case "user_become_manager":
            if ChatClient.user.isMe(user: payload.user!) {
                subscribe(payload.channel!, "all")
                subscribe(payload.channel!, "manager")
            }
            userEvent?.onManager(channel: payload.channel!, user: payload.user!)
            break
            
        case "group:channel_update":
            groupChannelEvent?.onUpdated(channel: payload.channel!)
            break
            
        case "group:channel_delete":
            unsubscribe(payload.channel!, "all")
            unsubscribe(payload.channel!, "manager")
            groupChannelEvent?.onDeleted(channel: payload.channel!)
            break
            
        case "group:channel_join":
            if ChatClient.user.isMe(user: payload.user!) {
                subscribe(payload.channel!, "all")
            }
            groupChannelEvent?.onJoined(channel: payload.channel!, user: payload.user!)
            break
            
        case "group:channel_leave":
            if ChatClient.user.isMe(user: payload.user!) {
                unsubscribe(payload.channel!, "all")
                unsubscribe(payload.channel!, "manager")
            }
            groupChannelEvent?.onLeft(channel: payload.channel!, user: payload.user!)
            break
            
        case "group:channel_manager_create":
            if ChatClient.user.isMe(user: payload.user!) {
                subscribe(payload.channel!, "all")
                subscribe(payload.channel!, "manager")
            }
            groupChannelEvent?.onManagerCreated(channel: payload.channel!, user: payload.user!)
            break
            
        case "group:channel_manager_delete":
            if ChatClient.user.isMe(user: payload.user!) {
                unsubscribe(payload.channel!, "manager")
            }
            groupChannelEvent?.onManagerDeleted(channel: payload.channel!, user: payload.user!)
            break
            
        case "group:channel_freeze":
            groupChannelEvent?.onFrozen(channel: payload.channel!)
            break
            
        case "group:channel_unfreeze":
            groupChannelEvent?.onUnfrozen(channel: payload.channel!)
            break
            
        case "group:channel_ban":
            if ChatClient.user.isMe(user: payload.user!) {
                unsubscribe(payload.channel!, "all")
                unsubscribe(payload.channel!, "manager")
            }
            groupChannelEvent?.onUserBanned(channel: payload.channel!, user: payload.user!, banInfo: payload.banInfo!)
            break
            
        case "group:channel_unban":
            groupChannelEvent?.onUserUnbanned(channel: payload.channel!, user: payload.user!)
            break
            
        case "group:message_send":
            groupChannelEvent?.onMessageCreated(channel: payload.channel!, message: payload.message!)
            break
            
        case "group:message_update":
            groupChannelEvent?.onMessageUpdated(channel: payload.channel!, message: payload.message!)
            break
            
        case "group:message_delete":
            groupChannelEvent?.onMessageDeleted(channel: payload.channel!, message: payload.message!)
            break
            
        case "group:channel_message_read_event":
            groupChannelEvent?.onMessageRead(channel: payload.channel!)
            break
            
        case "group:channel_message_delivered_event":
            groupChannelEvent?.onMessageDelivered(channel: payload.channel!)
            break
            
        default:
            print("[debug] parsePayload: Unknown payload")
        }
    }
    
}
