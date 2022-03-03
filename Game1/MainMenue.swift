//
//  MainMenue.swift
//  Game1
//
//  Created by Евгений Андронов on 03.03.2022.
//

import SpriteKit

class MainMenue: SKScene {
    
    var snowfild:SKEmitterNode!
    
    var newGameButtonNode:SKSpriteNode!
    var newLevelButtonNode:SKSpriteNode!
    var levelLabelNode:SKLabelNode!
    
    override func didMove(to view: SKView) {
        snowfild = self.childNode(withName: "backSnow") as? SKEmitterNode
        snowfild.advanceSimulationTime(10)
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
        newGameButtonNode.texture = SKTexture(imageNamed: "StartButton")
        
        newLevelButtonNode = self.childNode(withName: "newLevelButton") as? SKSpriteNode
        newLevelButtonNode.texture = SKTexture(imageNamed: "LevelButton")
        
        levelLabelNode = self.childNode(withName: "levelLabel") as? SKLabelNode
        
        let userLevel = UserDefaults.standard
        if userLevel.bool(forKey: "hard"){
            levelLabelNode.text = "H A R D !"
        }else{
            levelLabelNode.text = "Легко"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodeArray = self.nodes(at: location)
            
            if nodeArray.first?.name == "newGameButton"{
                let transit = SKTransition.flipVertical(withDuration: 1)
                let gameScene = GameScene(size: UIScreen.main.bounds.size)
                
                self.view?.presentScene(gameScene, transition: transit)
                
            }
        }
    }
    
    func changeLevel(){
        let userLevel = UserDefaults.standard
        
        if levelLabelNode.text == "Лекго"{
            levelLabelNode.text = "H A R D !"
            userLevel.set(true, forKey: "hard")
            
        }else{
            levelLabelNode.text = "Лекго"
            userLevel.set(false, forKey: "hard")
            
        }
        
        userLevel.synchronize()
                
        
         
    }
    
}
