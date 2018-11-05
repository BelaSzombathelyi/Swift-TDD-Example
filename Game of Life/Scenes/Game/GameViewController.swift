import UIKit

protocol GameDisplayLogic: class {
   func displayUniverse(viewModel: Game.DisplayLoop.ViewModel)
}

class GameViewController: BaseViewController, GameDisplayLogic {
   
   var interactor: GameBusinessLogic?
   
   // MARK: Setup
   
   override func setup() {
      super.setup()
      let dimensions = Game.Model.Dimensions(width: 10, height: 20)
      let universe = Game.Model.Universe(dimensions: dimensions, randomFill: false)
      let viewController = self
      let interactor = GameInteractor()
      let presenter = GamePresenter()
      viewController.interactor = interactor
      interactor.presenter = presenter
      interactor.currentUniverse = universe
      presenter.viewController = viewController
      tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapRecognizedOnGameView(_:)))
   }

   @IBOutlet weak var gameView: GameView!
   @IBOutlet weak var randomButton: UIButton!
   @IBOutlet weak var playButton: UIButton!
   @IBOutlet weak var stopButton: UIButton!
   var tapRecognizer: UITapGestureRecognizer!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      gameView.addGestureRecognizer(tapRecognizer)
   }

   // MARK: Actions
   
   @IBAction func didSelectPlayButton() {
      playButton.isHidden = true
      stopButton.isHidden = !playButton.isHidden
      randomButton.isEnabled = false
      interactor?.start(request: Game.DisplayLoop.Request(stepTimeInterval: 0.3))
      tapRecognizer.isEnabled = false
   }
   
   @IBAction func didSelectStopButton() {
      playButton.isHidden = false
      stopButton.isHidden = !playButton.isHidden
      randomButton.isEnabled = true
      interactor?.stop()
      tapRecognizer.isEnabled = true
   }
   
   @IBAction func didSelectRandomButton() {
      guard var dataStore = self.interactor as? GameDataStore else { assertionFailure(); return }
      guard let dimensions = dataStore.currentUniverse?.dimensions else { assertionFailure(); return }
      dataStore.currentUniverse = Game.Model.Universe(dimensions: dimensions, randomFill: true)
      interactor?.update()
   }
   
   @objc func onTapRecognizedOnGameView(_ recognizer: UITapGestureRecognizer) {
      let location = recognizer.location(in: gameView)
      interactor?.userInput(request: Game.UserInputAction.Request(location: location, viewSize: gameView.bounds.size))
   }

   func updateDisplayedUniverse(withDimensions dimensions: Game.Model.Dimensions) {
      gameView.update(byDimensions: dimensions)
   }
   
   // MARK: GameDisplayLogic
   
   func displayUniverse(viewModel: Game.DisplayLoop.ViewModel) {
      gameView.display(universe: viewModel.universe)
      updateDisplayedUniverse(withDimensions: viewModel.universe.dimensions)
   }
}

