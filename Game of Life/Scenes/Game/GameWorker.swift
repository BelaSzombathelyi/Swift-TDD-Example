import UIKit

class GameWorker {
   
   func neighborCount(forRow row: Int, column: Int, in universe: Game.Universe) -> Int {
      var count = 0
      let minRowIndex = max(row - 1, 0)
      let maxRowIndex = min(row + 2, Int(universe.dimensions.height))
      
      let minColumnIndex = max(column - 1, 0)
      let maxColumnIndex = min(column + 2, Int(universe.dimensions.width))
      
      for rowIndex in minRowIndex..<maxRowIndex {
         for columnIndex in minColumnIndex..<maxColumnIndex {
            if (rowIndex == row && columnIndex == column) {
               continue
            }
            let value = universe.cells[Int(rowIndex)][Int(columnIndex)]
            if (value) {
               count += 1
            }
         }
      }
      return count
   }
   
   func calculateNextStep(fromUniverse universe: Game.Universe) -> Game.Universe {
      var cells = universe.cells
      for row in 0..<universe.dimensions.height {
         for column in 0..<universe.dimensions.width {
            let neighborCount = self.neighborCount(forRow: Int(row), column: Int(column), in: universe)
            let value = universe.cells[Int(row)][Int(column)]
            
            if (value) {//Live
               if (![2,3].contains(neighborCount)) {
                  cells[Int(row)][Int(column)] = false
               }
            } else {
               if (neighborCount == 3) {
                  cells[Int(row)][Int(column)] = true
               }
            }
         }
      }
      return Game.Universe(dimensions: universe.dimensions, cells: cells)
   }
}
