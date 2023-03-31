//
//  FileUpload.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation
import Alamofire

extension NetworkHelper {

    static func upload(url: String, fileName: String, headers: [String:String]?, completion: @escaping (String?, String?) -> ()) {
        if !FileHelper.fileExists(fileName: fileName) {
            completion(nil, "\(fileName) not exit")
            return
        }
        print("[debug] upload(\(url), \(fileName))")
        
        let url = URL(string: url)!
        let data = Data(fileName: fileName)
        let headers: HTTPHeaders = [
            "APP_ID": headers?["APP_ID"] ?? "",
            "USER_ID": headers?["USER_ID"] ?? "",
            "Authorization": headers?["Authorization"] ?? "",
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append("file".data(using: .utf8)!, withName: "type")
                multipartFormData.append(data, withName: "file", fileName: fileName, mimeType: "*/*")
            },
            to: url,
            usingThreshold: UInt64.init(),
            method: .post,
            headers: headers)
        .response { response in
            if let statusCode = response.response?.statusCode, statusCode >= 200, statusCode < 299 {
                completion("\(response.data?.string ?? "OK")", nil)
            }
            else {
                completion(nil, "\(response.data?.string ?? "Unknown")")
            }
        }
    }
    
}
