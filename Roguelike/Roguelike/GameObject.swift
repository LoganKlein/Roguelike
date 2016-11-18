//
//  GameObject.swift
//  Roguelike
//
//  Created by Logan Klein on 11/11/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class GameObject: NSObject {
    var animSpeed = 0.2
    var map: CAMap!
    var player: PlayerObject!
    var enemies: [EnemyObject]!
    var floor = 1
}
