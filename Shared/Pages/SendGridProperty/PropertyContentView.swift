//
//  ContentView.swift
//  Shared
//
//  Created by Evan Anger on 11/11/21.
//

import SwiftUI

struct PropertyContentView: View {
    let property: SendGridProperty
    @State private var selection = 0
    @State var lists: [AbbrevContact] = []
    @State var filterContacts: String = ""
    var filteredList: [AbbrevContact] {
        if filterContacts.isEmpty {
            return lists
        } else {
            return lists.filter { $0.name.lowercased().contains(filterContacts.lowercased()) }
        }
    }
    var body: some View {
        NavigationStack {
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
                TextField("Search", text: $filterContacts)
                    .defaultStyle()
                ForEach(self.filteredList, id: \.id) { contact in
                    ContactListItemView(contact: contact)
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(property.name)
            .onAppear {}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PropertyContentView(property: SendGridProperty(name: "Name", apiKey: "")).environmentObject(ApiKeyStorage())
        }
    }
}
