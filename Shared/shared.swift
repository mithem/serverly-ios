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
    var value = userDefaults.string(forKey: "serverURL") ?? "https://google.com/search?q="
    if value.hasSuffix("/") {
        value =  String(value[..<value.index(before: value.endIndex)])
    }
    if value.isEmpty {
        throw ServerlyError.InvalidConfigurationError
    }
    return value
}

func getResponse<T: Decodable>(for url: String, expected type: T.Type, completion: @escaping (Response) -> Void) throws {
    let authenticationString = getAuthenticationString()
    let myurl = URL(string: try getServerURL() + url)!
    var request = URLRequest(url: myurl)
    request.setValue("Basic " + (authenticationString.data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
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
    let authenticationString = getAuthenticationString()
    let myurl = summaryURLMap[kind]
    var domain: String
    do {
        domain = try getServerURL()
    } catch {
        completion(ServerlyError.InvalidConfigurationError.localizedDescription)
        return
    }
    guard let myUrl = myurl else { return }
    let url = URL(string: domain + myUrl)!
    var request = URLRequest(url: url)
    request.timeoutInterval = requestTimeout
    request.setValue("Basic " + (authenticationString.data(using: String.Encoding.utf8)?.base64EncodedString())!, forHTTPHeaderField: "authentication")
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            completion(String(data: data, encoding: .utf8) ?? "No response.")
        } else {
            completion("Error: \(error?.localizedDescription ?? "Unknown error")")
        }
    }.resume()
}

enum ServerlyError: Error {
    case JSONDecodeError
    case NoResponseError
    case UnknownError
    case InvalidConfigurationError
}

extension ServerlyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .JSONDecodeError:
            return NSLocalizedString("Error while decoding JSON.", comment: "JSONDecodeError")
        case .NoResponseError:
            return NSLocalizedString("No response.", comment: "NoResponseError")
        case .InvalidConfigurationError:
            return NSLocalizedString("Invalid configuration.", comment: "InvalidConfigurationError")
        case .UnknownError:
            return NSLocalizedString("Unkown error.", comment: "UnkownError")
        }
    }
}

enum Response {
    case success(data: Decodable)
    case failure(error: Error)
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
        print(error.localizedDescription)
        throw ServerlyError.JSONDecodeError
    }
}
