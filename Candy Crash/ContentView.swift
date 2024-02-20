//
//  ContentView.swift
//  Candy Crash
//
//  Created by Anton on 19/2/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var showSettingsView = false
    @State var showInfoView = false
    
    @StateObject var userData: UserData = UserData()
    
    var body: some View {
        NavigationView {
            VStack {
                if showSettingsView {
                    Spacer()
                    ZStack {
                        VStack(alignment: .leading) {
                            VStack {
                                Text("Settings")
                                    .foregroundColor(.pink)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            
                            Spacer().frame(height: 18)
                            
                            NavigationLink(destination: PrivacyPolicyView().navigationBarBackButtonHidden(true)) {
                                HStack {
                                    Image(systemName: "checkerboard.shield")
                                        .foregroundColor(.pink)
                                    Text("Privacy Policy")
                                        .foregroundColor(.black)
                                        .padding(.leading, 4)
                                }
                            }
                            .padding(.leading, 24)
                            
                            Spacer().frame(height: 8)
                            
                            Button {
                                UIApplication.shared.open(URL(string: "https://forms.gle/yUsABvDpeSXvkiyF9")!)
                            } label: {
                                HStack {
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(.pink)
                                    Text("Contact us")
                                        .foregroundColor(.black)
                                        .padding(.leading, 1)
                                }
                            }
                            .padding(.leading, 24)
                            
                            Spacer().frame(height: 8)
                            
                            Button {
                                showRateAppDialog()
                            } label: {
                                HStack {
                                    Image(systemName: "star.circle.fill")
                                        .foregroundColor(.pink)
                                    Text("Rate us")
                                        .foregroundColor(.black)
                                        .padding(.leading, 4)
                                }
                            }
                            .padding(.leading, 24)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.white)
                        )
                        .frame(width: 280, height: 280)
                    }
                    .frame(width: 300, height: 300)
                    .shadow(radius: 10, x: 4, y: 1)
                }
                
                if showInfoView {
                    VStack {
                        Spacer()
                        
                        ZStack {
                            VStack(alignment: .leading) {
                                VStack {
                                    Text("Info")
                                        .foregroundColor(.pink)
                                        .font(.system(size: 24, weight: .bold))
                                }
                                .frame(maxWidth: .infinity)
                                
                                Text("In this game everything is very simple, all you need to do is to press play on the main screen then go to the screen with levles and there you choose the available to you levle game and pass it and earn points and with these points you can buy different wallpapers for the game and also view your record in the application.")
                                    .foregroundColor(.black)
                                    .font(.system(size: 12))
                                    .padding(20)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.white)
                            )
                            .frame(width: 280, height: 280)
                        }
                        .frame(width: 300, height: 300)
                        .shadow(radius: 10, x: 4, y: 1)
                        .overlay(
                            Image("candy_border")
                        )
        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        showInfoView = false
                    }
                }
                
                Spacer()
                HStack {
                    Spacer()
                    
                    VStack {
                        Spacer().frame(height: 12)
                        NavigationLink(destination: StoreBacksView()
                            .environmentObject(userData)
                            .navigationBarBackButtonHidden(true)) {
                            Image("store_btn")
                                .resizable()
                                .frame(width: 64, height: 64)
                        }
                    }
                    Spacer().frame(width: 24)
                    
                    VStack {
                        Spacer().frame(height: 12)
                        Button {
                            showSettingsView = false
                            showInfoView.toggle()
                        } label: {
                            Image("info_btn")
                                .resizable()
                                .frame(width: 64, height: 64)
                        }
                    }
                    
                    Spacer().frame(width: 24)
                    
                    NavigationLink(destination: LevelsSweetCrushView()
                        .environmentObject(userData)
                        .navigationBarBackButtonHidden(true)) {
                        Image("play_btn")
                            .resizable()
                            .frame(width: 128, height: 128)
                    }
                    Spacer().frame(width: 24)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: LeadingBoardView()
                        .environmentObject(userData)
                        .navigationBarBackButtonHidden(true)) {
                        Image("leader_board")
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettingsView.toggle()
                        showInfoView = false
                    } label: {
                        Image("settings")
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                }
            }
            .preferredColorScheme(.dark)
            .background(
                Image(userData.currentBackground)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.5)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            )
            .animation(.easeInOut)
            .onAppear {
                if UserDefaults.standard.string(forKey: "user_background") == nil {
                    UserDefaults.standard.set("Background", forKey: "user_background")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func showRateAppDialog() {
        let alertController = UIAlertController(title: "Enjoying the App?", message: "Would you like to rate us on the App Store?", preferredStyle: .alert)
        
        let remindLaterAction = UIAlertAction(title: "Remind Me Later", style: .default, handler: nil)
        let rateAction = UIAlertAction(title: "Rate Now", style: .default) { _ in
            // Replace "YOUR_APP_ID" with the actual ID of your app
            if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review") {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(remindLaterAction)
        alertController.addAction(rateAction)
        alertController.addAction(cancelAction)
        
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
}

#Preview {
    ContentView()
}
