//
//  ContentView.swift
//  Shared
//
//  Created by Evan Anger on 11/11/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var keyStorage: ApiKeyStorage
    var controller: ApiController {
        return ApiController(storage: keyStorage)
    }
    @State var showSetupAPI: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, world!")
                    .padding()
                    .sheet(isPresented: self.$showSetupAPI) {
                        ApiView()
                    }
            }
            .onAppear {
                print("On appear")
                if keyStorage.apiKey.isEmpty {
                    self.showSetupAPI = true
                } else {
                    controller.customerList(result: { (data, response, error) in
                        let decoder = JSONDecoder()
                        if  let responseData = data,
                            let contactList = try? decoder.decode(AbbrevContactList.self, from: responseData) {
                            print("Contacts: \(contactList)")
                        }
                    })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(MockApiKeyStorage(key: "asdfasdf"))
    }
}
