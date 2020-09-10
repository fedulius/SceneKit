import SpriteKit
import GameplayKit
import Foundation


class GameScene: SKScene {
    
    var change = true
    var timerFrame: Timer?
    var timerScore: Timer?
    var positionTimer: Timer?
    var circlePosition: CGPoint?
    
    var scores = 0
    var counter = 0
    let label = SKLabelNode(text: "0")
    var radius: CGFloat = 30
    let circle = SKShapeNode(circleOfRadius: 20)
    var enemy = SKShapeNode(circleOfRadius: 30)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        label.position = CGPoint(x: 30, y: size.height - 40)
        
        circle.position = CGPoint(x: frame.midX, y: frame.midY)
        circle.strokeColor = .orange
        circle.fillColor = .green
        circle.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        circle.physicsBody?.isDynamic = true
        circle.physicsBody?.categoryBitMask = BitMaskCategory.player
        circle.physicsBody?.collisionBitMask = BitMaskCategory.enemy
        circle.physicsBody?.contactTestBitMask = BitMaskCategory.enemy
        
        enemy.fillColor = .red
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = BitMaskCategory.enemy
        enemy.physicsBody?.collisionBitMask = BitMaskCategory.player
        enemy.physicsBody?.contactTestBitMask = BitMaskCategory.player
        
        addChild(circle)
        addChild(enemy)
        addChild(label)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        move(node: enemy, to: circle.position, speed: 50)
        startTimerOfscale()
        startTimerOfScores()
        startMovementTimer()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        move(node: circle, to: touches.first!.location(in: self), speed: 100)
    }
    
    override func update(_ currentTime: TimeInterval) {
        circlePosition = circle.position
    }
    
    func move(node: SKNode, to: CGPoint, speed: CGFloat) {
        let x = node.position.x
        let y = node.position.y
        let distance = sqrt((x - to.x) * (x - to.x) + (y - to.y) * (y - to.y))
        let duration = TimeInterval(distance / speed)
        let move = SKAction.move(to: to, duration: duration)
        node.run(move)
    }
    
    func startMovementTimer() {
        positionTimer?.invalidate()
        positionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            self.move(node: self.enemy, to: self.circlePosition!, speed: 70)
        })
    }
    
    func startTimerOfscale() {
        timerFrame?.invalidate()
        timerFrame = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {  _ in
            self.scale(radius: &self.radius, counter: &self.counter)
        })
    }
    
    func startTimerOfScores() {
        timerScore?.invalidate()
        timerScore = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            self.counter(scores: &self.scores)
            self.label.text = "\(self.scores)"
        })
    }
    
    func counter(scores: inout Int) {
        scores += 1
        scores += counter
    }
    
    
    func scale(radius: inout CGFloat, counter: inout Int) {
        counter += 1
        let radius1 = (radius + 1) / radius
        radius = radius + 1
        let action = SKAction.scale(by: radius1, duration: 0)
        self.enemy.run(action)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        let player = BitMaskCategory.player
        let enemy = BitMaskCategory.enemy
        if bodyA == player && bodyB == enemy || bodyA == enemy && bodyB == player {
            let gameOverScene = GameOverScene(size: size)
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameOverScene, transition: reveal)
            gameOverScene.scoreLabel.text = scores.description
            timerScore?.invalidate()
            timerFrame?.invalidate()
            positionTimer?.invalidate()
        }
    }
    
}
