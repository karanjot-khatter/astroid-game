//
//  GameScene.swift
//  SpacegameReloaded
//
//  Created by Karanjot Khatter on 02/02/2019.
//  Copyright © 2019 Karanjot Khatter Apps. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield:SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel : SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var gameTimer:Timer!
    
    var possibleAliens = ["alien", "alien2", "alien3" ] //named under images
    
    let AlienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        starfield.zPosition = -1 //behind our player.
        
        player = SKSpriteNode(imageNamed: "shuttle")
        
        let bound = UIScreen.main.bounds
        let height = bound.height
        let width = bound.width

        player.position = CGPoint(x: 0 , y: 0 - (height / 1.5 )) // bottom middel
        
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 0 - (width / 1.75) , y: 0 + (height / 1.25)) //top left
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 42
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true) //every 3/4 of a second add a new alien, which is being repeated.
        
    }
    
    @objc func addAlien() {
        
        let height = UIScreen.main.bounds.height

        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0]) //always have random alien from the array
        let randomAlienPosition = GKRandomDistribution(lowestValue: -300 ,highestValue: 300 )
        //x bar of spawned values
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: height)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.physicsBody?.categoryBitMask = AlienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
        let animationDuration:TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: 0 - height ), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


