import
  nimgame2/nimgame,
  nimgame2/draw,
  nimgame2/entity,
  nimgame2/font,
  nimgame2/truetypefont,
  nimgame2/textgraphic,
  nimgame2/scene,
  nimgame2/settings,
  nimgame2/types,
  data, mainscene


type
  TitleScene = ref object of Scene
    font: TrueTypeFont
    titleText: TextGraphic
    subText: TextGraphic
    title: Entity
    subtitle: Entity

proc init*(scene: TitleScene) =
  background = Color(palletes[pltIndex][0])
  
  initScene(scene)
  scene.font = newTrueTypeFont()
  discard scene.font.load("assets/fnt/m5x7.ttf", 16)

  scene.titleText = newTextGraphic()
  scene.titleText.font = scene.font
  scene.titleText.color = Color(0x306230FF'u32)
  scene.titleText.lines = [dataTitle]

  scene.title = newEntity()
  scene.title.pos = (16, 0)
  scene.title.graphic = scene.titleText

  scene.add scene.title

  scene.subText = newTextGraphic()
  scene.subText.font = scene.font
  scene.subText.color = Color(0x306230FF'u32)
  scene.subText.lines = ["Press SPC to start",
                         "or ESC to quit"]

  scene.subtitle = newEntity()
  scene.subtitle.pos = (16, gameHeight - 32)
  scene.subtitle.graphic = scene.subText
  scene.subtitle.blinking = true
  scene.subtitle.blinkOn = 1
  scene.subtitle.blinkOff = 0.75

  scene.add scene.subtitle

proc free*(scene: TitleScene) =
  scene.font.free()
  scene.titleText.free()
  scene.subText.free()

proc newTitleScene*(): TitleScene =
  new result, free
  init result

method event*(scene: TitleScene, event: Event) =
  if event.kind == KeyDown:
    case event.key.keysym.sym:
      of K_Escape: gameRunning = false
      of K_Space: game.scene = newMainScene()
      else: discard
      

  
