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
    
    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
                    self.keyStorage.add(code)
                    self.showCamera.toggle()
                }
            }
        )
    }
    var body: some View {
        NavigationView {
            VStack {
                TextField("Sendgrid API Key", text: $keyStorage.apiKey)
                    .textFieldStyle(.roundedBorder)
                    .padding(10)
                    
                HStack {
                    Spacer()
                    Button {
                        keyStorage.delete()
                    } label: {
                        Image(systemName: "xmark.bin")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(4)
                    }
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }

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
