//
//  ContentView.swift
//  Shared
//
//  Created by Evan Anger on 11/11/21.
//

import SwiftUI

struct PropertyContentView: View {
    let property: SendGridProperty
    @EnvironmentObject var apiController: ApiController
    @State var selection: Int = 0
    var body: some View {
        TabView(selection: $selection) {
            ContactListView(property: property)
                .font(.title)
                .tabItem({
                    HStack {
                        Image(systemName: "person.3")
                        Text("Contacts")
                    }
                })
                .tag(0)
            TemplateListView()
                .environmentObject(apiController)
                .font(.title)
                .tabItem({
                    HStack {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Email Templates")
                        }
                    }
                })
                .tag(1)
            Text("View C")
                .font(.title)
                .tabItem({
                    Image(systemName: "paperplane.fill")
                    Text("Send Email")
                })
                .tag(2)
        }
        .onAppear {
            apiController.refresh()
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
