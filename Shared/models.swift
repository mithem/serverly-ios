//
//  models.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import Foundation
import UserNotifications

struct User: Decodable, Identifiable {
    let id: Int
    let username: String
}

struct Endpoint: Decodable {
    let method: String
    let name: String
    let path: String
}

struct EndpointStatistic: Decodable {
    let function: String
    let len: Int
    let mean: Float
    let min: Float
    let max: Float
}

enum ServerlyError: Error {
    case JSONEncodeError
    case JSONDecodeError
    case NoResponseError
    case UnknownError
    case InvalidConfigurationError
    case NotImplementedError
}

extension ServerlyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .JSONEncodeError:
            return NSLocalizedString("Error while encoding JSON.", comment: "JSONEncodeError")
        case .JSONDecodeError:
            return NSLocalizedString("Error while decoding JSON.", comment: "JSONDecodeError")
        case .NoResponseError:
            return NSLocalizedString("No response.", comment: "NoResponseError")
        case .InvalidConfigurationError:
            return NSLocalizedString("Invalid configuration.", comment: "InvalidConfigurationError")
        case .UnknownError:
            return NSLocalizedString("Unkown error.", comment: "UnkownError")
        case .NotImplementedError:
            return NSLocalizedString("Something is not implemented by this app.", comment: "NotImplementedError")
        }
    }
}

enum Response {
    case success(data: Decodable)
    case failure(error: Error)
}

enum NotificationSchedulingRequest {
    case successful
    case badStatus(status: UNAuthorizationStatus)
    case error(error: Error)
}

enum RootUserPermissionRequestResponse {
    case success
    case denied
    case failure(error: Error)
}
