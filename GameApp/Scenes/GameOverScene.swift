import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let label = SKLabelNode(text: "Game Over!")
    let scoreLabel = SKLabelNode(text: "\(0)")
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 40)
        
        addChild(label)
        addChild(scoreLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let gameScene = GameScene(size: size)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(gameScene, transition: reveal)
    }
}
