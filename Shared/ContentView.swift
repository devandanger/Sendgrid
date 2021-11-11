//
//  ContentView.swift
//  Shared
//
//  Created by Evan Anger on 11/11/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var keyStorage: ApiKeyStorage
    @State var showSetupAPI: Bool = false
    var body: some View {
        NavigationView {
            Text("Hello, world!")
                .padding()
                .sheet(isPresented: self.$showSetupAPI) {
                    ApiView()
                }
                .onAppear {
                    print("On appear")
                    if keyStorage.apiKey.isEmpty {
                        self.showSetupAPI = true
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
