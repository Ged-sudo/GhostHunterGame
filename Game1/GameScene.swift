//
//  GameScene.swift
//  Game1
//
//  Created by Евгений Андронов on 02.03.2022.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var snowfild: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score: Int = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var gameTimer: Timer!
    var enemys = ["enemy1", "enemy2", "enemy3", "enemy4", "enemy5"]
    let enemyCategory: UInt32 = 0x1 << 1
    let bulletCategory: UInt32 = 0x1 << 0
    let monitorManager = CMMotionManager()
    var xPosition:CGFloat = 0
    
    
    
    
    override func didMove(to view: SKView) {
        snowfild = SKEmitterNode(fileNamed: "BackSnow")
        snowfild.position = CGPoint(x: 0, y: 1472)
        snowfild.advanceSimulationTime(10)
        snowfild.zPosition = -1
         
        self.addChild(snowfild )
        
        player = SKSpriteNode(imageNamed: "MyPers")
        player.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: 40)
        player.setScale(0.5)
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
         
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontName = "Italic-Blood"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: (self.frame.width) / 4, y: UIScreen.main.bounds.height - 60)
       
        //print(self.frame.width)
        //print(self.frame.height)
        
        self.addChild(scoreLabel)
        
        var timeInterval = 0.75
        
        if UserDefaults.standard.bool(forKey: "hard"){
            timeInterval = 0.5
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(AddEnemy), userInfo: nil, repeats: true)
        
        monitorManager.accelerometerUpdateInterval = 0.1
        monitorManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
            if let accelerometrData = data{
                let accel = accelerometrData.acceleration
                self.xPosition = CGFloat(accel.x) * 0.75 + self.xPosition * 0.25
            }
        }
    }
    
    override func didSimulatePhysics() {
        player.position.x += xPosition * 50
        
        if  player.position.x  < 0{
            player.position = CGPoint(x: UIScreen.main.bounds.width, y: player.position.y)
        }
        if player.position.x > UIScreen.main.bounds.width {
            player.position = CGPoint(x: 0, y: player.position.y)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var enemyBody:SKPhysicsBody
        var bulletBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask{
            enemyBody = contact.bodyA
            bulletBody = contact.bodyB
        }
        else{
            enemyBody = contact.bodyB
            bulletBody = contact.bodyA
        }
        
        if (enemyBody.categoryBitMask & enemyCategory != 0) && (bulletBody.categoryBitMask & bulletCategory != 0){
            collisionElements(bulletNode: bulletBody.node as! SKSpriteNode, enemyNode: enemyBody.node as! SKSpriteNode)
        }
    }
    
    func collisionElements(bulletNode:SKSpriteNode, enemyNode:SKSpriteNode){
        let animation = SKEmitterNode(fileNamed: "Fier")
        
        animation?.position = enemyNode.position
        self.addChild(animation!)
        
        self.run(SKAction.playSoundFileNamed("clapEnemy.wav", waitForCompletion: false))
        
        bulletNode.removeFromParent()
        enemyNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 1)){
            animation?.removeFromParent()
        }
        
        score += 5
    }
    
    
    
    @objc func AddEnemy(){
        enemys = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: enemys) as! [String]
        
        let enemy = SKSpriteNode(imageNamed: enemys[0])
        let positionEnemyBorn = GKRandomDistribution(lowestValue: -320, highestValue: 320)
        let costPos = CGFloat(positionEnemyBorn.nextInt())
        
        enemy.position = CGPoint(x: costPos, y: self.frame.height)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.setScale(0.5)
        
        self.addChild(enemy)
        
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = bulletCategory
        enemy.physicsBody?.collisionBitMask = 0
        
        var speedEnemy:TimeInterval = 30
        
        if UserDefaults.standard.bool(forKey: "hard"){
            speedEnemy = 20
        }
        
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to:CGPoint(x: costPos, y: -10000) , duration: speedEnemy))
        actions.append(SKAction.removeFromParent())
        enemy.run(SKAction.sequence(actions))
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }
    
    func fireBullet(){
        self.run(SKAction.playSoundFileNamed("shot.mp3", waitForCompletion: false))
        
        let bullet = SKSpriteNode(imageNamed: "knife")
        bullet.position = player.position
        bullet.position.y += 15
        
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        bullet.setScale(0.5)
        
        self.addChild(bullet)
        
        bullet.physicsBody?.categoryBitMask = bulletCategory
        bullet.physicsBody?.contactTestBitMask = enemyCategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        let animDuration:TimeInterval = 15
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to:CGPoint(x: player.position.x, y: 10000) , duration: animDuration))
        actions.append(SKAction.removeFromParent())
        bullet.run(SKAction.sequence(actions))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
