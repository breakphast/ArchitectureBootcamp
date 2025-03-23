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
 
 4. MVVM Architecture
 
 - DataManager is shared across the app, but accessed from the ViewModel
 - ViewModels are responsible for business logic
 - ViewModel holds the array of products
 
 Pros:
 - Separated the View from Business Logic
 - Business logic is now testable
 - View code is much cleaner
 
 Cons:
 - More difficult to set up and inject dependencies
 - ViewModel lifecycle is outside of View lifecycle (cannot use SwiftUI Property Wrappers)
 
 */

@Observable
@MainActor
class UserManager {
    
}

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

@MainActor
@Observable
class ContentViewModel {
    var products = [Product]()
    let dataManager: DataManager
    let userManager: UserManager
    
    init(container: DependencyContainer) {
        self.dataManager = container.resolve(DataManager.self)!
        self.userManager = container.resolve(UserManager.self)!
    }
    
    func loadData() async {
        do {
            products = try await dataManager.getProducts()
        } catch {
            
        }
    }
    
}

struct ContentView: View {
    @State var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            VStack {
                ForEach(viewModel.products) { product in
                    Text(product.title)
                }
            }
        }
        .padding()
        .task {
            await viewModel.loadData()
        }
    }
}

@MainActor
class DependencyContainer {
    private var services: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, service: T) {
        let key = "\(type)"
        services[key] = service
    }
    
    func register<T>(_ type: T.Type, service: () -> T) {
        let key = "\(type)"
        services[key] = service()
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = "\(type)"
        return services[key] as? T
    }
}

#Preview {
    let container = DependencyContainer()
    container.register(DataManager.self, service: DataManager(service: MockDataService()))
    container.register(UserManager.self, service: UserManager())
    
    return ContentView(viewModel: ContentViewModel(container: container))
}
