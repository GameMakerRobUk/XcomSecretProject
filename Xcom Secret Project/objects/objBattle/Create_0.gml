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
	neutral : [],
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
				array_push(spawns.neutral, global.grid[xx][yy]);	
			}; break;
		}
	}
}

tile_width = sprite_get_width(spr_terrain_grass);
tile_height = sprite_get_height(spr_terrain_grass);
level = 0;

cursor_grid_x = 0;
cursor_grid_y = 0;

method(, function spawn_actors(_obj, _spawns, _num){
	var _spawned = 0;
	
	while (_spawned < _num){
		if (array_length(_spawns) == 0){
			show_debug_message("no more spawns left")
			exit;	
		}
		var _node = array_shift(_spawns);
		var _spawn_x = (_node.xx div CELL_SIZE) * CELL_SIZE;
		var _spawn_y = (_node.yy div CELL_SIZE) * CELL_SIZE;
		var _actor = instance_create_layer(_spawn_x, _spawn_y, "Actors", _obj, {cell_x : _node.xx, cell_y : _node.yy});

		_node.actor = _actor;
	
		_spawned ++;
	}
});


method(, function spawn_soldiers(_num_wanted){
	spawn_actors(objBattleSoldier, spawns.player, _num_wanted);
});

method(, function spawn_aliens(_num_wanted){
	array_shuffle(spawns.enemy);
	spawn_actors(objBattleZombie, spawns.enemy, _num_wanted);
});

method(, function spawn_civilians(_num_wanted){
	array_shuffle(spawns.neutral);
	spawn_actors(objBattleCivilian, spawns.neutral, _num_wanted);
});

spawn_soldiers(8);

with objBattleSoldier{
	show_debug_message("xx: " + string(xx) + ", yy: " + string(yy))
	var _node = global.grid[cell_x][cell_y];
	
	with objBattle{
		reveal_area(_node.xx, _node.yy);	
	}
}

spawn_aliens(6);
spawn_civilians(6);

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

method(, function center_on_pos(_x, _y){
	with objCamera{
		follow = {x : _x, y : _y};
	}
});

method(, function center_on_grid_pos(_cell_x, _cell_y){
	var _x = 0;
	var _y = 0;
	
	center_on_pos(_x, _y);
});

method(, function click_on_unit(){
	var _node = global.grid[cursor_grid_x][cursor_grid_y];
	var _actor = _node.actor;
	if (_actor != noone && _actor.team == current_team){
		current_unit = _actor;	
	}	
});

method(, function move_unit(){
	show_debug_message("move_unit");
	if (current_unit == noone) exit;	
	
	show_debug_message("current_unit: " + string(current_unit));
	
	var _node = global.grid[cursor_grid_x][cursor_grid_y];
	var _actor = _node.actor;
	
	show_debug_message("_node: " + string(_node));
	show_debug_message("_actor: " + string(_actor));
	
	if (_actor == noone){
		var _old_node = global.grid[current_unit.cell_x][current_unit.cell_y];
		_old_node.actor = noone;
		_node.actor = current_unit;
		current_unit.cell_x = cursor_grid_x;
		current_unit.cell_y = cursor_grid_y;
		reveal_area(cursor_grid_x, cursor_grid_y)
		
		show_debug_message("_old_node: " + string(_old_node));
		show_debug_message("_node: " + string(_node));
		show_debug_message("_actor: " + string(_actor));
	}
});