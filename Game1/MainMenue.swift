import SpriteKit

class MainMenue: SKScene {
    
    var snowfild:SKEmitterNode!
    
    var newGameButtonNode:SKSpriteNode!
    var newLevelButtonNode:SKSpriteNode!
    var levelLabelNode:SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        //escapeMenueButtonNode = SKSpriteNode(imageNamed: "menu")
        //escapeMenueButtonNode.position = CGPoint(x: UIScreen.main.bounds.width - 70, y: UIScreen.main.bounds.height - 50)
        
        //snowfild = self.childNode(withName: "backSnow") as? SKEmitterNode
        //snowfild.advanceSimulationTime(10)
        
        snowfild = SKEmitterNode(fileNamed: "BackSnow")
        self.addChild(snowfild)
        
        newGameButtonNode = SKSpriteNode(imageNamed: "StartButton")
        newGameButtonNode.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
        newGameButtonNode.texture = SKTexture(imageNamed: "StartButton")
        newGameButtonNode.setScale(0.3)
        self.addChild(newGameButtonNode)
        
        newLevelButtonNode = SKSpriteNode(imageNamed: "labelLevel")
        newLevelButtonNode.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 300)
        newLevelButtonNode.texture = SKTexture(imageNamed: "LevelButton")
        self.addChild(newLevelButtonNode)
        
        levelLabelNode = SKLabelNode(text: "Легко")
        levelLabelNode.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 500)
        levelLabelNode.fontName = "Blood"
        levelLabelNode.fontSize = 50
        self.addChild(levelLabelNode)
        
        
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
