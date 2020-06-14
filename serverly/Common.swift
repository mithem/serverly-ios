//
//  Common.swift
//  serverly
//
//  Created by Miguel Themann on 14.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import Foundation

func getAuthenticationString() -> String {
    let userDefaults = UserDefaults()
    return (userDefaults.string(forKey: "username") ?? "root") + ":" + (userDefaults.string(forKey: "password") ?? "1234")
}

func getServerURL() -> String {
    let userDefaults = UserDefaults()
    var value = userDefaults.string(forKey: "serverURL") ?? "https://google.com/search?q="
    if value.hasSuffix("/") {
        value =  String(value[..<value.index(before: value.endIndex)])
    }
    return value
}

struct JSONDecodeError: Error {
    
}

func readJson(data: Data) throws -> Dictionary<String, Dictionary<String, String>> {
    // https://stackoverflow.com/questions/40438784/read-json-file-with-swift-3/40438849#40438849
    do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: Dictionary<String, String>] {
                return object
            } else { // only expect dicts from the server
                throw JSONDecodeError()
            }
    } catch {
        print(error.localizedDescription)
        throw JSONDecodeError()
    }
}

struct Endpoint {
    let path: String
    let name: String
}
