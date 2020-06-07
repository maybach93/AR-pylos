//
//  ServerMessage.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/7/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

enum ServerMessageType: Int, Codable {
    case initiated = 0
    
}

protocol ServerMessagePayloadProtocol: Codable {
    var playerId: String { get }
}

struct ServerMessage: Codable {
    enum CodingKeys: CodingKey {
      case type, payload
    }

    var type: ServerMessageType
    var payload: ServerMessagePayloadProtocol
    
    init(type: ServerMessageType, payload: ServerMessagePayloadProtocol) {
        self.type = type
        self.payload = payload
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ServerMessageType.self, forKey: .type)
        switch type {
        case .initiated:
            payload = try container.decode(InitiatedServerMessagePayload.self, forKey: .payload)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(type.rawValue, forKey: .type)
        switch type {
        case .initiated:
            try? container.encode(payload as? InitiatedServerMessagePayload, forKey: .payload)
        }
    }
}
