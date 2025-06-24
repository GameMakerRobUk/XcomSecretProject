#macro CELL_SIZE 16

hcells = room_width div CELL_SIZE;
vcells = room_height div CELL_SIZE;

var _lay_id = layer_get_id("ts_top_down");
var _map_id = layer_tilemap_get_id(_lay_id);
layer_set_visible(_lay_id, false);

global.grid = [];
spawns = {
	player : [],
	enemy : [],
	civilian : [],
}

enum TOP_DOWN_CELL { empty, wall, player_spawn, enemy_spawn, civilian_spawn };

for (var yy = 0; yy < vcells; yy ++){
	for (var xx = 0; xx < hcells; xx ++){
		var _topdown_cell = tilemap_get(_map_id, xx, yy);
		global.grid[xx][yy] = { 
								land_sprite : spr_terrain_grass, 
								actor : noone, 
								blocked : false, 
								xx : xx, 
								yy : yy,
								revealed : false,
							  };
		
		switch _topdown_cell{
			case TOP_DOWN_CELL.wall:{
				global.grid[xx][yy].land_sprite = spr_terrain_wall_test;	
				global.grid[xx][yy].blocked = true;	
			}; break;
			case TOP_DOWN_CELL.player_spawn:{
				show_debug_message("added cell to player spawn array")
				array_push(spawns.player, global.grid[xx][yy]);	
			}; break;
			case TOP_DOWN_CELL.enemy_spawn:{
				array_push(spawns.enemy, global.grid[xx][yy]);	
			}; break;
			case TOP_DOWN_CELL.civilian_spawn:{
				array_push(spawns.civilian, global.grid[xx][yy]);	
			}; break;
		}
	}
}

tile_width = sprite_get_width(spr_terrain_grass);
tile_height = sprite_get_height(spr_terrain_grass);
level = 0;

var _soldiers_spawned = 0;
var _num_soldiers = 8;

while (_soldiers_spawned < _num_soldiers){
	if (array_length(spawns.player) == 0){
		show_debug_message("no more player spawns left")
		exit;	
	}
	var _node = array_shift(spawns.player);
	var _spawn_x = (_node.xx div CELL_SIZE) * CELL_SIZE;
	var _spawn_y = (_node.yy div CELL_SIZE) * CELL_SIZE;
	var _actor = instance_create_layer(_spawn_x, _spawn_y, "Actors", objBattleSoldier, {xx : _node.xx, yy : _node.yy});
	reveal_area(_node.xx, _node.yy);
	_node.actor = _actor;
	
	_soldiers_spawned ++;
	
	show_debug_message("spawned soldier at " + string(_node.xx) + "," + string(_node.yy))
}

var _enemies_spawned = 0;
var _num_aliens = 6;
array_shuffle(spawns.enemy);

while (_enemies_spawned < _num_aliens){
	if (array_length(spawns.enemy) == 0){
		exit;	
	}
	var _node = array_shift(spawns.enemy);
	var _spawn_x = (_node.xx div CELL_SIZE) * CELL_SIZE;
	var _spawn_y = (_node.yy div CELL_SIZE) * CELL_SIZE;
	var _actor = instance_create_layer(_spawn_x, _spawn_y, "Actors", objBattleZombie, {xx : _node.xx, yy : _node.yy});
	_node.actor = _actor;
	
	_enemies_spawned ++;
}

var _civilians_spawned = 0;
var _num_civilians = 8;
array_shuffle(spawns.civilian);

while (_civilians_spawned < _num_civilians){
	if (array_length(spawns.civilian) == 0){
		exit;	
	}
	var _node = array_shift(spawns.civilian);
	var _spawn_x = (_node.xx div CELL_SIZE) * CELL_SIZE;
	var _spawn_y = (_node.yy div CELL_SIZE) * CELL_SIZE;
	var _actor = instance_create_layer(_spawn_x, _spawn_y, "Actors", objBattleCivilian, {xx : _node.xx, yy : _node.yy});
	_node.actor = _actor;
	_civilians_spawned ++;
}

state = BATTLE.initialise;

method(, function select_next_unit(_team){
	if (array_length(units[_team]) == 0){
		exit;	
	}
	current_unit = array_shift(units[_team]);
});

method(, function setup_battle_player_input(){
	state = BATTLE.player_input;	
});

method(, function reveal_area(_start_xx, _start_yy){
	for (var yy = _start_yy - 8; yy <= _start_yy + 8; yy ++){
		if (yy < 0) continue;
		if (yy >= vcells) continue;
		
		for (var xx = _start_xx - 8; xx <= _start_xx + 8; xx ++){
			if (xx < 0) continue;
			if (xx >= hcells) continue;
			
			var _node = global.grid[xx][yy];
			_node.revealed = true;
		}
	}
});	


//var _spawn_x = (irandom(xx - 1) div CELL_SIZE) * CELL_SIZE;
//var _spawn_y = (irandom(yy - 1) div CELL_SIZE) * CELL_SIZE;

//var _num_of_soldiers = 8;
	
//while (_num_of_soldiers > 0){
//	var _actor = instance_create_layer(_spawn_x, _spawn_y, "Actors", objBattleSoldier);
//	global.grid[_spawn_x][_spawn_y].actor = _actor;
//	var _diff = CELL_SIZE;
//	var _attempts = 0;
	
//	show_debug_message("creating soldier at " + string(_spawn_x) + "," + string(_spawn_y))
	
//	while (global.grid[_spawn_x][_spawn_y].actor != noone){
			  
//		_spawn_x = choose(_spawn_x, _spawn_x + _diff, _spawn_x - _diff);
//		_spawn_y = choose(_spawn_y, _spawn_y + _diff, _spawn_y - _diff);
//		_attempts ++;
		
//		_spawn_x = clamp(_spawn_x, 0, hcells - 1);
//		_spawn_y = clamp(_spawn_y, 0, vcells - 1);
		
//		if (_attempts > 50){
//			_diff += CELL_SIZE;
//		}
//	}
	
//	_num_of_soldiers --;
//}

//var _num_of_aliens = 6;

//var _spawn_x = (irandom(xx - 1) div CELL_SIZE) * CELL_SIZE;
//var _spawn_y = (irandom(yy - 1) div CELL_SIZE) * CELL_SIZE;

//while (_num_of_aliens > 0){
//	var _actor = instance_create_layer(_spawn_x, _spawn_y, "Actors", objBattleZombie);
//	global.grid[_spawn_x][_spawn_y].actor = _actor;
//	var _diff = CELL_SIZE;
//	var _attempts = 0;
	
//	show_debug_message("creating soldier at " + string(_spawn_x) + "," + string(_spawn_y))
	
//	while (global.grid[_spawn_x][_spawn_y].actor != noone){
			  
//		_spawn_x = choose(_spawn_x, _spawn_x + _diff, _spawn_x - _diff);
//		_spawn_y = choose(_spawn_y, _spawn_y + _diff, _spawn_y - _diff);
//		_attempts ++;
		
//		_spawn_x = clamp(_spawn_x, 0, hcells - 1);
//		_spawn_y = clamp(_spawn_y, 0, vcells - 1);
		
//		if (_attempts > 50){
//			_diff += CELL_SIZE;
//		}
//	}
	
//	_num_of_aliens --;
//}
