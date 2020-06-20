import
  strutils,
  nimgame2/nimgame,
  nimgame2/entity,
  nimgame2/types,
  nimgame2/indexedimage,
  nimgame2/texturegraphic,
  data

type
  Player* = ref object of Entity
    idxImage: IndexedImage
    gTexture: TextureGraphic
    currentPlt*: int

const
  gravity* = 300
  drag* = 225
  walkVel* = 350
  jumpVel* = 150
  maxWalk* = walkVel * 0.40
  
proc init*(player: Player) =
  player.currentPlt = pltIndex

  player.centrify()
  player.gTexture = newTextureGraphic("assets/img/player.png")
  
  player.initEntity()
  player.graphic = player.gTexture
  player.gTexture.colorMod = Color(palletes[pltIndex][1])

  player.collider = player.newBoxCollider((12, 12), (12, 22))
  
  player.physics = platformerPhysics
  player.fastPhysics = true
  player.drg.x = drag
  player.acc.y = gravity
  
  player.initSprite((24,24))
  discard player.sprite.addAnimation("idle", [0, 1], 0.25)
  discard player.sprite.addAnimation("walk", [4, 5], 0.15)
  discard player.sprite.addAnimation("attack", [3], 0.1)
  discard player.sprite.addAnimation("walk_attack", [6, 7], 0.05)

proc free*(player: Player) =
  player.gTexture.free()

proc newPlayer*(): Player =
  new result, free
  init result

proc idle*(player: Player) =
  if not player.sprite.playing:
    player.play("idle", 1)

proc left*(player: Player, elapsed: float) =
  if player.vel.x >= -maxWalk:
    player.vel.x += -walkVel * elapsed
  if not player.sprite.playing:
    player.play("walk", 1)
  player.flip = Flip.horizontal

proc right*(player: Player, elapsed: float) =
  if player.vel.x < maxWalk:
    player.vel.x += walkVel * elapsed
  if not player.sprite.playing:
    player.play("walk", 1)
  player.flip = Flip.none

proc jump*(player: Player) =
  if player.vel.y == 0:
    player.vel.y -= jumpVel

proc attack*(player: Player) =
  if "attack" notin player.currentAnimationName:
    if abs(player.vel.x) > 1:
      player.play("walk_attack", 1)
    else:
      player.play("attack", 1)

proc changeColor*(player: Player, color: uint32) =
  player.gTexture.colorMod = Color(color)

method update*(player: Player, elapsed: float) =
  player.updateEntity(elapsed)
  if pltIndex != player.currentPlt:
    player.gTexture.colorMod = Color(palletes[pltIndex][1])
    player.currentPlt = pltIndex
  
