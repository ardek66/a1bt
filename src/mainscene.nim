import
  strutils,
  nimgame2/nimgame,
  nimgame2/entity,
  nimgame2/font,
  nimgame2/scene,
  nimgame2/settings,
  nimgame2/types,
  nimgame2/indexedimage,
  nimgame2/texturegraphic,
  nimgame2/input,
  data, player, roomtile

type
  MainScene = ref object of Scene
    floorG, wallG, ceilG: TextureGraphic
    room: Entity
    player: Player
    currentPlt: int

proc newRoom(scene: MainScene, dim: Dim) =
  scene.room = newEntity()
  scene.room.initEntity()
  scene.room.pos = (0, 0)
  scene.room.collider = scene.room.newPolyCollider((5.0, 5.0), [(5.0, 5.0), (dim.w.float * 5, 5.0), (dim.w.float * 5, dim.h.float * 5), (5.0, dim.h.float * 5)])
  scene.add scene.room
  
  for i in 0..dim.w:
    scene.add scene.room.newTile(scene.ceilG, (i * 5, 0), (5, 5))
    scene.add scene.room.newTile(scene.floorG, (i * 5, dim.h * 5) , (5, 5))
  for j in 0..dim.h:
    scene.add scene.room.newTile(scene.wallG, (0, j * 5), (5, 5))
    scene.add scene.room.newTile(scene.wallG, (dim.w * 5, j * 5), (5, 5))

proc init*(scene: MainScene) =
  scene.currentPlt = -1

  initScene(scene)

  scene.floorG = newTextureGraphic("assets/img/floor.png")
  scene.ceilG = newTextureGraphic("assets/img/ceil.png")
  scene.wallG = newTextureGraphic("assets/img/wall.png")

  scene.newRoom((50, 30))

  scene.player = newPlayer()
  scene.player.pos.x = gameWidth / 2
  scene.player.pos.y = gameHeight / 2
  scene.player.collisionEnvironment = @[Entity(scene.room)]
  scene.player.parent = scene.room
  scene.add scene.player

  scene.camera = newEntity()
  scene.cameraBondOffset = game.size / 2
  scene.cameraBond = scene.player
  scene.room.parent = scene.camera

proc free*(scene: MainScene) =
  scene.floorG.free()
  scene.ceilG.free()
  scene.wallG.free()
  scene.player.free()

proc newMainScene*(): MainScene =
  new result, free
  init result

method update*(scene: MainScene, elapsed: float) =
  updateScene(scene, elapsed)
  if ScanCodeSpace.pressed:
    scene.player.attack()
  if ScanCodeLeft.down:
    scene.player.left(elapsed)
  elif ScanCodeRight.down:
    scene.player.right(elapsed)
  if ScanCodeUp.pressed:
    scene.player.jump()

  if scene.player.vel.x == 0:
    scene.player.idle()

  if ScanCodeF.pressed:
    pltIndex = if pltIndex >= palletes.high: 0 else: pltIndex + 1

  if scene.currentPlt != pltIndex:
    background = Color(palletes[pltIndex][0])
    scene.floorG.colorMod = Color(palletes[pltIndex][1])
    scene.wallG.colorMod = Color(palletes[pltIndex][1])
    scene.ceilG.colorMod = Color(palletes[pltIndex][1])
    scene.currentPlt = pltIndex


