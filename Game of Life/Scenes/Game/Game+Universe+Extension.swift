//
//  Game+Universe+Extension.swift
//  Game of Life
//
//  Created by Béla Szomathelyi on 2018. 11. 05..
//  Copyright © 2018. Béla Szomathelyi. All rights reserved.
//

import UIKit

extension Game.Model.Universe {
   typealias Dimensions = Game.Model.Dimensions
   typealias Universe = Game.Model.Universe

   init(dimensions: Dimensions, randomFill: Bool = true, _ editCloser: ((_ dimensions: Dimensions, _ cells: inout [[Bool]]) -> Void)? = nil){
      var cells: [[Bool]]!
      if (randomFill) {
         cells = Universe.randomCells(withDimensions: dimensions)
      } else {
         cells = Universe.emptyCells(withDimensions: dimensions)
      }
      editCloser?(dimensions, &cells)
      self.init(cells: cells, dimensions: dimensions)
   }
   
   private static func emptyCells(withDimensions dimensions: Dimensions) -> [[Bool]] {
      var cells = [[Bool]]()
      for _ in 0..<dimensions.height {
         let row = Array(repeating: false, count: Int(dimensions.width))
         cells.append(row)
      }
      return cells
   }
   
   private static func randomCells(withDimensions dimensions: Dimensions) -> [[Bool]] {
      var cells = self.emptyCells(withDimensions: dimensions)
      for i in 0..<dimensions.height {
         for j in 0..<dimensions.width {
            let value = arc4random_uniform(UInt32(2))
            cells[Int(i)][Int(j)] = value == 0
         }
      }
      return cells
   }
}
