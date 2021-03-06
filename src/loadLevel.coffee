###
  "Type 2 jump" a silly game
  Copyright (C) 2016 Swissnetizen

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
###
define ["Phaser", "player"], (Phaser, Player) ->
  "use strict"
  exports = {}
  exports = (game, mapName) ->
    # does level exist 
    game.level = {} unless game.level
    return no unless game.cache.checkTilemapKey mapName
    map = game.add.tilemap mapName
    map.addTilesetImage "tileset"
    game.level.speed = map.properties.speed #in px/s
    game.map = map
    makeLayers game, map
    makeObjects game, map
    makeEndMarker game, map, {"name":"","type":"endMarker","x":660,"y":0,"width":20,"height":260,"visible":true,"rotation":0,"properties":{},"rectangle":true}
    makeWordList game, map
    makeText game
    yes
  makeLayers = (game, map) ->
    floor = map.createLayer "floor"
    dangerLayer = map.createLayer "dangerLayer"
    # set debug
    floor.debug = game.globals.debug
    dangerLayer.debug = game.globals.debug
    #set collisions
    map.setCollision 3, yes, floor
    map.setCollisionBetween 1, 4, yes, dangerLayer
    game.physics.arcade.enable [dangerLayer, floor]
    # set var
    game.level.dangerLayer = dangerLayer
    game.level.floor = floor
    #makeSlabs game, map, dangerLayer
  makeWordList = (game, map) ->
    try old = game.level.wordList
    number = map.properties.wordList or 1
    wordList = game.getL10nString number, "wordList", yes
    game.level.wordList = wordList or []
    try 
      game.level.wordList.randomise = on if map.properties.randomise.length is "on"
    catch 
      game.level.wordList.randomise = off
    if old is game.level.wordList
      return
    else
      game.level.wordsUsed = 0
  #loops through objects layer
  makeObjects = (game, map) ->
    return unless map.objects.objects
    objects = map.objects.objects 
    for object in objects
      type = object.type
      switch (object.type)
        when "endMarker"
          continue #remove to restart production
          makeEndMarker game, map, object
        when "spawn"
          game.level.spawnPoint = 
            x: object.x
            y: object.y
          game.player = new Player(game, object.x, object.y)
        else
          console.warn "Undefined object type: " + object.type
  makeText = (game) ->
    text = game.levelL10n game.level.number
    game.level.label = game.add.text game.globals.width/2, 50, text, {
        font: "25px " + game.globals.fontFamily
        fill: "#FFFFFF"
        wordWrap: on
        wordWrapWidth: game.globals.width/2
      }
    game.level.label.anchor.set 0.5, 0.5
  makeEndMarker = (game, map, object) ->
    x = object.x + (object.width/2)
    # correct Y; tiled has the Y on the bottom-left
    y = object.y - (object.height/2)
    rect = game.make.bitmapData object.width, object.height
    rect.ctx.fillStyle = "rgba(0, 0, 0, 0);"
    rect.ctx.fillRect 0, 0, object.width, object.height
    marker = game.add.sprite x, y, rect
    game.physics.arcade.enable marker
    marker.tileType = "end"
    game.level.end = marker
  makeSlabs = (game, map, layer) ->
    group = game.add.group()
    game.slabs = group
    map.createFromTiles 2, null, "", layer, group
    console.log group.children
    for child in group.children
      x = child.x 
      y = child.y
      w = child.width
      h = child.height
      game.physics.arcade.enable child
      game.body.setSize 20, 10, 0, 10
      game.debug.body child
      map.removeTileWorldXY x, y, w, h, layer


  exports