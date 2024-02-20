//
//  CandyCrashGameView.swift
//  Candy Crash
//
//  Created by Anton on 19/2/24.
//

import SpriteKit
import SwiftUI
import AVKit

struct CandyCrashGameView: View {
    
    @Environment(\.presentationMode) var presentMode
    
    @EnvironmentObject var userData: UserData
    
    var level: String
    var levelWithoutC: String
    
    @State var modelLevel: Level!
    
    @State var targetScore = 0
    @State var movesLeft = 15
    @State var score = 0
    @State var gameStatus = GameResultState(isWin: false, isCompleted: false)
    
    @State var isAudioEnabled: Bool = true
    
    @State var backgroundMusic: AVAudioPlayer? = {
      guard let url = Bundle.main.url(forResource: "back_track", withExtension: "mp3") else {
        return nil
      }
      do {
        let player = try AVAudioPlayer(contentsOf: url)
        player.numberOfLoops = -1
        return player
      } catch {
        return nil
      }
    }()
    
    var body: some View {
        VStack {
            if !gameStatus.isCompleted {
                ZStack {
                    GameView(levelText: level, targetScore: $targetScore, movesLeft: $movesLeft, score: $score, gameStatus: $gameStatus)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text("Target Score:")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .medium))
                                Text("\(targetScore)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Moves Left:")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                Text("\(movesLeft)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Score:")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                Text("\(score)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.pink)
                        )
                        .padding()
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                if isAudioEnabled {
                                    self.backgroundMusic?.pause()
                                    isAudioEnabled = false
                                } else {
                                    self.backgroundMusic?.play()
                                    isAudioEnabled = true
                                }
                            } label: {
                                if isAudioEnabled {
                                    Image("audio_on")
                                        .resizable()
                                        .frame(width: 72, height: 72)
                                } else {
                                    Image("audio_off")
                                        .resizable()
                                        .frame(width: 72, height: 72)
                                }
                            }
                            .padding(.trailing)
                        }
                    }
                }
            } else {
                VStack {
                    VStack {
                        Text("Game Result:")
                            .foregroundColor(.pink)
                            .font(.system(size: 24, weight: .bold))
                        
                        Spacer().frame(height: 12)
                        
                        Text("Score: \(score)")
                            .foregroundColor(.pink)
                            .font(.system(size: 32, weight: .bold))
                        
                        Spacer().frame(height: 12)
                        
                        Button {
                            presentMode.wrappedValue.dismiss()
                        } label: {
                            Image("home")
                                .resizable()
                                .frame(width: 42, height: 42)
                        }
                    }
                    .frame(width: 300, height: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white)
                    )
                    .shadow(radius: 10, x: 4, y: 1)
                    .onAppear {
                        let maxScore1 = UserDefaults.standard.integer(forKey: "max_score_1")
                        let maxScore2 = UserDefaults.standard.integer(forKey: "max_score_2")
                        let maxScore3 = UserDefaults.standard.integer(forKey: "max_score_3")
                        
                        if score > maxScore1 {
                            UserDefaults.standard.set(maxScore1, forKey: "max_score_2")
                            UserDefaults.standard.set(maxScore2, forKey: "max_score_3")
                            UserDefaults.standard.set(score, forKey: "max_score_1")
                        } else if score > maxScore2 && score < maxScore1 {
                            UserDefaults.standard.set(maxScore2, forKey: "max_score_3")
                            UserDefaults.standard.set(score, forKey: "max_score_2")
                        } else if score > maxScore3 && score < maxScore2 {
                            UserDefaults.standard.set(score, forKey: "max_score_3")
                        }
                        
                        if score >= targetScore {
                            userData.addScore(score: score)
                            userData.unlockNextLevel(currentLevel: self.levelWithoutC)
                        }
                    }
                }
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
        }
        .onAppear {
            modelLevel = Level(filename: level)
            movesLeft = modelLevel.moves
            targetScore = modelLevel.targetScore
            
            if !isAudioEnabled {
                self.backgroundMusic?.pause()
            } else {
                self.backgroundMusic?.play()
            }
        }
    }
}

struct GameView: UIViewRepresentable {
    
    var levelText: String
    
    @Binding var targetScore: Int
    @Binding var movesLeft: Int
    @Binding var score: Int
    @Binding var gameStatus: GameResultState
    
    func makeUIView(context: Context) -> SKView {
        // Configure the view
        let skView = SKView()
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.isMultipleTouchEnabled = false
        
        // Set the frame of skView to match the width of the screen
       if let window = UIApplication.shared.windows.first {
           let sceneWidth = window.frame.size.width
           let sceneHeight = window.frame.size.height // Or set it to a specific height if needed
           skView.frame = CGRect(x: 0, y: 0, width: sceneWidth, height: sceneHeight)
       }
        
        print("Game view bounds: \(skView.bounds.size)")

        if skView.bounds.size != CGSize.zero {
            let scene = GameScene(size: skView.bounds.size)
            let level = Level(filename: levelText)
            scene.scaleMode = .aspectFill
            scene.level = level
            targetScore = level.targetScore
            scene.swipeHandler = { swap in
                skView.isUserInteractionEnabled = false
                if movesLeft > 0 {
                  movesLeft -= 1
                  
                  if level.isPossibleSwap(swap) {
                    score += 200
                    level.performSwap(swap)
                    scene.animate(swap) {
                        skView.isUserInteractionEnabled = true
                    }
                  } else {
                    scene.animateInvalidSwap(swap) {
                        skView.isUserInteractionEnabled = true
                    }
                  }
                    
                    if movesLeft == 0 {
                        if level.targetScore > score {
                            gameStatus = GameResultState(isWin: false, isCompleted: true)
                        } else {
                            gameStatus = GameResultState(isWin: true, isCompleted: true)
                        }
                    }
                } else {
                  if level.targetScore > score {
                      gameStatus = GameResultState(isWin: false, isCompleted: true)
                  } else {
                      gameStatus = GameResultState(isWin: true, isCompleted: true)
                  }
                }
            }
            movesLeft = level.moves
            
            skView.presentScene(scene)
            scene.addTiles()
            
            let newCookies = level.shuffle()
            scene.addSprites(for: newCookies)
       }
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Update the view
    }

}

struct GameResultState {
    var isWin: Bool
    var isCompleted: Bool
}

#Preview {
    CandyCrashGameView(level: "Level_1", levelWithoutC: "Level_1")
}
