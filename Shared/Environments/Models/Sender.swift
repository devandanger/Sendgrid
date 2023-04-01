//
//  Sender.swift
//  Sendgrid
//
//  Created by Evan Anger on 3/31/23.
//

import Foundation

struct Sender: Codable {
    let id: Int
    let nickname: String
    let from_email: String
    let from_name: String
}
