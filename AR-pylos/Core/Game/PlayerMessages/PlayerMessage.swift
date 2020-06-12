//
//  PlayerMessage.swift
//  AR-pylos
//
//  Created by Vitalii Poponov on 6/11/20.
//  Copyright © 2020 Vitalii Poponov. All rights reserved.
//

import Foundation

enum PlayerMessageType: Int, Codable {
    case initiated = 0
    
}

protocol PlayerMessagePayloadProtocol: Codable {
    var playerId: String { get }
}

struct PlayerMessage: Codable {
    enum CodingKeys: CodingKey {
      case type, payload
    }

    var type: PlayerMessageType
    var payload: PlayerMessagePayloadProtocol
    
    init(type: PlayerMessageType, payload: PlayerMessagePayloadProtocol) {
        self.type = type
        self.payload = payload
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(PlayerMessageType.self, forKey: .type)
        switch type {
        case .initiated:
            payload = try container.decode(InitiatedPlayerMessagePayload.self, forKey: .payload)
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(type.rawValue, forKey: .type)
        switch type {
        case .initiated:
            try? container.encode(payload as? InitiatedPlayerMessagePayload, forKey: .payload)
        }
    }
}
