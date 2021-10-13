//
//  PhotoResponse.swift
//  5week_PhotoSearchProject
//
//  Created by sumin on 2021/10/13.
//

import Foundation

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let regular: String
}
