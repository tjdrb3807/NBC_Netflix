//
//  Video.swift
//  NBC_Netflix
//
//  Created by 전성규 on 12/26/24.
//

import Foundation

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let key: String
    let site: String
    let type: String
}
