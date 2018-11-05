@testable import Game_of_Life

extension Game.Model.Universe {
   
   func count(ofValue value: Bool) -> Int {
      var counter = 0
      for row in 0..<self.cells.count {
         for column in 0..<self.cells[row].count {
            if (self.cells[row][column] == value) {
               counter += 1
            }
         }
      }
      return counter
   }
}
