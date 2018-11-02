import UIKit

protocol GamePresentationLogic {
   func presentNextUniverse(response: Game.NextStepResponse)
}

class GamePresenter: GamePresentationLogic {
   weak var viewController: GameDisplayLogic?
   
   // MARK: Present next universe
   
   func presentNextUniverse(response: Game.NextStepResponse) {
      let viewModel = Game.ViewModel(universe: response.universe)
      viewController?.displayNextUniverse(viewModel: viewModel)
   }
}

