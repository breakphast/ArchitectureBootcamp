//
//  ProfileView.swift
//  ArchitectureBootcamp
//
//  Created by Desmond Fitch on 4/7/25.
//

import SwiftUI

//enum NavigationDestinationOption: Hashable {
//    case integer(int: Int)
//    case string(string: String)
//    case someOtherScreen(bool: Bool)
//}

extension View {
    func any() -> AnyView {
        AnyView(self)
    }
}

struct AnyDestination: Hashable {
    let id = UUID().uuidString
    var destination: () -> AnyView
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AnyDestination, rhs: AnyDestination) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

struct ProfileView: View {
    @State private var path = [AnyDestination]()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 40) {
                Button {
                    path.append(AnyDestination(destination: {
                        Text("NEW VALUE").any()
                    }))
                } label: {
                    Text("CLICK ME STRING")
                }
                
                Button {
                    path.append(AnyDestination(destination: {
                        Text("12323").any()
                    }))
                } label: {
                    Text("CLICK ME INT")
                }
                
                Button {
                    goToContentView()
                } label: {
                    Text("CLICK ME BOOL")
                }
            }
            .navigationDestination(for: AnyDestination.self) { value in
                value.destination()
            }
        }
    }
    
    func goToContentView() {
        let container = DependencyContainer()
        container.register(DataManager.self, service: DataManager(service: MockDataService()))
        container.register(UserManager.self, service: UserManager())
        
        path.append(AnyDestination(destination: {
            ContentView(
                viewModel: ContentViewModel(interactor: CoreInteractor(container: container))
            )
            .any()
        }))
    }
}

#Preview {
    ProfileView()
}
