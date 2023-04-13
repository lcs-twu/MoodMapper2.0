//
//  MoodMapper.swift
//  MoodMapper2.0
//
//  Created by Tom Wu on 2023-04-13.
//

import Foundation
import Blackbird

struct MoodMapper: BlackbirdModel {
    @BlackbirdColumn var id: Int
    @BlackbirdColumn var description: String
    @BlackbirdColumn var emoji: String
}
