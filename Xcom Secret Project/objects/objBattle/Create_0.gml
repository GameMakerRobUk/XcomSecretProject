#macro CELL_SIZE 16

hcells = room_width div CELL_SIZE;
vcells = room_height div CELL_SIZE;

global.grid = [];

for (var yy = 0; yy < vcells; yy ++){
	for (var xx = 0; xx < hcells; xx ++){
		global.grid[xx][yy] = {land_sprite : spr_terrain_grass, actor : noone}	
	}
}

tile_width = sprite_get_width(spr_terrain_grass);
tile_height = sprite_get_height(spr_terrain_grass);
level = 0;


var _spawn_x = (irandom(xx - 1) div CELL_SIZE) * CELL_SIZE;
var _spawn_y = (irandom(yy - 1) div CELL_SIZE) * CELL_SIZE;

var _num_of_soldiers = 8;
	
while (_num_of_soldiers > 0){
	var _actor = instance_create_layer(_spawn_x, _spawn_y, "Actors", objBattleSoldier);
	global.grid[_spawn_x][_spawn_y].actor = _actor;
	var _diff = CELL_SIZE;
	var _attempts = 0;
	
	show_debug_message("creating soldier at " + string(_spawn_x) + "," + string(_spawn_y))
	
	while (global.grid[_spawn_x][_spawn_y].actor != noone){
			  
		_spawn_x = choose(_spawn_x, _spawn_x + _diff, _spawn_x - _diff);
		_spawn_y = choose(_spawn_y, _spawn_y + _diff, _spawn_y - _diff);
		_attempts ++;
		
		_spawn_x = clamp(_spawn_x, 0, hcells - 1);
		_spawn_y = clamp(_spawn_y, 0, vcells - 1);
		
		if (_attempts > 50){
			_diff += CELL_SIZE;
		}
	}
	
	_num_of_soldiers --;
}
