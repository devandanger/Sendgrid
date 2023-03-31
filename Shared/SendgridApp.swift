//
//  SendgridApp.swift
//  Shared
//
//  Created by Evan Anger on 11/11/21.
//

import SwiftUI

@main
struct SendgridApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                PropertyListView()
                    .environmentObject(ApiKeyStorage())
            }
            .navigationTitle("Properties")
        }
    }
}
