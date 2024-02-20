//
//  LeadingBoardView.swift
//  Candy Crash
//
//  Created by Anton on 19/2/24.
//

import SwiftUI

struct LeadingBoardView: View {
    
    @Environment(\.presentationMode) var presMode
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack {
                        Spacer().frame(height: 150)
                        Text("\(UserDefaults.standard.integer(forKey: "max_score_3"))")   .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.pink)
                        Rectangle()
                            .frame(width: 70, height: 100)
                            .foregroundColor(.pink)
                            .clipShape(
                                RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                            )
                    }
                    VStack {
                        Spacer().frame(height: 10)
                        Text("\(UserDefaults.standard.integer(forKey: "max_score_1"))")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.pink)
                        Rectangle()
                            .frame(width: 70, height: 240)
                            .foregroundColor(.pink)
                            .clipShape(
                                RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                            )
                    }
                    VStack {
                        Spacer().frame(height: 100)
                        Text("\(UserDefaults.standard.integer(forKey: "max_score_2"))")   .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.pink)
                        Rectangle()
                            .frame(width: 70, height: 150)
                            .foregroundColor(.pink)
                            .clipShape(
                                RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                            )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
                .overlay(
                    Image("candy_border")
                        .resizable()
                        .frame(width: 350, height: 420)
                )
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
            .navigationTitle("Records Board")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.easeInOut)
            .preferredColorScheme(.dark)
            .background(
                Image(UserDefaults.standard.string(forKey: "user_background") ?? "Background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.5)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    LeadingBoardView()
}
