import
  nimgame2/nimgame,
  nimgame2/settings,
  nimgame2/types,
  titlescene, data

game = newGame()
if game.init(w = gameWidth, h = gameHeight, title = dataTitle):
  game.windowSize = game.size * 4
  game.centrify()
  game.scene = newTitleScene()
  #colliderOutline = true
  game.run()
