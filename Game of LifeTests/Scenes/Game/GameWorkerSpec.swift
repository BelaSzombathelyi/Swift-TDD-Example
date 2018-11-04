import Quick
import Nimble
@testable import Game_of_Life

extension Universe {
   
   fileprivate static func cleanUniverse(withDimensions dimensions: Dimensions, _ editCloser: (_ dimensions: Dimensions, _ cells: inout [[Bool]]) -> Void = { _, _ in }) -> Universe {
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

class GameWorkerSpec: QuickSpec {
   
   override func spec() {
      let worker = GameWorker()

      describe("neighborCount(forRow:column:in:)") {
         it("one neighbord") {
            let universe = Universe.cleanUniverse(withDimensions: Dimensions(width: 7, height: 7)) { dimension, cells in
               cells[3][3] = true
            }
            expect(worker.neighborCount(forRow: 3, column: 3, in: universe)).toEventually(be(0))
            expect(worker.neighborCount(forRow: 2, column: 3, in: universe)).toEventually(be(1))
            expect(worker.neighborCount(forRow: 2, column: 2, in: universe)).toEventually(be(1))
            expect(worker.neighborCount(forRow: 4, column: 4, in: universe)).toEventually(be(1))
            expect(worker.neighborCount(forRow: 4, column: 3, in: universe)).toEventually(be(1))
            expect(worker.neighborCount(forRow: 4, column: 2, in: universe)).toEventually(be(1))
         }
         it("two neighbord") {
            let universe = Universe.cleanUniverse(withDimensions: Dimensions(width: 7, height: 7)) { dimension, cells in
               cells[2][3] = true
               cells[3][3] = true
            }
            expect(worker.neighborCount(forRow: 1, column: 3, in: universe)).toEventually(be(1))
            expect(worker.neighborCount(forRow: 2, column: 3, in: universe)).toEventually(be(1))
            expect(worker.neighborCount(forRow: 3, column: 3, in: universe)).toEventually(be(1))
            expect(worker.neighborCount(forRow: 4, column: 3, in: universe)).toEventually(be(1))
            
            expect(worker.neighborCount(forRow: 2, column: 2, in: universe)).toEventually(be(2))
            expect(worker.neighborCount(forRow: 3, column: 2, in: universe)).toEventually(be(2))
            expect(worker.neighborCount(forRow: 2, column: 4, in: universe)).toEventually(be(2))
            expect(worker.neighborCount(forRow: 3, column: 4, in: universe)).toEventually(be(2))
         }
         it("two neighbord on border") {
            let universe = Universe.cleanUniverse(withDimensions: Dimensions(width: 7, height: 7)) { dimension, cells in
               cells[0][0] = true
               cells[0][1] = true
            }
            expect(worker.neighborCount(forRow: 0, column: 0, in: universe)).toEventually(be(1))
            expect(worker.neighborCount(forRow: 0, column: 1, in: universe)).toEventually(be(1))
            expect(worker.neighborCount(forRow: 0, column: 2, in: universe)).toEventually(be(1))
            
            expect(worker.neighborCount(forRow: 1, column: 0, in: universe)).toEventually(be(2))
            expect(worker.neighborCount(forRow: 1, column: 1, in: universe)).toEventually(be(2))
            
            expect(worker.neighborCount(forRow: 0, column: 3, in: universe)).toEventually(be(0))
            expect(worker.neighborCount(forRow: 2, column: 0, in: universe)).toEventually(be(0))
         }
      }
      
      describe("calculateNextStep(fromUniverse:)") {
         describe("1. Rule: Underpopulation") {
            it("one element") {
               let universe = Universe.cleanUniverse(withDimensions: Dimensions(width: 7, height: 7)) { dimension, cells in
                  cells[3][3] = true
               }
               let nextUniverse = worker.calculateNextStep(fromUniverse: universe)
               expect(nextUniverse.count(ofValue: true)).toEventually(be(0))
            }
            it("two element") {
               let universe = Universe.cleanUniverse(withDimensions: Dimensions(width: 7, height: 7)) { dimension, cells in
                  cells[3][3] = true
                  cells[3][4] = true
               }
               let nextUniverse = worker.calculateNextStep(fromUniverse: universe)
               expect(nextUniverse.count(ofValue: true)).toEventually(be(0))
            }
         }
         
         describe("2. Rule: lives by neighbors") {
            it("two neighbors") {
               let universe = Universe.cleanUniverse(withDimensions: Dimensions(width: 7, height: 7)) { dimension, cells in
                  cells[2][3] = true
                  cells[3][3] = true
                  cells[4][3] = true
               }
               let nextUniverse = worker.calculateNextStep(fromUniverse: universe)
               expect(nextUniverse.cells[3][3]).toEventually(beTrue())
            }
            it("three neighbors") {
               let universe = Universe.cleanUniverse(withDimensions: Dimensions(width: 7, height: 7)) { dimension, cells in
                  cells[2][3] = true
                  cells[3][3] = true
                  cells[4][3] = true
                  cells[3][2] = true
               }
               let nextUniverse = worker.calculateNextStep(fromUniverse: universe)
               expect(nextUniverse.cells[3][3]).toEventually(beTrue())
            }
         }
         
         describe("3. Rule: Overpopulation") {
            it("") {
               let universe = Universe.cleanUniverse(withDimensions: Dimensions(width: 7, height: 7)) { dimension, cells in
                  cells[2][3] = true
                  cells[3][3] = true
                  cells[4][3] = true
                  cells[3][2] = true
                  cells[2][2] = true
               }
               let nextUniverse = worker.calculateNextStep(fromUniverse: universe)
               expect(nextUniverse.cells[3][3]).toEventually(beFalse())
            }
         }
         
         describe("4. Rule: Reproduction") {
            it("") {
               let universe = Universe.cleanUniverse(withDimensions: Dimensions(width: 7, height: 7)) { dimension, cells in
                  cells[2][3] = true
                  cells[3][3] = true
                  cells[4][3] = true
               }
               let nextUniverse = worker.calculateNextStep(fromUniverse: universe)
               expect(nextUniverse.cells[3][2]).toEventually(beTrue())
               expect(nextUniverse.cells[3][4]).toEventually(beTrue())
            }
         }
      }
   }
}
