window_set_fullscreen(true);

global.ACTOR_STATES = ["idle", "kneel", "moving", "died"];
global.DIR = ["ne", "e", "se", "s", "sw", "w", "nw", "n"];

#region CREATE BATTLE ACTOR SPRITES

/*
	_frame_w = 33, _frame_h = 41, _xorigin = 16, _yorigin = 33
*/

/*
	for (var i = 0; i < array_length(global.DIR); i ++){
		_data.civilian.idle[i] = {xframe_start : i, yframe_start : 0, xframes_per_state : 1};
		_data.civilian.moving[i] = {xframe_start : 0, yframe_start : i + 1, xframes_per_state : 8};
		_data.civilian.died[i] = {xframe_start : 0, yframe_start : 9, xframes_per_state : 3};
		
		_data.zombie.idle[i] = {xframe_start : i, yframe_start : 0, xframes_per_state : 1};
		_data.zombie.moving[i] = {xframe_start : 0, yframe_start : i + 1, xframes_per_state : 8};
		_data.zombie.died[i] = {xframe_start : 0, yframe_start : 9, xframes_per_state : 18};
	}
*/

var _data = {
	soldier : {
		idle : [],
		kneel : [],
		move : [],
		died : [],
		sprite_data : {sprite_sheet : ss_xcom_soldier_male, frame_w : 33, frame_h : 41, xorigin : 16, yorigin : 33},
	},
	civilian : {
		idle : [],
		kneel : [],
		move : [],
		died : [],
		sprite_data : {sprite_sheet : ss_civilian_male, frame_w : 33, frame_h : 41, xorigin : 16, yorigin : 33},
	},
	zombie : {
		idle : [],
		kneel : [],
		move : [],
		died : [],
		sprite_data : {sprite_sheet : ss_zombie, frame_w : 36, frame_h : 44, xorigin : 16, yorigin : 35},
	},
}

for (var i = 0; i < array_length(global.DIR); i ++){
	_data.soldier.idle[i] = {xframe_start : i, yframe_start : 0, xframes_per_state : 1};
	_data.soldier.kneel[i] = {xframe_start : i, yframe_start : 1, xframes_per_state : 1};
	_data.soldier.moving[i] = {xframe_start : 0, yframe_start : i + 2, xframes_per_state : 8};
	_data.soldier.died[i] = {xframe_start : 0, yframe_start : 10, xframes_per_state : 3};
	
	_data.civilian.idle[i] = {xframe_start : i, yframe_start : 0, xframes_per_state : 1};
	_data.civilian.kneel[i] = {xframe_start : i, yframe_start : 1, xframes_per_state : 1};
	_data.civilian.moving[i] = {xframe_start : 0, yframe_start : i + 2, xframes_per_state : 8};
	_data.civilian.died[i] = {xframe_start : 0, yframe_start : 10, xframes_per_state : 3};
		
	_data.zombie.idle[i] = {xframe_start : i, yframe_start : 0, xframes_per_state : 1};
	_data.zombie.kneel[i] = {xframe_start : i, yframe_start : 1, xframes_per_state : 1};
	_data.zombie.moving[i] = {xframe_start : 0, yframe_start : i + 2, xframes_per_state : 8};
	_data.zombie.died[i] = {xframe_start : 0, yframe_start : 10, xframes_per_state : 18};
}

global.battle_sprites = {
	soldier : create_character_sprites(_data.soldier.sprite_data.sprite_sheet, _data.soldier),
	civilian : create_character_sprites(_data.civilian.sprite_data.sprite_sheet, _data.civilian),
	zombie : create_character_sprites(_data.zombie.sprite_data.sprite_sheet, _data.zombie),
}

#endregion