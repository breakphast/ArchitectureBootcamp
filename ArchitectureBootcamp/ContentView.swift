//
//  ContentView.swift
//  ArchitectureBootcamp
//
//  Created by Desmond Fitch on 3/22/25.
//

import SwiftUI

/*
 ARCHITECTURE NOTES:
 
 1. No Architecture (Vanilla SwiftUI)
 
 - There is no DataManager, views are responsible for business logic and data logic
 - View holds the array of products
 
 Pros:
 - Simplest code
 - Easy to set up, low chance for bugs
 
 Cons:
 - Hard to preview
 - No separation between view and data layers
 - Not testable, mockable, or reusable
 
 
 2. MV Architecture (Vanilla SwiftUI)
 
 - DataManager is shared across the app
 - DataManager is responsible for business and data logic
 
 Pros:
 - Less code
 - Easy to reuse business logic
 
 Cons:
 - Tightly couple the business and data logic
 - "Too easy" to reuse data (other views can affect each other)
 
 
 3. MVC Architecture (Vanilla SwiftUI)
 
 - DataManager is shared across the app
 - Views are responsible for business logic but not data logic
 - View holds the array of products
 
 Pros:
 - DataManager is shared across app
 - DataManager is testable, mockable, and reusable
 
 Cons:
 - Business logic is not testable
 - Massive View Controller
 
 */

@Observable
@MainActor
class DataManager {
    let service: DataService
    
    init(service: DataService) {
        self.service = service
    }
    
    func getProducts() async throws -> [Product] {
        try await service.getProducts()
    }
}

struct ContentView: View {
    @Environment(DataManager.self) private var dataManager
    @State private var products = [Product]()
    
    var body: some View {
        VStack {
            VStack {
                ForEach(products) { product in
                    Text(product.title)
                }
            }
        }
        .padding()
        .task {
            await loadData()
        }
    }
    
    private func loadData() async {
        do {
            products = try await dataManager.getProducts()
        } catch {
            
        }
    }
}

#Preview {
    ContentView()
        .environment(DataManager(service: MockDataService()))
}
