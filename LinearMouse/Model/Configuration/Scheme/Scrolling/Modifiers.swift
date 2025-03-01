// MIT License
// Copyright (c) 2021-2023 LinearMouse

import Foundation

extension Scheme.Scrolling {
    struct Modifiers: Equatable, Codable, ImplicitInitable {
        var command: Action?
        var shift: Action?
        var option: Action?
        var control: Action?
    }
}

extension Scheme.Scrolling.Modifiers {
    enum Action: Equatable {
        case none
        case alterOrientation
        case changeSpeed(scale: Decimal)
        case zoom
    }
}

extension Scheme.Scrolling.Modifiers {
    func merge(into modifiers: inout Self) {
        if let command = command {
            modifiers.command = command
        }

        if let shift = shift {
            modifiers.shift = shift
        }

        if let option = option {
            modifiers.option = option
        }

        if let control = control {
            modifiers.control = control
        }
    }

    func merge(into modifiers: inout Self?) {
        if modifiers == nil {
            modifiers = Self()
        }

        merge(into: &modifiers!)
    }
}

extension Scheme.Scrolling.Modifiers.Action: Codable {
    enum CodingKeys: String, CodingKey {
        case type, scale
    }

    enum ActionType: String, Codable {
        case none, alterOrientation, changeSpeed, zoom
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ActionType.self, forKey: .type)

        switch type {
        case .none:
            self = .none
        case .alterOrientation:
            self = .alterOrientation
        case .changeSpeed:
            let scale = try container.decode(Decimal.self, forKey: .scale)
            self = .changeSpeed(scale: scale)
        case .zoom:
            self = .zoom
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .none:
            try container.encode(ActionType.none, forKey: .type)
        case .alterOrientation:
            try container.encode(ActionType.alterOrientation, forKey: .type)
        case let .changeSpeed(scale):
            try container.encode(ActionType.changeSpeed, forKey: .type)
            try container.encode(scale, forKey: .scale)
        case .zoom:
            try container.encode(ActionType.zoom, forKey: .type)
        }
    }
}
