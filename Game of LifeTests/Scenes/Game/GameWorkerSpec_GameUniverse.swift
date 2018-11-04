@testable import Game_of_Life

extension Universe {
   
   static func cleanUniverse(withDimensions dimensions: Dimensions, _ editCloser: (_ dimensions: Dimensions, _ cells: inout [[Bool]]) -> Void = { _, _ in }) -> Universe {
      var table = [[Bool]]()
      for _ in 0..<dimensions.height {
         let row = Array(repeating: false, count: Int(dimensions.width))
         table.append(row)
      }
      editCloser(dimensions, &table)
      return Universe(dimensions: dimensions, cells: table)
   }
   
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
