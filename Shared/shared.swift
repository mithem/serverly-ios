//
//  shared.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import Foundation

func getAuthenticationString() -> String {
    let userDefaults = UserDefaults()
    return (userDefaults.string(forKey: "username") ?? "root") + ":" + (userDefaults.string(forKey: "password") ?? "1234")
}

func getServerURL() throws -> String {
    let userDefaults = UserDefaults()
    let value = userDefaults.string(forKey: "serverURL")
    guard !(value?.isEmpty ?? true) else { throw ServerlyError.InvalidConfigurationError }
    guard var val = value else { throw ServerlyError.InvalidConfigurationError }
    if val.hasSuffix("/") {
        val =  String(val[..<val.index(before: val.endIndex)])
    }
    return val
}

func getRequest(for url: String) throws -> URLRequest {
    let domain = try getServerURL()
    guard let myurl = URL(string: domain + url) else {
        throw ServerlyError.InvalidConfigurationError
    }
    var request = URLRequest(url: myurl)
    request.setValue("Basic " + (getAuthenticationString().data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
    return request
}

/// request something on the web
/// - Parameters:
///   - url: url
///   - type: expected answer type
///   - method: HTTP-Method
///   - completion: completion handler (takes `Response`)
/// - Throws: `ServerlyError.InvalidConfigurationError`
func getParsedJSONResponse<T: Decodable>(for url: String, expected type: T.Type, with method: String = "GET", completion: @escaping (Response) -> Void) throws {
    var request = try getRequest(for: url)
    request.httpMethod = method
    request.timeoutInterval = requestTimeout
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            let parsed = try? JSONDecoder().decode(type, from: data)
            if let parsed = parsed {
                completion(.success(data: parsed))
            } else {
                completion(.failure(error: ServerlyError.NoResponseError))
            }
        } else {
            completion(.failure(error: error ?? ServerlyError.UnknownError))
        }
    }.resume()
}

func getSummary(for kind: String, completion: @escaping (String) -> Void) {
    guard let url = summaryURLMap[kind] else {
        completion(ServerlyError.NotImplementedError.localizedDescription)
        return
    }
    var request: URLRequest
    do {
        request = try getRequest(for: url)
    } catch {
        completion(ServerlyError.InvalidConfigurationError.localizedDescription)
        return
    }
    request.timeoutInterval = requestTimeout
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            completion(String(data: data, encoding: .utf8) ?? "No response.")
        } else {
            completion("Error: \(error?.localizedDescription ?? "Unknown error")")
        }
    }.resume()
}

func deleteUsers(withIds: [Int], completion: @escaping (Response) -> Void) {
    var request: URLRequest
    do {
        request = try getRequest(for: "/console/api/users/delete")
    } catch {
        completion(.failure(error: ServerlyError.InvalidConfigurationError))
        return
    }
    request.httpMethod = "DELETE"
    guard let data = try? JSONEncoder().encode(withIds) else {
        completion(.failure(error: ServerlyError.JSONEncodeError))
        return
    }
    request.httpBody = data
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            completion(.success(data: String(data: data, encoding: .utf8)))
        } else {
            completion(.failure(error: ServerlyError.NoResponseError))
        }
    }.resume()
}

func deleteEndpoints(endpoints: [Endpoint], completion: @escaping (Response) -> Void) {
    var request: URLRequest
    do {
        request = try getRequest(for: "/console/api/endpoint.del")
    } catch {
        completion(.failure(error: ServerlyError.InvalidConfigurationError))
        return
    }
    request.httpMethod = "DELETE"
    var endpointsToDelete = [[String]]()
    for endpoint in endpoints {
        endpointsToDelete.append([endpoint.method, endpoint.path])
    }
    guard let data = try? JSONEncoder().encode(endpointsToDelete) else {
        completion(.failure(error: ServerlyError.JSONEncodeError))
        return
    }
    request.httpBody = data
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            completion(.success(data: String(data: data, encoding: .utf8)))
        } else {
            completion(.failure(error: ServerlyError.NoResponseError))
        }
    }.resume()
}

func readJson(data: Data) throws -> Dictionary<String, Dictionary<String, String>> {
    // https://stackoverflow.com/questions/40438784/read-json-file-with-swift-3/40438849#40438849
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let object = json as? [String: Dictionary<String, String>] {
            return object
        } else { // only expect dicts from the server
            throw ServerlyError.JSONDecodeError
        }
    } catch {
        throw ServerlyError.JSONDecodeError
    }
}

func requestRootUserPermissions(completion: @escaping (RootUserPermissionRequestResponse) -> Void) {
    print("Trying to get root permissions...")
    do {
        try getParsedJSONResponse(for: "/console/api/root/token", expected: Dictionary<String, String>.self) { response in
            switch response {
            case .success(data: let data):
                print("Got data from server!")
                let dict = data as! Dictionary<String, String>
                print(dict)
                if dict["code"] == "200" {
                    print("Got root permissions!")
                    UserDefaults().set(dict["token"]!, forKey: "create-root-user-token")
                    completion(.success)
                } else {
                    print("Denied root permissions!")
                    completion(.denied)
                }
            case .failure(error: let error):
                print("Failure getting root permissions: \(error.localizedDescription)")
                completion(.failure(error: error))
            }
        }
    } catch {
        completion(.failure(error: error))
    }
}
