import Foundation

let numColumns = 9
let numRows = 9

class Level {
  private var cookies = Array2D<Cookie>(columns: numColumns, rows: numRows)
  private var tiles = Array2D<Tile>(columns: numColumns, rows: numRows)
  private var possibleSwaps: Set<Swap> = []
  
  var targetScore = 0
  var moves = 0
  
  init(filename: String) {
    // 1
    guard let levelData = LevelData.loadFrom(file: filename) else { return }
    // 2
    let tilesArray = levelData.tiles
    // 3
    for (row, rowArray) in tilesArray.enumerated() {
      // 4
      let tileRow = numRows - row - 1
      // 5
      for (column, value) in rowArray.enumerated() {
        if value == 1 {
          tiles[column, tileRow] = Tile()
        }
      }
    }
    targetScore = levelData.targetScore
    moves = levelData.moves
  }
  
  func cookie(atColumn column: Int, row: Int) -> Cookie? {
    precondition(column >= 0 && column < numColumns)
    precondition(row >= 0 && row < numRows)
    return cookies[column, row]
  }
  
  func tileAt(column: Int, row: Int) -> Tile? {
    precondition(column >= 0 && column < numColumns)
    precondition(row >= 0 && row < numRows)
    return tiles[column, row]
  }
  
  func shuffle() -> Set<Cookie> {
    var set: Set<Cookie>
    repeat {
      set = createInitialCookies()
      detectPossibleSwaps()
      print("possible swaps: \(possibleSwaps)")
    } while possibleSwaps.count == 0
    
    return set
  }
  
  private func createInitialCookies() -> Set<Cookie> {
    var set: Set<Cookie> = []
    
    // 1
    for row in 0..<numRows {
      for column in 0..<numColumns {
        
        // 2
        if tiles[column, row] != nil {
          var cookieType: CookieType
          repeat {
            cookieType = CookieType.random()
          } while (column >= 2 &&
            cookies[column - 1, row]?.cookieType == cookieType &&
            cookies[column - 2, row]?.cookieType == cookieType)
            || (row >= 2 &&
              cookies[column, row - 1]?.cookieType == cookieType &&
              cookies[column, row - 2]?.cookieType == cookieType)
          
          // 3
          let cookie = Cookie(column: column, row: row, cookieType: cookieType)
          cookies[column, row] = cookie
          
          // 4
          set.insert(cookie)
        }
      }
    }
    return set
  }
  
  private func hasChain(atColumn column: Int, row: Int) -> Bool {
    let cookieType = cookies[column, row]!.cookieType
    
    // Horizontal chain check
    var horizontalLength = 1
    
    // Left
    var i = column - 1
    while i >= 0 && cookies[i, row]?.cookieType == cookieType {
      i -= 1
      horizontalLength += 1
    }
    
    // Right
    i = column + 1
    while i < numColumns && cookies[i, row]?.cookieType == cookieType {
      i += 1
      horizontalLength += 1
    }
    if horizontalLength >= 3 { return true }
    
    // Vertical chain check
    var verticalLength = 1
    
    // Down
    i = row - 1
    while i >= 0 && cookies[column, i]?.cookieType == cookieType {
      i -= 1
      verticalLength += 1
    }
    
    // Up
    i = row + 1
    while i < numRows && cookies[column, i]?.cookieType == cookieType {
      i += 1
      verticalLength += 1
    }
    return verticalLength >= 3
  }
  
  func detectPossibleSwaps() {
    var set: Set<Swap> = []
    
    for row in 0..<numRows {
      for column in 0..<numColumns {
        if column < numColumns - 1,
          let cookie = cookies[column, row] {
          
          // Have a cookie in this spot? If there is no tile, there is no cookie.
          if let other = cookies[column + 1, row] {
            // Swap them
            cookies[column, row] = other
            cookies[column + 1, row] = cookie
            
            // Is either cookie now part of a chain?
            if hasChain(atColumn: column + 1, row: row) ||
              hasChain(atColumn: column, row: row) {
              set.insert(Swap(cookieA: cookie, cookieB: other))
            }
            
            // Swap them back
            cookies[column, row] = cookie
            cookies[column + 1, row] = other
          }
          
          if row < numRows - 1,
            let other = cookies[column, row + 1] {
            cookies[column, row] = other
            cookies[column, row + 1] = cookie
            
            // Is either cookie now part of a chain?
            if hasChain(atColumn: column, row: row + 1) ||
              hasChain(atColumn: column, row: row) {
              set.insert(Swap(cookieA: cookie, cookieB: other))
            }
            
            // Swap them back
            cookies[column, row] = cookie
            cookies[column, row + 1] = other
          }
        }
        
        else if column == numColumns - 1, let cookie = cookies[column, row] {
          if row < numRows - 1,
            let other = cookies[column, row + 1] {
            cookies[column, row] = other
            cookies[column, row + 1] = cookie
            
            // Is either cookie now part of a chain?
            if hasChain(atColumn: column, row: row + 1) ||
              hasChain(atColumn: column, row: row) {
              set.insert(Swap(cookieA: cookie, cookieB: other))
            }
            
            // Swap them back
            cookies[column, row] = cookie
            cookies[column, row + 1] = other
          }
        }
      }
    }
    
    possibleSwaps = set
  }
  
  func performSwap(_ swap: Swap) {
    let columnA = swap.cookieA.column
    let rowA = swap.cookieA.row
    let columnB = swap.cookieB.column
    let rowB = swap.cookieB.row
    
    cookies[columnA, rowA] = swap.cookieB
    swap.cookieB.column = columnA
    swap.cookieB.row = rowA
    
    cookies[columnB, rowB] = swap.cookieA
    swap.cookieA.column = columnB
    swap.cookieA.row = rowB
  }
  
  func isPossibleSwap(_ swap: Swap) -> Bool {
    return possibleSwaps.contains(swap)
  }
}
