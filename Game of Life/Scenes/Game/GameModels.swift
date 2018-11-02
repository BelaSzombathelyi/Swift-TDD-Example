import UIKit

enum Game {
   struct Dimensions {
      let width: UInt8
      let height: UInt8
   }
   
   struct Universe {
      let cells: [[Bool]]
      let dimensions: Dimensions
      
      //Create universe with random data
      init(dimensions: Dimensions) {
         var table = [[Bool]]()
         for _ in 0..<dimensions.height {
            var row = [Bool]()
            for _ in 0..<dimensions.width {
               let value = arc4random_uniform(UInt32(2))
               row.append(value == 0)
            }
            table.append(row)
         }
         self.init(dimensions: dimensions, cells: table)
      }
      
      init(dimensions: Dimensions, cells: [[Bool]]) {
         self.dimensions = dimensions
         self.cells = cells
      }
   }
   
   struct NextStepRequest {
      let universe: Universe
   }
   
   struct NextStepResponse {
      let universe: Universe
   }
   
   struct ViewModel {
      let universe: Universe
   }
   
}

