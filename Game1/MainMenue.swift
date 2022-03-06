import SpriteKit
import CoreData

class MainMenue: SKScene {
    let scoreBest = UserDefaults.standard
    var snowfild:SKEmitterNode!
    var labelNameGameNode:SKLabelNode!
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
        
        //поправить отображение сделать адаптивным под все экраны, а то на больших съезжает все нахер =(
        //найти новые спрайты под кнопки в меню и поискать шрифты
        
        snowfild = SKEmitterNode(fileNamed: "BackSnow")
        snowfild.advanceSimulationTime(10)
        self.addChild(snowfild)
        
        labelNameGameNode = SKLabelNode(text: "Ghost Hunter!")
        labelNameGameNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - (self.frame.height / 9))
        labelNameGameNode.fontName = "Blood"
        labelNameGameNode.fontSize = 40
        self.addChild(labelNameGameNode)
        
        newGameButtonNode = SKSpriteNode(imageNamed: "StartButton")
        newGameButtonNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - (self.frame.height / 5))
        newGameButtonNode.texture = SKTexture(imageNamed: "start-2")
        newGameButtonNode.size.width = UIScreen.main.bounds.width * 0.66
        newGameButtonNode.size.height = 100
        newGameButtonNode.setScale(0.75)
        self.addChild(newGameButtonNode)
        
        newLevelButtonNode = SKSpriteNode(imageNamed: "labelLevel")
        newLevelButtonNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 2 * (self.frame.height / 5))
        newLevelButtonNode.texture = SKTexture(imageNamed: "LevelButton")
        newLevelButtonNode.size.width = UIScreen.main.bounds.width * 0.66
        newLevelButtonNode.setScale(0.75)
        newGameButtonNode.size.height = 100
        self.addChild(newLevelButtonNode)
        
        levelLabelNode = SKLabelNode(text: "Легко")
        levelLabelNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height -  3 * (self.frame.height / 5))
        levelLabelNode.fontName = "Blood"
        levelLabelNode.fontSize = 40
        levelLabelNode.setScale(0.75)
        self.addChild(levelLabelNode)
        
        bestScoreLabel = SKLabelNode(text: "Лучший рeзyльтат: \(scoreBest.integer(forKey: "BestScore"))")
        bestScoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height -  4 * (self.frame.height / 5))
        bestScoreLabel.fontName = "Blood"
        bestScoreLabel.fontSize = 30
        bestScoreLabel.setScale(0.75)
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
