//
//  GameScene.swift
//  someGame
//
//  Created by Matthew Miller on 4/15/16.
//  Copyright (c) 2016 Matthew Miller. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var playerScore: Int = 0
    var rectArray: [SKShapeNode] = []
    var rectCount: Int = 0
    var noTouch: Bool = true
    var myShip: SKSpriteNode = SKSpriteNode(imageNamed:"Spaceship")
    var myLabel = SKLabelNode(fontNamed:"Chalkduster")
    var scoreLabel = SKLabelNode(fontNamed:"Chalkduster")

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

//        self.myLabel.text = "\(myShip.zRotation)"
//        self.myLabel.fontSize = 45
//        self.myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        self.addChild(myLabel)

        self.scoreLabel.text = "Score: \(playerScore)"
        self.scoreLabel.fontSize = 45
        self.scoreLabel.position = CGPoint(x: 200, y: CGRectGetMaxY(self.frame)-200)
        self.addChild(scoreLabel)

        self.myShip = SKSpriteNode(imageNamed:"Spaceship")
        self.myShip.zRotation = 0
        self.myShip.size = CGSize(width: 100, height: 100)
        self.myShip.position = CGPoint(x: 100, y: CGRectGetMidY(self.frame))

        self.addChild(myShip)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        self.noTouch = false
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.noTouch = true
    }

    func applyThrust()
    {
        let yChange = self.myShip.zRotation * 5
        //let xChange = ((self.myShip.zRotation+1.5) % 1.5) * 5
        self.myShip.runAction(SKAction.moveBy(CGVector(dx: 0, dy: yChange), duration: 0))
    }

    func addRectangle() {
        if (rectCount < 4 && arc4random_uniform(10) == 1)
        {
            let maxY = UInt32(CGRectGetMaxY(self.frame))
            let randomY = CGFloat(Int(arc4random_uniform(maxY)))

            var barra = SKShapeNode(rectOfSize: CGSize(width: 50, height: 100))
            barra.name = "bar"
            barra.fillColor = SKColor.greenColor()
            barra.position = CGPoint(x: CGRectGetMaxX(self.frame), y: randomY)

            self.addChild(barra)
            rectArray.insert(barra, atIndex: 0)
            rectCount += 1
        }
    }

    func scrollScenery()
    {
        var currentIndex = 0
        for r in rectArray
        {
            if r.position.x < 0
            {
                r.removeFromParent()
                rectArray.removeAtIndex(currentIndex)
                currentIndex -= 1
                rectCount -= 1
                playerScore += 1
            }

            r.position.x -= 4

            currentIndex += 1

            if (r.intersectsNode(self.myShip))
            {
                exit(0)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if noTouch && self.myShip.zRotation > CGFloat(-M_PI/2)
        {
            let rotateDownwards = SKAction.rotateByAngle(CGFloat(-M_PI), duration:100)
            self.myShip.runAction(rotateDownwards)
        }
        else
        {
            let rotateUpwards = SKAction.rotateByAngle(CGFloat(M_PI), duration:75)
            self.myShip.runAction(rotateUpwards)
        }
//
//        self.myLabel.text = "\(self.myShip.zRotation)"
        self.scoreLabel.text = "Score: \(playerScore)"

        applyThrust()
        addRectangle()
        scrollScenery()

        if self.myShip.position.y <= self.frame.minY
        {
            exit(0)
        }

    }
}
