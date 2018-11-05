import Quick
import Nimble
@testable import Game_of_Life

class GameModelsSpec: QuickSpec {
   
   override func spec() {
      
      context("Game.Universe") {
         it("init(dimensions:cells:) simple store and read back") {
            var cells = [[false, true], [true, false]]
            let universe = Game.Model.Universe(cells: cells, dimensions: Game.Model.Dimensions(width: 2, height: 2))
            for row in 0..<cells.count {
               for column in 0..<cells[row].count {
                  expect(universe.cells[row][column] == cells[row][column]).toEventually(beTrue())
               }
            }
         }
         it("init(dimensions:)") {
            let dimensions = Game.Model.Dimensions(width: 5, height: 8);
            let universe = Game.Model.Universe(dimensions: dimensions)
            for row in 0..<universe.cells.count {
               expect(universe.cells[row].count == dimensions.width).toEventually(beTrue())
            }
            expect(universe.cells.count == dimensions.height).toEventually(beTrue())
         }
      }
   }
}
