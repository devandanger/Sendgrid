//
//  TestEmailView.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import SwiftUI

struct TestEmailView: View {
    @State var isLoading: Bool = false
    @State var fromAddress: String = "rsmith@neosportsplant"
    @State var addresses: String = ""
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(x: 2, y: 2, anchor: .center)
            } else {
                VStack {
                    TextField("From Address", text: $fromAddress)
                        .textFieldStyle(.roundedBorder)
                        .frame(height: 60)
                    Button("Select Template") {
                        print("Template")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    Header(name: "Addresses")
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    TextEditor(text: $addresses)
                        .frame(maxHeight: 200)
                        .textFieldStyle(.roundedBorder)
                        .padding(20)
                    Spacer()
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("hello")
                } label: {
                    Image(systemName: "paperplane")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLoading = false
            }
        }
    }
}

struct TestEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TestEmailView()
        }
    }
}
