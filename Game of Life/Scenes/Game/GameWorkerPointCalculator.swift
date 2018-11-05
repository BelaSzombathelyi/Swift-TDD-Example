import UIKit

class GameWorkerPointCalculator {
   
   func calculateIndexes(fromLocation location: CGPoint, viewSize: CGSize, dimensions: Game.Model.Dimensions) -> (row: Int, column: Int) {
      let tileWidth = viewSize.width / CGFloat(dimensions.width)
      let tileHeight = viewSize.height / CGFloat(dimensions.height)
      let tileWidthCount = location.x / tileWidth
      let tileHeightCount = location.y / tileHeight
      return (row: Int(tileHeightCount), column: Int(tileWidthCount))
   }
}
