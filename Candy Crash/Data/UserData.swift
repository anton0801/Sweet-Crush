//
//  UserData.swift
//  Candy Crash
//
//  Created by Anton on 20/2/24.
//

import Foundation

class UserData : ObservableObject {
    
    @Published var scoreGaned = UserDefaults.standard.integer(forKey: "score_ganed")
    @Published var unlockedLevels: [String] = []
    @Published var wallpapersBuyed: [String] = []
    private var allLevels: [String] = []
    @Published var currentBackground = UserDefaults.standard.string(forKey: "user_background") ?? "Background"
    
    init() {
        let unlocked = UserDefaults.standard.string(forKey: "unlocked_levels") ?? "Level_0,"
        let components = unlocked.components(separatedBy: ",")
        for level in components {
            unlockedLevels.append(level)
        }
        getWallpapersBuyed()
        
        for indexLevel in 0..<100 {
            allLevels.append("Level_\(indexLevel)")
        }
    }
    
    func addScore(score: Int) {
        scoreGaned += score
        UserDefaults.standard.set(scoreGaned, forKey: "score_ganed")
    }
    
    func unlockNextLevel(currentLevel: String) {
        print("Current level: \(currentLevel)")
        let levelNum = Int(currentLevel.components(separatedBy: "_")[1])!
        let nextLevelNum = levelNum + 1
        if nextLevelNum < 100 {
            print("Passed level: Level_\(levelNum)")
            print("Next unlocked level: Level_\(nextLevelNum)")
            unlockedLevels.append("Level_\(nextLevelNum)")
            print("Unlocked levels: \(unlockedLevels)")
            UserDefaults.standard.set(unlockedLevels.joined(separator: ","), forKey: "unlocked_levels")
        }
        
//        let unlocked = UserDefaults.standard.string(forKey: "unlocked_levels") ?? "Level_0,"
//        var components = unlocked.components(separatedBy: ",")
//        let lastIndex = components.count - 1
//        if lastIndex < allLevels.count {
//            components.append(allLevels[lastIndex + 1])
//            UserDefaults.standard.set(components.joined(separator: ","), forKey: "unlocked_levels")
//        }
    }
    
    func buyWallpaper(price: Int, wallpaperName: String) -> Bool {
        if price < scoreGaned {
            scoreGaned -= price
            UserDefaults.standard.setValue(scoreGaned, forKey: "score_ganed")
            let wallpapers = UserDefaults.standard.string(forKey: "wallpapers_buyed") ?? "Background,"
            var components = wallpapers.components(separatedBy: ",")
            components.append(wallpaperName)
            UserDefaults.standard.setValue(components.joined(separator: ","), forKey: "wallpapers_buyed")
            getWallpapersBuyed()
            return true
        }
        return false
    }
    
    func getWallpapersBuyed() {
        let wallpapers = UserDefaults.standard.string(forKey: "wallpapers_buyed") ?? "Background,"
        let components = wallpapers.components(separatedBy: ",")
        for wallpaper in components {
            wallpapersBuyed.append(wallpaper)
        }
    }
    
}
