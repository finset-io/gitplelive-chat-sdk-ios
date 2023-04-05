//
//  NetworkHelper.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

class NetworkHelper: NSObject {
    
    static func getRequest(url: String, headers: [String:String]?, completion: @escaping (String?, String?) -> ()) {
        request(url: url, method: "GET", headers: headers, body: nil) { data, error in
            DispatchQueue.main.async { completion(data, error) }
        }
    }
    
    static func postRequest(url: String, headers: [String:String]?, body: String?, completion: @escaping (String?, String?) -> ()) {
        request(url: url, method: "POST", headers: headers, body: body) { data, error in
            DispatchQueue.main.async { completion(data, error) }
        }
    }
    
    static func putRequest(url: String, headers: [String:String]?, body: String?, completion: @escaping (String?, String?) -> ()) {
        request(url: url, method: "PUT", headers: headers, body: body) { data, error in
            DispatchQueue.main.async { completion(data, error) }
        }
    }
    
    static func deleteRequest(url: String, headers: [String:String]?, body: String?, completion: @escaping (String?, String?) -> ()) {
        request(url: url, method: "DELETE", headers: headers, body: body) { data, error in
            DispatchQueue.main.async { completion(data, error) }
        }
    }
    
    private static func request(url: String, method: String, headers: [String:String]?, body: String?, completion: @escaping (String?, String?) -> ()) {
        var newheaders: [String:String]?
        if var headers = headers {
            headers["Content-Type"] = "application/json"
            headers["Accept"] = "application/json"
            newheaders = headers
        }
        httpRequest(url: url, method: method, headers: newheaders, body: body) { data, response, error  in
            if let error = error {
                completion(nil, error)
            }
            else if data == "Health!" {
                if let headers = response?.headers {
                    completion(headers["x-forwarded-for"], nil)
                }
                else {
                    completion(nil, "[x-forwarded-for] not found")
                }
            }
            else if let response = response {
                if response.statusCode >= 200, response.statusCode < 299 {
                    completion(data ?? "OK", nil)
                }
                else if let data = data {
                    completion(nil, data)
                }
                else {
                    completion(nil, response.description)
                }
            }
            else {
                completion(nil, "Unknown error")
            }
        }
    }
    
    private static func httpRequest(url: String, method: String, headers: [String:String]?, body: String?, completion: @escaping (String?, HTTPURLResponse?, String?) -> ()) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        headers?.forEach() { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = body?.data(using: .utf8)

        print("[debug] httpRequest", method, request)
        print("[debug] headers", headers ?? "N/A")
        print("[debug] body", body ?? "N/A")

        URLSession.shared.dataTask(with: request) { data, response, error in
            let response = response as? HTTPURLResponse
            if let error = error {
                print("[debug] error", error.localizedDescription)
                completion(nil, nil, error.localizedDescription)
            }
            else if let data = data {
                let data = String(data: data, encoding: .utf8)
                print("[debug] response", response?.statusCode ?? -1, data ?? "")
                completion(data, response, nil)
            }
            else {
                print("[debug] response", response?.statusCode ?? -1)
                completion(nil, response, nil)
            }
        }.resume()
    }
    
}
