import SpriteKit
import CoreData

class MainMenue: SKScene {
    
    var snowfild:SKEmitterNode!
    let scoreBest = UserDefaults.standard
    var newGameButtonNode:SKSpriteNode!
    var newLevelButtonNode:SKSpriteNode!
    var levelLabelNode:SKLabelNode!
    var bestScoreLabel:SKLabelNode!
    var bestScore:Int = 0{
        didSet{
            bestScoreLabel.text = "Лучший рузельтат: \(scoreBest.integer(forKey: "BestScore"))"
        }
    }
    
    override func didMove(to view: SKView) {
        
        print(scoreBest.integer(forKey: "BestScore"))
        
        snowfild = SKEmitterNode(fileNamed: "BackSnow")
        snowfild.advanceSimulationTime(10)
        self.addChild(snowfild)
        
        newGameButtonNode = SKSpriteNode(imageNamed: "StartButton")
        newGameButtonNode.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - (UIScreen.main.bounds.height/5))
        newGameButtonNode.texture = SKTexture(imageNamed: "StartButton")
        newGameButtonNode.setScale(0.3)
        self.addChild(newGameButtonNode)
        
        newLevelButtonNode = SKSpriteNode(imageNamed: "labelLevel")
        newLevelButtonNode.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 2 * (UIScreen.main.bounds.height / 5))
        newLevelButtonNode.texture = SKTexture(imageNamed: "LevelButton")
        self.addChild(newLevelButtonNode)
        
        levelLabelNode = SKLabelNode(text: "Легко")
        levelLabelNode.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 3 * (UIScreen.main.bounds.height / 5))
        levelLabelNode.fontName = "Blood"
        levelLabelNode.fontSize = 50
        self.addChild(levelLabelNode)
        
        bestScoreLabel = SKLabelNode(text: "Лучший рeзyльтат: \(scoreBest.integer(forKey: "BestScore"))")
        bestScoreLabel.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 4 * (UIScreen.main.bounds.height / 5))
        bestScoreLabel.fontName = "Blood"
        bestScoreLabel.fontSize = 30
        self.addChild(bestScoreLabel)
        
        
        let userLevel = UserDefaults.standard
        if userLevel.bool(forKey: "hard"){
            levelLabelNode.text = "H A R D !"
        }else{
            levelLabelNode.text = "Легко"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for touch in touches {
           let location = touch.location(in: self)
            if newGameButtonNode.contains(location) {
                let transit = SKTransition.flipVertical(withDuration: 1)
                let gameScene = GameScene(size: UIScreen.main.bounds.size)
                
                self.view?.presentScene(gameScene, transition: transit)
            }
            if newLevelButtonNode.contains(location){
                changeLevel()
            }
        }
    }
    
    func changeLevel(){
        let userLevel = UserDefaults.standard
        
        if levelLabelNode.text == "Легко"{
            levelLabelNode.text = "H A R D !"
            userLevel.set(true, forKey: "hard")
            
        }else{
            levelLabelNode.text = "Легко"
            userLevel.set(false, forKey: "hard")
        }
        userLevel.synchronize()
    }
}
