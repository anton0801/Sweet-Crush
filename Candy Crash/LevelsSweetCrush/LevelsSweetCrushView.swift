//
//  LevelsSweetCrushView.swift
//  Candy Crash
//
//  Created by Anton on 19/2/24.
//

import SwiftUI

struct LevelsSweetCrushView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var userData: UserData
    
    var columns = [
        GridItem(.flexible(minimum: 40), spacing: 0),
        GridItem(.flexible(minimum: 40), spacing: 0),
        GridItem(.flexible(minimum: 40), spacing: 0)
    ]
    
    @State var levels: [String] = []
    
    @State var activeLevel = false
    @State var level = ""
    @State var levelWithoutC = ""
    
    var body: some View {
        NavigationView {
            VStack {
                let screenWidth = UIScreen.main.bounds.width * 0.85
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        let itemWidth = screenWidth / 4
                        ForEach(levels, id: \.self) { level in
                            let levelNum = level.components(separatedBy: "_")[1]
                            Button {
                                if userData.unlockedLevels.contains(where: { $0 == "Level_\(levelNum)" }) {
                                    self.level = "Level_\(Int(levelNum)! % 5)"
                                    self.levelWithoutC = "Level_\(levelNum)"
                                    self.activeLevel = true
                                }
                            } label: {
                                ZStack {
                                    Image("level_back")
                                        .resizable()
                                        .opacity(0.8)
                                        .frame(width: itemWidth, height: itemWidth)
                                    Text("\(Int(levelNum)! + 1)")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                    if !userData.unlockedLevels.contains(where: { $0 == "Level_\(levelNum)" }) {
                                        Image("lock")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .offset(x: itemWidth / 2.5, y: -(itemWidth / 2.5))
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: screenWidth)
                }
                .frame(width: screenWidth)
                
                NavigationLink(destination: CandyCrashGameView(level: level, levelWithoutC: levelWithoutC)
                    .environmentObject(userData)
                    .navigationBarBackButtonHidden(true), isActive: $activeLevel) {
                    EmptyView()
                }
            }
            .onAppear {
                for indexLevel in 0..<100 {
                    levels.append("Level_\(indexLevel)")
                }
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
            .navigationTitle("Levels")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .background(
                Image(UserDefaults.standard.string(forKey: "user_background") ?? "Background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.5)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            )
            .animation(.easeInOut)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    LevelsSweetCrushView()
        .environmentObject(UserData())
}
