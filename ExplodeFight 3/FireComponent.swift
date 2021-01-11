//
//  FireComponent.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 08/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

protocol Ticking {
    
    func tick(deltaTime seconds: TimeInterval, tickFunction: (() -> Void)) -> Self
}

struct Accumulator: Ticking {

    let tickInterval: TimeInterval
    var timeSinceLastTick: TimeInterval = 0.0

    func tick(deltaTime seconds: TimeInterval, tickFunction: (() -> Void)) -> Accumulator {
        
        let time = timeSinceLastTick + seconds
        
        if time > tickInterval {
            
            tickFunction()
            
            return Accumulator(tickInterval: tickInterval, timeSinceLastTick: time - tickInterval)
        }
        
        return Accumulator(tickInterval: tickInterval, timeSinceLastTick: timeSinceLastTick + seconds)
    }
}

class FireComponent: GKComponent {
    
    private var fireTicker = Accumulator(tickInterval: 0.25)
    
    private var bulletNode : SKShapeNode?
    
    override func update(deltaTime seconds: TimeInterval) {
        
        fireTicker = fireTicker.tick(deltaTime: seconds) { fire() }
    }
    
    func fire() {
        
        if self.bulletNode == nil {
            
            let bulletNode = SKShapeNode.init(rectOf: CGSize.init(width: 10, height: 10), cornerRadius: 3)

            bulletNode.lineWidth = 2.5
            
            bulletNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            bulletNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()]))
            
            self.bulletNode = bulletNode
        }
        
        if let bullet = self.bulletNode?.copy() as? SKShapeNode, let node = entity?.spriteComponent?.node {
            
            let v = CGVector(angle: CGFloat(Double.pi * 0.5)).normalized() * 32

            bullet.position = node.position + v
            bullet.strokeColor = SKColor.blue
            bullet.physicsBody = {
                
                let body = SKPhysicsBody(circleOfRadius: 5)
                
                body.affectedByGravity = true
                body.velocity = v * 25
                
                return body
            }()

            node.addChild(bullet)
        }
    }
    
    override class var supportsSecureCoding: Bool { return true }
}

/* MARK: - Move this somewhere else

//import CoreGraphics
//import SpriteKit

extension CGPoint {
  /**
   * Creates a new CGPoint given a CGVector.
   */
  public init(vector: CGVector) {
    self.init(x: vector.dx, y: vector.dy)
  }

  /**
   * Given an angle in radians, creates a vector of length 1.0 and returns the
   * result as a new CGPoint. An angle of 0 is assumed to point to the right.
   */
  public init(angle: CGFloat) {
    self.init(x: cos(angle), y: sin(angle))
  }

  /**
   * Adds (dx, dy) to the point.
   */
  public mutating func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
    x += dx
    y += dy
    return self
  }

  /**
   * Returns the length (magnitude) of the vector described by the CGPoint.
   */
  public func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }

  /**
   * Returns the squared length of the vector described by the CGPoint.
   */
  public func lengthSquared() -> CGFloat {
    return x*x + y*y
  }

  /**
   * Normalizes the vector described by the CGPoint to length 1.0 and returns
   * the result as a new CGPoint.
   */
  func normalized() -> CGPoint {
    let len = length()
    return len>0 ? self / len : CGPoint.zero
  }

  /**
   * Normalizes the vector described by the CGPoint to length 1.0.
   */
  public mutating func normalize() -> CGPoint {
    self = normalized()
    return self
  }

  /**
   * Calculates the distance between two CGPoints. Pythagoras!
   */
  public func distanceTo(_ point: CGPoint) -> CGFloat {
    return (self - point).length()
  }

  /**
   * Returns the angle in radians of the vector described by the CGPoint.
   * The range of the angle is -π to π; an angle of 0 points to the right.
   */
  public var angle: CGFloat {
    return atan2(y, x)
  }
}

/**
 * Adds two CGPoint values and returns the result as a new CGPoint.
 */
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func + (left: CGPoint, right: CGPoint) -> CGVector {
    return CGVector(dx: left.x + right.x, dy: left.y + right.y)
}

/**
 * Increments a CGPoint with the value of another.
 */
public func += (left: inout CGPoint, right: CGPoint) {
  left = left + right
}

/**
 * Adds a CGVector to this CGPoint and returns the result as a new CGPoint.
 */
public func + (left: CGPoint, right: CGVector) -> CGPoint {
  return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

/**
 * Increments a CGPoint with the value of a CGVector.
 */
public func += (left: inout CGPoint, right: CGVector) {
  left = left + right
}

/**
 * Subtracts two CGPoint values and returns the result as a new CGPoint.
 */
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

/**
 * Decrements a CGPoint with the value of another.
 */
public func -= (left: inout CGPoint, right: CGPoint) {
  left = left - right
}

/**
 * Subtracts a CGVector from a CGPoint and returns the result as a new CGPoint.
 */
public func - (left: CGPoint, right: CGVector) -> CGPoint {
  return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}

/**
 * Decrements a CGPoint with the value of a CGVector.
 */
public func -= (left: inout CGPoint, right: CGVector) {
  left = left - right
}

/**
 * Multiplies two CGPoint values and returns the result as a new CGPoint.
 */
public func * (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

/**
 * Multiplies a CGPoint with another.
 */
public func *= (left: inout CGPoint, right: CGPoint) {
  left = left * right
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value and
 * returns the result as a new CGPoint.
 */
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value.
 */
public func *= (point: inout CGPoint, scalar: CGFloat) {
  point = point * scalar
}

/**
 * Multiplies a CGPoint with a CGVector and returns the result as a new CGPoint.
 */
public func * (left: CGPoint, right: CGVector) -> CGPoint {
  return CGPoint(x: left.x * right.dx, y: left.y * right.dy)
}

/**
 * Multiplies a CGPoint with a CGVector.
 */
public func *= (left: inout CGPoint, right: CGVector) {
  left = left * right
}

/**
 * Divides two CGPoint values and returns the result as a new CGPoint.
 */
public func / (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

/**
 * Divides a CGPoint by another.
 */
public func /= (left: inout CGPoint, right: CGPoint) {
  left = left / right
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value and returns
 * the result as a new CGPoint.
 */
public func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value.
 */
public func /= (point: inout CGPoint, scalar: CGFloat) {
  point = point / scalar
}

/**
 * Divides a CGPoint by a CGVector and returns the result as a new CGPoint.
 */
public func / (left: CGPoint, right: CGVector) -> CGPoint {
  return CGPoint(x: left.x / right.dx, y: left.y / right.dy)
}

/**
 * Divides a CGPoint by a CGVector.
 */
public func /= (left: inout CGPoint, right: CGVector) {
  left = left / right
}

/**
 * Performs a linear interpolation between two CGPoint values.
 */
public func lerp(start: CGPoint, end: CGPoint, t: CGFloat) -> CGPoint {
  return start + (end - start) * t
}
*/
