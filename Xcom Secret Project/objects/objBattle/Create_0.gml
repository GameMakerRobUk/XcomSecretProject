#macro CELL_SIZE 16

hcells = room_width div CELL_SIZE;
vcells = room_height div CELL_SIZE;

var _lay_id = layer_get_id("ts_top_down");
var _map_id = layer_tilemap_get_id(_lay_id);
layer_set_visible(_lay_id, false);

global.nodes = [];
spawns = {
	player : [],
	enemy : [],
	neutral : [],
}

enum TOP_DOWN_CELL { empty, wall, player_spawn, enemy_spawn, civilian_spawn };

for (var yy = 0; yy < vcells; yy ++){
	for (var xx = 0; xx < hcells; xx ++){
		var _topdown_cell = tilemap_get(_map_id, xx, yy);
		//global.grid[xx][yy] = { 
		//						land_sprite : spr_terrain_grass, 
		//						actor : noone, 
		//						blocked : false, 
		//						xx : xx, 
		//						yy : yy,
		//						revealed : false,
		//					  };
		
		var _data = { 
						land_sprite : spr_terrain_grass, 
						unit : noone, 
						blocked : false, 
						cell_x : xx, 
						cell_y : yy,
						revealed : false,
						neighbours : [],
					};
					
		var _node = instance_create_depth(xx * CELL_SIZE, yy * CELL_SIZE, 0, objNode, _data);
		
		switch _topdown_cell{
			case TOP_DOWN_CELL.wall:{
				_node.land_sprite = spr_terrain_wall_test;	
				_node.blocked = true;	
			}; break;
			case TOP_DOWN_CELL.player_spawn:{
				show_debug_message("added cell to player spawn array")
				array_push(spawns.player, _node);	
			}; break;
			case TOP_DOWN_CELL.enemy_spawn:{
				array_push(spawns.enemy, _node);	
			}; break;
			case TOP_DOWN_CELL.civilian_spawn:{
				array_push(spawns.neutral, _node);	
			}; break;
		}
		
		global.nodes[xx][yy] = _node;
		set_node_neighbours(_node);
	}
}

method(, function set_node_neighbours(_node){
	if (_node.blocked) exit;
	
	for (var yy = _node.cell_y - 1; yy <= _node.cell_y; yy ++){
		if (yy < 0) continue;
		
		for (var xx = _node.cell_x - 1; xx <= _node.cell_x; xx ++){
			if (xx < 0) continue;
			if (xx == _node.cell_x && yy == _node.cell_y) continue;
			
			var _node_to_add = global.nodes[xx][yy];
			if (_node_to_add.blocked) continue;
			
			array_push(_node.neighbours, _node_to_add);
			array_push(_node_to_add.neighbours, _node);
		}
	}
});

tile_width = sprite_get_width(spr_terrain_grass);
tile_height = sprite_get_height(spr_terrain_grass);
level = 0;

cursor_cell_x = 0;
cursor_cell_y = 0;

method(, function spawn_units(_obj, _spawns, _num){
	var _spawned = 0;
	
	while (_spawned < _num){
		if (array_length(_spawns) == 0){
			show_debug_message("no more spawns left")
			exit;	
		}
		var _node = array_shift(_spawns);
		var _spawn_x = (_node.cell_x div CELL_SIZE) * CELL_SIZE;
		var _spawn_y = (_node.cell_y div CELL_SIZE) * CELL_SIZE;
		var _unit = instance_create_layer(_spawn_x, _spawn_y, "Actors", _obj, {cell_x : _node.cell_x, cell_y : _node.cell_y});

		_node.unit = _unit;
	
		_spawned ++;
	}
});


method(, function spawn_soldiers(_num_wanted){
	spawn_units(objBattleSoldier, spawns.player, _num_wanted);
});

method(, function spawn_aliens(_num_wanted){
	array_shuffle(spawns.enemy);
	spawn_units(objBattleZombie, spawns.enemy, _num_wanted);
});

method(, function spawn_civilians(_num_wanted){
	array_shuffle(spawns.neutral);
	spawn_units(objBattleCivilian, spawns.neutral, _num_wanted);
});

spawn_soldiers(8);

with objBattleSoldier{
	show_debug_message("xx: " + string(xx) + ", yy: " + string(yy))
	var _node = global.nodes[cell_x][cell_y];
	
	with objBattle{
		reveal_area(_node.cell_x, _node.cell_y);	
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
	var _revealed = get_nodes_in_range(global.nodes[_start_xx][_start_yy], {min : 0, max : 8}, false, false, false);
	var _in_range = _revealed.in_range;
	
	for (var i = 0; i < array_length(_in_range); i ++){
		_in_range[i].revealed = true;
		with _in_range[i].unit{
			revealed = true; //@Rob This needs to be updated taking unit facing into account	
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
	var _node = global.nodes[cursor_cell_x][cursor_cell_y];
	var _unit = _node.unit;
	if (_unit != noone && _unit.team == current_team){
		current_unit = _unit;	
	}	
});

method(, function move_unit(){
	if (current_unit == noone) exit;	
	
	var _node = global.nodes[cursor_cell_x][cursor_cell_y];
	if (_node.blocked) exit;
	
	var _unit = _node.unit;
	if (_unit != noone) exit;
	
	var _old_node = global.nodes[current_unit.cell_x][current_unit.cell_y];
	_old_node.unit = noone;
	_node.unit = current_unit;
	
	current_unit.cell_x = cursor_cell_x;
	current_unit.cell_y = cursor_cell_y;
	reveal_area(cursor_cell_x, cursor_cell_y)
});