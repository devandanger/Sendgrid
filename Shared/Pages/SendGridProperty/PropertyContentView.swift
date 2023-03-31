//
//  ContentView.swift
//  Shared
//
//  Created by Evan Anger on 11/11/21.
//

import SwiftUI

struct PropertyContentView: View {
    let property: SendGridProperty
    @State var selection: Int = 0
    var body: some View {
        TabView(selection: $selection) {
            ContactListView(property: property)
                .font(.title)
                .tabItem({
                    Image(systemName: "person.3")
                })
                .tag(0)
            Text(property.name)
                .font(.title)
                .tabItem({
                    Image(systemName: "paperplane.fill")
                })
                .tag(1)
            Text("View C")
                .font(.title)
                .tabItem({
                    Image(systemName: "pencil")
                })
                .tag(2)
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
