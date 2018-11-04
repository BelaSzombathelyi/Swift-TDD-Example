import Quick
import Nimble
@testable import Game_of_Life

class GameModelsSpec: QuickSpec {
   
   override func spec() {
      
      context("Game.Universe") {
         it("init(dimensions:cells:) simple store and read back") {
            var cells = [[false, true], [true, false]]
            let universe = Universe(dimensions: Dimensions(width: 2, height: 2), cells: cells)
            for row in 0..<cells.count {
               for column in 0..<cells[row].count {
                  expect(universe.cells[row][column] == cells[row][column]).toEventually(beTrue())
               }
            }
         }
         it("init(dimensions:) row length check") {
            let dimensions = Dimensions(width: 5, height: 8);
            let universe = Universe(dimensions: dimensions)
            for row in 0..<universe.cells.count {
               expect(universe.cells[row].count == dimensions.width).toEventually(beTrue())
            }
         }
         it("init(dimensions:) row count check") {
            let dimensions = Dimensions(width: 5, height: 8);
            let universe = Universe(dimensions: dimensions)
            expect(universe.cells.count == dimensions.height).toEventually(beTrue())
         }
      }
   }
}
