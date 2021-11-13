//
//  ContentView.swift
//  Shared
//
//  Created by Evan Anger on 11/11/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var keyStorage: ApiKeyStorage
    @State var lists: [AbbrevContact] = []
    var controller: ApiController {
        return ApiController(storage: keyStorage)
    }
    @State var showSetupAPI: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: TestEmailView()) {
                        HStack {
                            Text("Test Email")
                            Image(systemName: "testtube.2")
                                .frame(width: 44, height: 44)
                        }
                    }
                    Spacer()
                }
                Header(name: "Contact Lists")
                ForEach(self.lists, id: \.id) { contact in
                    ContactListItemView(contact: contact)
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showSetupAPI.toggle()
                    } label: {
                        Image(systemName: "person")
                    }
                }
            }
            .sheet(isPresented: self.$showSetupAPI) {
                ApiView()
            }
            .onAppear {
                if keyStorage.apiKey.isEmpty {
                    self.showSetupAPI = true
                } else {
                    controller.customerList(result: { (data, response, error) in
                        let decoder = JSONDecoder()
                        if  let responseData = data,
                            let contactList = try? decoder.decode(AbbrevContactList.self, from: responseData) {
                            self.lists = contactList.list
                        }
                    })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ApiKeyStorage())
    }
}
