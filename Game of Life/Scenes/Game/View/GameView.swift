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
      let path = UIBezierPath()
      for row in 0..<universe.dimensions.height {
         for column in 0..<universe.dimensions.width {
            let value = universe.cells[Int(row)][Int(column)]
            if (!value) {
               continue
            }
            let point = CGPoint(x: Int(column), y: Int(row))
            let rect = CGRect(origin: point, size: CGSize(width: 1, height: 1))
            path.append(UIBezierPath(rect: rect))
         }
      }
      return path
   }
   
   func display(universe: Game.Universe) {
      let path = self.path(forPresentUniverse: universe)
      canvas.frame = self.bounds
      canvas.path = path.cgPath
   }
   
   func update(byDimensions dimensions: Game.Dimensions) {
      let scaleX = self.frame.size.width / CGFloat(dimensions.width)
      let scaleY = self.frame.size.height / CGFloat(dimensions.height)
      let transform2D = CGAffineTransform(scaleX: scaleX, y: scaleY)
      canvas.transform = CATransform3DMakeAffineTransform(transform2D)
      canvas.frame = self.bounds
   }
}
