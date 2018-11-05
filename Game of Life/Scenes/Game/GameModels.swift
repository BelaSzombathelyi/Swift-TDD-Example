import UIKit

enum Game {
   enum Model {
      struct Dimensions {
         let width: UInt8
         let height: UInt8
      }
      struct Universe {
         let cells: [[Bool]]
         let dimensions: Dimensions
      }
   }
   enum DisplayLoop {
      struct Request {
         let stepTimeInterval: TimeInterval
      }
      struct Response {
         let universe: Game.Model.Universe
      }
      struct ViewModel {
         let universe: Game.Model.Universe
      }
   }
   enum UserInputAction {
      struct Request {
         let location: CGPoint
         let viewSize: CGSize
      }
   }
}

