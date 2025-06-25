for (var yy = 0; yy < vcells; yy ++){
	for (var xx = 0; xx < hcells; xx ++){
		var _node = global.grid[xx][yy];
		var _land_spr = _node.land_sprite;
		
		var _draw_x = (xx - yy) * (tile_width / 2);
		var _draw_y = ( (xx + yy) * (tile_height / 2) ) - (level * ( (tile_height * 2) - 6) ) ;	
		
		draw_sprite(_land_spr, !_node.revealed, _draw_x, _draw_y);
		
		if (_node.actor != noone && _node.actor.revealed){
			draw_sprite(_node.actor.sprite_index, _node.actor.image_index, _draw_x, _draw_y);	
			if (_node.actor == current_unit){
				draw_sprite(spr_cursor_current_actor, 0, _draw_x, _draw_y);
			}	
		}
		
		if (state == BATTLE.player_input){
			_draw_x = (cursor_grid_x - cursor_grid_y) * (tile_width / 2);
			_draw_y = (cursor_grid_x + cursor_grid_y) * (tile_height / 2) - (level * ( (tile_height * 2) - 6) );
			draw_sprite(spr_cursor, 0, _draw_x, _draw_y);
		}
	}
}

//with parBattleActor{
//	var _draw_x = (xx - yy) * (other.tile_width / 2);
//	var _draw_y = ( (xx + yy) * (other.tile_height / 2) ) - (other.level * ( (other.tile_height * 2) - 6) ) ;	
	
//	draw_sprite(sprite_index, image_index, _draw_x, _draw_y);
//}