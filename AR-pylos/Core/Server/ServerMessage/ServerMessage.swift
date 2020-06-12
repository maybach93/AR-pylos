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
    case gameConfig
    case playerTurn
    case playerFinishedTurn
    case playerWon
}

protocol ServerMessagePayloadProtocol: Codable {
    var player: Player { get }
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
        case .gameConfig:
            payload = try container.decode(GameConfigServerPayload.self, forKey: .payload)
        case .playerTurn:
            payload = try container.decode(PlayerTurnServerPayload.self, forKey: .payload)
        case .playerFinishedTurn:
            payload = try container.decode(PlayerFinishedTurnServerPayload.self, forKey: .payload)
        case .playerWon:
            payload = try container.decode(PlayerWonServerPayload.self, forKey: .payload)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(type.rawValue, forKey: .type)
        switch type {
        case .initiated:
            try? container.encode(payload as? InitiatedServerMessagePayload, forKey: .payload)
        case .gameConfig:
            try? container.encode(payload as? GameConfigServerPayload, forKey: .payload)
        case .playerTurn:
            try? container.encode(payload as? PlayerTurnServerPayload, forKey: .payload)
        case .playerFinishedTurn:
            try? container.encode(payload as? PlayerFinishedTurnServerPayload, forKey: .payload)
        case .playerWon:
            try? container.encode(payload as? PlayerWonServerPayload, forKey: .payload)
        }
    }
}
