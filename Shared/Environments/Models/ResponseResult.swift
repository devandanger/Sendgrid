//
//  Result.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import Foundation

struct ResponseResult<D: Decodable>: Decodable {
    let result: [D]
}
