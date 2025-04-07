//
//  ProfileView.swift
//  ArchitectureBootcamp
//
//  Created by Desmond Fitch on 4/7/25.
//


import SwiftUI

struct ProfileView: View {
       
    @Environment(\.router) private var router
    
    var body: some View {
        List {
            alertSection
            segueSection
            modalSection
        }
        .navigationTitle("Routing examples")
    }
    
    private var segueSection: some View {
        Section {
            Button {
                router.showScreen(.push) { _ in
                    ProfileView()
                }
            } label: {
                Text("Push")
            }
            
            Button {
                router.showScreen(.sheet) { _ in
                    ProfileView()
                }
            } label: {
                Text("Sheet")
            }
            
            Button {
                router.showScreen(.fullScreenCover) { _ in
                    ProfileView()
                }
            } label: {
                Text("Full Screen Cover")
            }
        } header: {
            Text("Segues")
        }
    }
    
    private var alertSection: some View {
        Section {
            Button {
                router.showAlert(.alert, title: "Alert 1", subtitle: "Alert subtitle", buttons: nil)
            } label: {
                Text("Alert")
            }
            
            Button {
                router.showAlert(.confirmationDialog, title: "Alert 2", subtitle: "Alert subtitles", buttons: {
                    AnyView(
                        Group {
                            Button("Alpha", action: { })
                            Button("Beta", action: { })
                            Button("Gamma", action: { })
                            Button("Delta", action: { })
                        }
                    )
                })
            } label: {
                Text("Confirmation Dialog")
            }
            
            Button {
                router.dismissAlert()
            } label: {
                Text("Dismiss Alert")
            }
        } header: {
            Text("Alerts")
        }
    }
    
    private var modalSection: some View {
        Section {
            Button {
                router.showModal(transition: .move(edge: .bottom), backgroundColor: Color.purple.opacity(0.3), destination: {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.blue)
                        .frame(maxHeight: 300)
//                        .padding(40)
                        .onTapGesture {
                            router.dismissModal()
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                })
            } label: {
                Text("Show modal")
            }
        } header: {
            Text("Modals")
        }
    }
}

struct SettingsView: View {
    
    @Environment(\.router) private var router

    var body: some View {
        VStack {
            Text("Settings")
            
            Button {
                router.showScreen(.push) { _ in
                    AccountView()
                }
            } label: {
                Text("Go forward")
            }
            Button {
                router.dismissScreen()
            } label: {
                Text("Dismiss")
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
                router.showScreen(.push) { _ in
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
