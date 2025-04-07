//
//  Router.swift
//  ArchitectureBootcamp
//
//  Created by Desmond Fitch on 4/7/25.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var router: Router = MockRouter()
}

protocol Router {
    func showScreen<T: View>(_ option: SegueOption, @ViewBuilder destination: @escaping (Router) -> T)
    func dismissScreen()
    func showAlert(_ option: AlertType, title: String, subtitle: String?, buttons: (@Sendable () -> AnyView)?)
    func dismissAlert()
    func showModal<T: View>(transition: AnyTransition, backgroundColor: Color, @ViewBuilder destination: @escaping () -> T)
    func dismissModal()
}

struct MockRouter: Router {
    func showScreen<T: View>(_ option: SegueOption, @ViewBuilder destination: @escaping (Router) -> T) where T : View {
        print("Mock router does not work.")
    }
    
    func dismissScreen() {
        print("Mock router does not work.")
    }
    
    func showAlert(_ option: AlertType, title: String, subtitle: String?, buttons: (@Sendable () -> AnyView)?) {
        print("Mock router does not work.")
    }
    
    func dismissAlert() {
        print("Mock router does not work.")
    }
    
    func showModal<T: View>(@ViewBuilder destination: @escaping () -> T) {
        print("Mock router does not work.")
    }
    
    func dismissModal() {
        print("Mock router does not work.")
    }
    
    func showModal<T: View>(transition: AnyTransition, backgroundColor: Color, @ViewBuilder destination: @escaping () -> T) {
        print("Mock router does not work.")
    }
}
