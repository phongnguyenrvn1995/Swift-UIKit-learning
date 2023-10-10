//
//  Map.swift
//  Shooting Gallery
//
//  Created by Phong Nguyễn Hoàng on 10/10/2023.
//
import SpriteKit
class Map1: Map {
    override var ENEMY_NAMES: [SKTexture] {
        get {[TextureFactory.ENEMY_UFO_PURPLE]}
        set { super.ENEMY_NAMES = newValue }
    }
    
    override var FRIEND_NAMES: [SKTexture] {
        get { [TextureFactory.FRIEND_AIR_BALLOON] }
        set { super.FRIEND_NAMES = newValue }
    }
    
    override func createEnemies() -> [Enemy] {
//        enemySpeed *= 3
        var enemies: [Enemy] = []
        for _ in 0 ..< 3 {
            let enemy = Enemy()
            enemy.size = enemySize
            enemy.position = enemyBornPosition
            enemy.configure(texture: ENEMY_NAMES.randomElement()!,
                            hMode: enemyHorizontalMode,
                            vMode: enemyVerticalMode,
                            minY: enemyMinY,
                            maxY: enemyMaxY,
                            verticalStep: enemyVerticalStep, mySpeed: enemySpeed)
            enemies.append(enemy)
            DispatchQueue.main.sync { [weak self] in
                guard let self = self else { return }
                delegate?.onLoading(percent: CGFloat((self.enemies.count + enemies.count) * 100 / 6))
            }
        }
        return enemies
    }
    
    override func createFriends() -> [Friend] {
//        friendSpeed *= 3
        var friends: [Friend] = []
        for _ in 0 ..< 3 {
            let enemy = Friend()
            enemy.size = friendSize
            enemy.position = friendBornPosition
            enemy.configure(texture: FRIEND_NAMES.randomElement()!,
                            hMode: friendHorizontalMode,
                            vMode: friendVerticalMode,
                            minY: friendMinY,
                            maxY: friendMaxY,
                            verticalStep: friendVerticalStep, mySpeed: friendSpeed)
            friends.append(enemy)
            DispatchQueue.main.sync { [weak self] in
                guard let self = self else { return }
                delegate?.onLoading(percent: CGFloat((enemies.count + friends.count) * 100 / 6))
            }
        }
        return friends
    }
}
