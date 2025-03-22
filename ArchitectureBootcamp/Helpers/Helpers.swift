//
//  Helpers.swift
//  ArchitectureBootcamp
//
//  Created by Desmond Fitch on 3/22/25.
//

import SwiftUI

protocol DataService {
    func getProducts() async throws -> [Product]
}

struct ProductArray: Codable {
    let products: [Product]
}

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
}

struct MockDataService: DataService {
    func getProducts() async throws -> [Product] {
        guard let url = URL(string: "https://dummyjson.com/products") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let products = try JSONDecoder().decode(ProductArray.self, from: data)
        return products.products
    }
}
