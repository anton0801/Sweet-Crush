//
//  StoreBacksView.swift
//  Candy Crash
//
//  Created by Anton on 19/2/24.
//

import SwiftUI

struct StoreBacksView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var currentBackground = "Background"
    @State var currentWallpaper = "Background"
    @State var currentWallpaperIndex = 0
    
    var allBackgrounds = [
        "Background",
        "background_2",
        "background_3",
        "background_4",
        "background_5",
        "background_6",
        "background_7"
    ]
    
    var backPrices = [
        "Background": 0,
        "background_2": 15000,
        "background_3": 25000,
        "background_4": 40000,
        "background_5": 50000,
        "background_6": 70000,
        "background_7": 100000,
    ]
    
    @State var buyWallpaperErrorShow = false
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        currentWallpaperIndex -= 1
                        currentWallpaper = allBackgrounds[currentWallpaperIndex]
                        userData.currentBackground = currentWallpaper
                    } label: {
                        Image("arrow_back")
                            .resizable()
                            .frame(width: 42, height: 42)
                    }
                    .opacity(currentWallpaper == "Background" ? 0 : 1)
                    .disabled(currentWallpaper == "Background" ? true : false)
                    
                    VStack {
                        ZStack {
                            Button {
                                if userData.wallpapersBuyed.contains(where: { $0 == currentWallpaper }) {
                                    UserDefaults.standard.set(currentWallpaper, forKey: "user_background")
                                    currentBackground = currentWallpaper
                                }
                            } label: {
                                Image(currentWallpaper)
                                    .resizable()
                                    .frame(width: 200, height: 250)
                                    .cornerRadius(12)
                            }
                            
                            if currentWallpaper == UserDefaults.standard.string(forKey: "user_background") {
                                Image("done")
                                    .resizable()
                                    .frame(width: 42, height: 42)
                                    .offset(x: 90, y: -110)
                            }
                            
                            if !userData.wallpapersBuyed.contains(where: { $0 == currentWallpaper }) {
                                Image("lock")
                                    .resizable()
                                    .frame(width: 42, height: 42)
                                    .offset(x: 90, y: -110)
                            }
                        }
                        
                        if !userData.wallpapersBuyed.contains(where: { $0 == currentWallpaper }) {
                            HStack {
                                let priceWallpaper = backPrices[currentWallpaper]!
                                Image("coin")
                                    .resizable()
                                    .frame(width: 42, height: 42)
                                Text("\(priceWallpaper)")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.pink)
                                Spacer().frame(width: 50)
                                Button {
                                    if !userData.buyWallpaper(price: priceWallpaper, wallpaperName: currentWallpaper) {
                                        buyWallpaperErrorShow = true
                                    }
                                } label: {
                                    Image("buy_btn")
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                    )
                    
                    
                    Button {
                        currentWallpaperIndex += 1
                        currentWallpaper = allBackgrounds[currentWallpaperIndex]
                    } label: {
                        Image("arrow_forward")
                            .resizable()
                            .frame(width: 42, height: 42)
                    }
                    .opacity(currentWallpaper == "background_7" ? 0 : 1)
                    .disabled(currentWallpaper == "background_7" ? true : false)
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Image("coin")
                            .resizable()
                            .frame(width: 42, height: 42)
                        Text("\(userData.scoreGaned)")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
            .onAppear {
                currentBackground = UserDefaults.standard.string(forKey: "user_background") ?? "Background"
            }
            .navigationTitle("Store")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.easeInOut)
            .preferredColorScheme(.dark)
            .background(
                Image(currentBackground)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.5)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            )
            .alert(isPresented: $buyWallpaperErrorShow) {
                Alert(
                    title: Text("Buying error"),
                    message: Text("There was an error while purchasing wallpaper for the game! You do not have enough points earned."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    StoreBacksView()
        .environmentObject(UserData())
}
