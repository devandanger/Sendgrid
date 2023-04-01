//
//  SettingsView.swift
//  Sendgrid
//
//  Created by Evan Anger on 4/1/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var keyStorage: ApiKeyStorage
    @State var showSetupAPI: Bool = false
    var body: some View {
        VStack {
            ForEach(keyStorage.list(), id: \.name) { property in
                HStack {
                    Text(property.name)
                    Spacer()
                    Button {
                        keyStorage.delete(name: property.name)
                    } label: {
                        Image(systemName: "xmark.bin.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
                .padding()
            }
            Spacer()
        }
        .padding()
        .sheet(isPresented: self.$showSetupAPI) {
            ApiView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSetupAPI.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
