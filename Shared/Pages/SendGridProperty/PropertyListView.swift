//
//  PropertyListView.swift
//  Sendgrid
//
//  Created by Evan Anger on 3/31/23.
//

import SwiftUI

struct PropertyListView: View {
    @EnvironmentObject var keyStorage: ApiKeyStorage
    
    @State var list: [SendGridProperty] = []
    var body: some View {
        VStack {
            if self.list.count == 0 {
                Text("No properties")
            } else {
                ForEach(self.list, id: \.name) { property in
                    NavigationLink {
                        PropertyContentView(property: property)
                            .environmentObject(ApiController(property: property))
                    } label: {
                        HStack {
                            Text(property.name)
                                .font(.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(10)
                    }

                }
            }
            Spacer()

        }
        .onAppear {
            self.list = keyStorage.list()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView()
                        .environmentObject(keyStorage)
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
    }
    
}

struct PropertyListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PropertyListView()
        }
    }
}
