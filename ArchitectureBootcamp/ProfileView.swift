//
//  ProfileView.swift
//  ArchitectureBootcamp
//
//  Created by Desmond Fitch on 4/7/25.
//

import SwiftUI

struct AnyDestination: Hashable {
    let id = UUID().uuidString
    var destination: AnyView
    
    init<T: View>(destination: T) {
        self.destination = AnyView(destination)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AnyDestination, rhs: AnyDestination) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension EnvironmentValues {
    @Entry var router: Router = MockRouter()
}

protocol Router {
    func showScreen<T: View>(@ViewBuilder destination: @escaping (Router) -> T)
    func dismissScreen()
}

struct MockRouter: Router {
    func showScreen<T: View>(@ViewBuilder destination: @escaping (Router) -> T) {
        print("Mock router does not work")
    }
    
    func dismissScreen() {
        print("Mock router does not work")
    }
}

struct RouterView<Content: View>: View, Router {
    @Environment(\.dismiss) private var dismiss
    @State private var path = [AnyDestination]()
    @Binding var screenStack: [AnyDestination]
    
    var addNavigationView: Bool = true
    @ViewBuilder var content: (Router) -> Content
    
    init(
        screenStack: (Binding<[AnyDestination]>)? = nil,
        addNavigationView: Bool = true,
        content: @escaping (Router) -> Content
    ) {
        self._screenStack = screenStack ?? .constant([])
        self.addNavigationView = addNavigationView
        self.content = content
    }
    
    var body: some View {
        NavigationStackIfNeeded(path: $path, addNavigationView: addNavigationView) {
            content(self)
        }
        .environment(\.router, self)
    }
    
    func showScreen<T: View>(@ViewBuilder destination: @escaping (Router) -> T) {
        let screen = RouterView<T>(
            screenStack: screenStack.isEmpty ? $path : $screenStack,
            addNavigationView: false
        ) { newRouter in
            destination(newRouter)
        }
        
        let destination = AnyDestination(destination: screen)
        
        if screenStack.isEmpty {
            path.append(destination)
        } else {
            screenStack.append(destination)
        }
    }
    
    func dismissScreen() {
        dismiss()
    }
}

struct NavigationStackIfNeeded<Content: View>: View {
    @Binding var path: [AnyDestination]
    var addNavigationView = true
    @ViewBuilder var content: Content
    
    var body: some View {
        if addNavigationView {
            NavigationStack(path: $path) {
                content
                    .navigationDestination(for: AnyDestination.self) { value in
                        value.destination
                    }
            }
        } else {
            content
        }
    }
}

struct ProfileView: View {
    @Environment(\.router) private var router
    
    var body: some View {
        VStack(spacing: 40) {
            Button {
                router.showScreen { _ in
                    SettingsView()
                }
            } label: {
                Text("Click me")
            }
        }
    }
}

struct SettingsView: View {
    @Environment(\.router) private var router
    
    var body: some View {
        VStack {
            Text("Settings")
            
            Button {
                router.showScreen { _ in
                    AccountView()
                }
            } label: {
                Text("Go forward")
            }
            
            Button {
                router.showScreen { _ in
                    AccountView()
                }
            } label: {
                Text("Click me")
            }
        }
        .navigationTitle("Settings")
    }
}

struct AccountView: View {
    @Environment(\.router) private var router
    
    var body: some View {
        VStack {
            Text("Account")
            
            Button {
                router.showScreen { _ in
                    AccountView()
                }
            } label: {
                Text("Go forward")
            }
            
            Button {
                router.dismissScreen()
            } label: {
                Text("Dismiss screen")
            }
        }
        .navigationTitle("Account")
    }
}

#Preview {
    RouterView { _ in
        ProfileView()
    }
}
