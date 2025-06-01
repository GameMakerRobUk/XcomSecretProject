function create_character_sprites(_spritesheet, _frame_w = 33, _frame_h = 41, _xorigin = 16, _yorigin = 33){
	
	/*
		global.ACTOR_STATES = ["idle", "moving", "died"];
		global.DIR = ["ne", "e", "se", "s", "sw", "w", "nw", "n"];
		
		HOW WILL THE ACTORS STORE THEIR SPRITES TO BE USED:
		
		actor_sprites = { 
			idle : [ne, e, se, s, sw, w, nw, n],
			moving : [ne, e, se, s, sw, w, nw, n],
			died : [ne, e, se, s, sw, w, nw, n],
		}
		
	*/
	
	var _state_data = {
		"idle" : [],
		"moving" : [],
		"died" : [],
	}
	
	for (var i = 0; i < array_length(global.DIR); i ++){
		_state_data.idle[i] = {xframe_start : i, yframe_start : 0, xframes_per_state : 1};
		_state_data.moving[i] = {xframe_start : 0, yframe_start : i + 1, xframes_per_state : 8};
		_state_data.died[i] = {xframe_start : 0, yframe_start : 9, xframes_per_state : 3};
	}
	
	var _sprites = {};
	
	var _state_names = global.ACTOR_STATES;
	
	for (var _state = 0; _state < array_length(_state_names); _state ++){
		
		var _state_name = _state_names[_state];
		var _data_array = struct_get(_state_data, _state_name);
		var _state_struct = {};
		
		/*
			actor_sprites_struct
			{
				idle : {n : 1, s : 2, e : 3} etc   | state_struct containing values
				moving : {n : 4, s : 5, e : 6} etc
			}
		*/
		
		for (var _dir = 0; _dir < array_length(global.DIR); _dir ++){
			
			var _new_sprite = create_new_sprite(_spritesheet,
												_frame_w, _frame_h,
												_data_array[_dir].xframe_start, _data_array[_dir].yframe_start,
												_data_array[_dir].xframes_per_state,
												_xorigin, _yorigin);
												
			struct_set(_state_struct, global.DIR[_dir], _new_sprite);
			
		}
		
		struct_set(_sprites, _state_name, _state_struct);
	}
	
	return _sprites;
}

function create_new_sprite(_spritesheet, _frame_w, _frame_h, _start_x_frame = 0, _start_y_frame = 0, _wanted_frames = -1, _x_origin = 0, _y_origin = 0){
	
	var _ss_w = sprite_get_width(_spritesheet);
	var _ss_h = sprite_get_height(_spritesheet);
	var _hframes = _ss_w div _frame_w;
	var _vframes = _ss_h div _frame_h;
	
	if (_wanted_frames == -1){
		var _total_frames = _hframes * _vframes;
	}else{
		_total_frames = _wanted_frames;	
	}
	
	var _surf = surface_create(_ss_w, _ss_h);

	surface_set_target(_surf);
	draw_clear_alpha(c_black, 0);
	draw_sprite(_spritesheet, 0, 0, 0);
	
	var _spr = sprite_create_from_surface(_surf, _start_x_frame * _frame_w, _start_y_frame * _frame_h, _frame_w, _frame_h, true, false, _x_origin, _y_origin);
	
	var _x = _frame_w * (_start_x_frame + 1); 
	var _y = (_start_y_frame * _frame_h);

	for (var i = 1; i < _total_frames; i ++){
		if (_x >= _ss_w){
			_x = 0;
			_y += _frame_h;
		}
		
		sprite_add_from_surface(_spr, _surf, _x, _y, _frame_w, _frame_h, true, false);
		_x += _frame_w;
	}
	
	surface_reset_target();
	
	surface_free(_surf);
	
	return _spr;
}