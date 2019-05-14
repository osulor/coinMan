//
//  GameScene.swift
//  Coin Man
//
//  Created by Mubarak Akinbola on 5/9/19.
//  Copyright © 2019 Mubarak Akinbola. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var player: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    var coinTimer: Timer?
    var bombTimer: Timer?
    var score = 0
    var ground : SKSpriteNode?
    var ceil : SKSpriteNode?
    
    let playerCategory : UInt32 = 0x1 << 1
    let coinCategory : UInt32 = 0x1 << 2
    let bombCategory : UInt32 = 0x1 << 3
    let groundAndCeilCategory : UInt32 = 0x1 << 4

    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // reference to the player in game scene
        player = childNode(withName: "player") as? SKSpriteNode
        
        player?.physicsBody?.categoryBitMask = playerCategory
        //assign with which category the player should have contact
        player?.physicsBody?.contactTestBitMask = coinCategory | bombCategory
        player?.physicsBody?.collisionBitMask = groundAndCeilCategory
        
        ground = childNode(withName: "ceil") as? SKSpriteNode
        ground?.physicsBody?.categoryBitMask = groundAndCeilCategory
        ground?.physicsBody?.collisionBitMask = playerCategory
        
        ceil = childNode(withName: "ceil") as? SKSpriteNode
        ceil?.physicsBody?.categoryBitMask = groundAndCeilCategory
        ceil?.physicsBody?.collisionBitMask = playerCategory
        
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode

        // create a new coin in the scene each second
        coinTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.createCoin()
        })
        
        bombTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            self.createBomb()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Makes the player jumps
        player?.physicsBody?.applyForce(CGVector(dx: 0, dy: 7000))
    }
    
    func createCoin(){
        
        let coin = SKSpriteNode(imageNamed: "coin")
        
        // create a physic body for the coins
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.affectedByGravity = false
        
        //assign appropriate category for coin
        coin.physicsBody?.categoryBitMask = coinCategory
        //assign with which category the coin should have contact
        coin.physicsBody?.contactTestBitMask = playerCategory
        
        // set coin so it has no collision with others objects in the scene
        coin.physicsBody?.collisionBitMask = 0
        
        addChild(coin)
        
        let coinWidth = coin.size.width
        let coinHeight = coin.size.height
      //  coin.physicsBody?.isDynamic = true
        
        let maxY = (size.height / 2) - (coinHeight/2)       // max height where the coin can appear
        let minY = -size.height / 2 + coin.size.height / 2
        let range = maxY - minY
        
        // Generate random height for the coin to appear with range being the upper bound.
        let coinY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        
        coin.position = CGPoint(x: size.width/2 + coinWidth/2, y: coinY)
        //let moveLeft = SKAction.move(by: CGVector(dx: -size.width - coinWidth/2, dy: 0), duration: 4)
        let moveLeft = SKAction.moveBy(x: -size.width - coinWidth, y: 0, duration: 4)
        coin.run(SKAction.sequence([moveLeft,SKAction.removeFromParent()]))
    }
    
    func createBomb(){
        
        let bomb = SKSpriteNode(imageNamed: "bomb")
        
        // create a physic body for the coins
        bomb.physicsBody = SKPhysicsBody(rectangleOf: bomb.size)
        bomb.physicsBody?.affectedByGravity = false
        
        //assign appropriate category for coin
        bomb.physicsBody?.categoryBitMask = bombCategory
        //assign with which category the coin should have contact
        bomb.physicsBody?.contactTestBitMask = playerCategory
        
        // set coin so it has no collision with others objects in the scene
        bomb.physicsBody?.collisionBitMask = 0
        addChild(bomb)      // add the bomb image to the scene

        
        let bombWidth = bomb.size.width
        let bombHeight = bomb.size.height
        //  coin.physicsBody?.isDynamic = true
        
        let maxY = (size.height / 2) - (bombHeight/2)       // max height where the bomb can appear
        let minY = -size.height / 2 + bomb.size.height / 2
        let range = maxY - minY
        
        // Generate random height for the bomb to appear with range being the upper bound.
        let bombY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        
        bomb.position = CGPoint(x: size.width/2 + bombWidth/2, y: bombY)
       // let moveLeft = SKAction.move(by: CGVector(dx: -size.width - bombWidth/2, dy: 0), duration: 4)
        let moveLeft = SKAction.moveBy(x: -size.width - bombWidth, y: 0, duration: 4)

        bomb.run(SKAction.sequence([moveLeft,SKAction.removeFromParent()]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == coinCategory {
            contact.bodyA.node?.removeFromParent()
            score += 1
            scoreLabel?.text = "Score: \(score)"
        }
//        if contact.bodyB.categoryBitMask == coinCategory {
//            contact.bodyB.node?.removeFromParent()
//            score += 1
//            scoreLabel?.text = "Score: \(score)"
//        }
        //        if contact.bodyA.categoryBitMask == bombCategory {
//            contact.bodyA.node?.removeFromParent()
//       //     gameOver()
//        }
//        if contact.bodyB.categoryBitMask == bombCategory {
//            contact.bodyB.node?.removeFromParent()
//      //      gameOver()
//        }
    }
   
//    func gameOver(){
//        scene?.isPaused = true
//
//        let playLabel = SKSpriteNode(imageNamed: "play")
//        let playAgainLabel = SKLabelNode(text: "Play Again!")
//
//        let finalScoreLabel = SKLabelNode(text: "Your score: \(score)")
//        finalScoreLabel.position = CGPoint(x: 0, y: 80)
//        finalScoreLabel.fontSize = 85.0
//        finalScoreLabel.fontName = "Comic Sans MS"
//
//        playLabel.position = CGPoint(x: 0, y: -30)
//        playAgainLabel.position = CGPoint(x: 0, y: -150)
//        playAgainLabel.fontName = "Comic Sans MS"
//        playAgainLabel.fontSize = 40.0
//
//        addChild(finalScoreLabel)
//        addChild(playLabel)
//        addChild(playAgainLabel)
//    }
    
}

