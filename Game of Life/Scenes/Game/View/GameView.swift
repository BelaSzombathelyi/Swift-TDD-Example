import UIKit
import CoreGraphics

class GameView: UIView {
	
   private lazy var canvas: CAShapeLayer = {
      var canvas = CAShapeLayer()
      canvas.fillColor = UIColor.yellow.cgColor
      layer.addSublayer(canvas)
      return canvas
   }()
	
   private func path(forPresentUniverse universe: Game.Universe) -> UIBezierPath {
      let size = self.frame.size
      let cellHeight = size.height / CGFloat(universe.dimensions.height)
      let cellWidth = size.width / CGFloat(universe.dimensions.width)
      let cellSize = CGSize(width: cellWidth, height: cellHeight)
      
      let path = UIBezierPath()
      for row in 0..<universe.dimensions.height {
         let y = CGFloat(row) * cellHeight
         for column in 0..<universe.dimensions.width {
            let value = universe.cells[Int(row)][Int(column)]
            if (!value) {
               continue
            }
            let x = CGFloat(column) * cellWidth
            let point = CGPoint(x: x, y: y)
            let rect = CGRect(origin: point, size: cellSize)
            let cellPath = UIBezierPath(rect: rect.integral)
            path.append(cellPath)
         }
      }
      return path
   }
   
   func display(universe: Game.Universe) {
      let path = self.path(forPresentUniverse: universe)
      canvas.frame = self.bounds
      canvas.path = path.cgPath
   }
}
