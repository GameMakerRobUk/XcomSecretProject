for (var yy = 0; yy < vcells; yy ++){
	for (var xx = 0; xx < hcells; xx ++){
		var _land_spr = global.grid[xx][yy].land_sprite;
		
		var _draw_x = (xx - yy) * (tile_width / 2);
		var _draw_y = ( (xx + yy) * (tile_height / 2) ) - (level * ( (tile_height * 2) - 6) ) ;	
		
		draw_sprite(_land_spr, 0, _draw_x, _draw_y);
	}
}

with parBattleActor{
	draw_self();	
}