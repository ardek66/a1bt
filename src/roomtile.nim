import
  nimgame2/nimgame,
  nimgame2/texturegraphic,
  nimgame2/types,
  nimgame2/entity,
  nimgame2/scene,
  data

type Tile* = ref object of Entity

proc init*(tile: Tile, room: Entity, graphic: TextureGraphic, pos: Coord, dim: Dim) =
  tile.initEntity()
  tile.parent = room
  tile.graphic = graphic
  tile.pos = pos

proc newTile*(p: Entity, g: TextureGraphic, pos: Coord, dim: Dim): Tile =
  new result
  result.init(p, g, pos, dim)
