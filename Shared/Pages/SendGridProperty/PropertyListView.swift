//
//  PropertyListView.swift
//  Sendgrid
//
//  Created by Evan Anger on 3/31/23.
//

import SwiftUI

struct PropertyListView: View {
    @EnvironmentObject var keyStorage: ApiKeyStorage
    @State var showSetupAPI: Bool = false
    var body: some View {
        VStack {
            if keyStorage.list().count == 0 {
                Text("No properties")
            } else {
                ForEach(keyStorage.list(), id: \.name) { property in
                    Text(property.name)
                }
            }
            Spacer()

        }
        .sheet(isPresented: self.$showSetupAPI) {
            ApiView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.showSetupAPI.toggle()
                } label: {
                    Image(systemName: "person")
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
