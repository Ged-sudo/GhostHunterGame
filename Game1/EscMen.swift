import SpriteKit

class EscMen: SKScene {
    var escapeMenueButtonNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        escapeMenueButtonNode = self.childNode(withName: "menuButton") as? SKSpriteNode
        escapeMenueButtonNode.texture = SKTexture(imageNamed: "menu")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodeArray = self.nodes(at: location)
            
            if nodeArray.first?.name == "menuButton"{
                let transit = SKTransition.flipVertical(withDuration: 1)
                let gameScene = MainMenue(size: UIScreen.main.bounds.size)
                
                self.view?.presentScene(gameScene, transition: transit)
            }
        }
    }
}
