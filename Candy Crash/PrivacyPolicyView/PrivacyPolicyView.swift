//
//  PrivacyPolicyView.swift
//  Candy Crash
//
//  Created by Anton on 19/2/24.
//

import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
    
    @Environment(\.presentationMode) var presMode
    
    var body: some View {
        NavigationView {
            VStack {
                PrivacyView(url: URL(string: "https://www.freeprivacypolicy.com/live/61103adf-40c6-48bb-9375-ae3594d0c1c7")!)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("arrow_back")
                            .resizable()
                            .frame(width: 42, height: 42)
                    }
                }
            }
            .animation(.easeInOut)
        }
        .preferredColorScheme(.light)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    PrivacyPolicyView()
}

struct PrivacyView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
