###
  "Type 2 Jump" a silly game
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
define ["Phaser"], (Phaser) ->
  "use strict"
  exports = class Actor extends Phaser.Sprite
    isActor: yes
    constructor: (game, x, y, key, frame) ->
      super game, x, y, key, frame
      @game = game
      @game.add.existing this
      @game.physics.arcade.enable this
