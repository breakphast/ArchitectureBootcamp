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

protocol Router {
    func showScreen<T: View>(@ViewBuilder destination: () -> T)
}

struct RouterView<Content: View>: View, Router {
    @State private var path = [AnyDestination]()
    @ViewBuilder var content: (Router) -> Content
    
    var body: some View {
        NavigationStack(path: $path) {
            content(self)
                .navigationDestination(for: AnyDestination.self) { value in
                    value.destination
                }
        }
    }
    
    func showScreen<T: View>(@ViewBuilder destination: () -> T) {
        let destination = AnyDestination(destination: destination())
        path.append(destination)
    }
}

struct ProfileView: View {
    
    var body: some View {
        RouterView { router in
            VStack(spacing: 40) {
                Button {
                    router.showScreen {
                        Text("SOME OTHER SCREEN")
                    }
                } label: {
                    Text("Click me")
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
