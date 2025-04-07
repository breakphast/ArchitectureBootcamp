//
//  RouterView.swift
//  ArchitectureBootcamp
//
//  Created by Desmond Fitch on 4/7/25.
//

import SwiftUI

/*
 RouterView - @Environment
    ProfileView
        RouterView - @Environment
            SettingsView
                RouterView - @Environment
                    AccountView
 */


struct RouterView<Content: View>: View, Router {
    
    @Environment(\.dismiss) private var dismiss

    @State private var path: [AnyDestination] = []
    
    @State private var showSheet: AnyDestination? = nil
    @State private var showFullScreenCover: AnyDestination? = nil
    @State private var alert: AnyAppAlert? = nil
    @State private var alertOption: AlertType = .alert

    // Binding to the view stack from previous RouterViews
    @Binding var screenStack: [AnyDestination]
    
    var addNavigationView: Bool
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
                .sheetViewModifier(screen: $showSheet)
                .fullScreenCoverViewModifier(screen: $showFullScreenCover)
                .showCustomAlert(type: alertOption, alert: $alert)
        }
        .environment(\.router, self)
    }
    
    func showScreen<T: View>(_ option: SegueOption, @ViewBuilder destination: @escaping (Router) -> T) {
        let screen = RouterView<T>(
            screenStack: option.shouldAddNewNavigationView ? nil : screenStack.isEmpty ? $path : $screenStack,
            addNavigationView: option.shouldAddNewNavigationView
        ) { newRouter in
            destination(newRouter)
        }
        
        let destination = AnyDestination(destination: screen)
        
        switch option {
        case .push:
            if screenStack.isEmpty {
                // This means we are in the first RouterView
                path.append(destination)
            } else {
                // This means we are in a secondary RouterView
                screenStack.append(destination)
            }
        case .sheet:
            showSheet = destination
        case .fullScreenCover:
            showFullScreenCover = destination
        }
    }
    
    func dismissScreen() {
        dismiss()
    }
    
    func showAlert(_ option: AlertType, title: String, subtitle: String? = nil, buttons: (@Sendable () -> AnyView)? = nil) {
        self.alertOption = option
        self.alert = AnyAppAlert(title: title, subtitle: subtitle, buttons: buttons)
    }
    
    func dismissAlert() {
        alert = nil
    }
}
