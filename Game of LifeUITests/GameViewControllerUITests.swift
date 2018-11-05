import XCTest
import Nimble

class GameViewControllerUITests: XCTestCase {
   
   var app: XCUIApplication!
   
   override func setUp() {
      super.setUp()
      continueAfterFailure = false
      app = XCUIApplication()
      app.launch()
   }
   
   func testUserAction() {
      let gameView = app.otherElements["GameView"]
      let playButton = app.buttons["PlayButton"]
      let randomButton = app.buttons["RandomButton"]
      let stopButton = app.buttons["StopButton"]
      
      expect(gameView.isHittable).to(beTrue())
      expect(gameView.exists).to(beTrue())
      expect(playButton.isHittable).to(beTrue())
      expect(playButton.exists).to(beTrue())
      expect(randomButton.isHittable).to(beTrue())
      expect(randomButton.exists).to(beTrue())
      expect(stopButton.exists).to(beFalsy())
      playButton.tap()
      expect(stopButton.isHittable).to(beTrue())
      expect(stopButton.exists).to(beTrue())      
      expect(playButton.exists).to(beFalsy())
   }
}
