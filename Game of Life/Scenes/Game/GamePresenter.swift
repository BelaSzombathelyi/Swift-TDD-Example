import UIKit

protocol GamePresentationLogic {
   func presentNextUniverse(response: Game.DisplayLoop.Response)
}

class GamePresenter: GamePresentationLogic {
   weak var viewController: GameDisplayLogic?
   
   // MARK: Present next universe
   
   func presentNextUniverse(response: Game.DisplayLoop.Response) {
      let viewModel = Game.DisplayLoop.ViewModel(universe: response.universe)
      viewController?.displayUniverse(viewModel: viewModel)
   }
}

