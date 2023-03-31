//
//  ApiView.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import CodeScanner
import Combine
import SwiftUI
import CameraView

struct ApiView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var keyStorage: ApiKeyStorage
    @State var showCamera: Bool = false
    @State var readInput: Bool = false
    @State var propertyName: String = ""
    @State var propertyApiKey: String = ""
    
    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
                    propertyName = code
                    self.showCamera.toggle()
                }
            }
        )
    }
    var body: some View {
        NavigationView {
            VStack {
                TextField("Sendgrid Name", text: $propertyName)
                    .textFieldStyle(.roundedBorder)
                    .padding(10)
                TextField("Sendgrid API Key", text: $propertyApiKey)
                    .textFieldStyle(.roundedBorder)
                    .padding(10)
                    
                HStack {
                    Spacer()
                    Button {
                        showCamera.toggle()
                    } label: {
                        Image(systemName: "barcode.viewfinder")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(4)
                    }
                }
                .padding(20)
                Spacer()
            }
            .sheet(isPresented: $showCamera, onDismiss: {
                
            }, content: {
                self.scannerSheet
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Add")
                    }
                    .disabled(self.readInput)
                }
            }
        }
    }
}

struct ApiView_Previews: PreviewProvider {
    static var previews: some View {
        ApiView()
            .environmentObject(ApiKeyStorage())
    }
}
