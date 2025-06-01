function create_character_sprites(_spritesheet, _data){
	
	/*
		_data : {
			idle : [],
			move : [],
			died : [],
			sprite_data : {sprite_sheet : ss_civilian_male, frame_w : 33, frame_h : 41, xorigin : 16, yorigin : 33},
		}
	*/
	
	var _sprites = {};
	var _state_names = global.ACTOR_STATES;
		
	for (var _state = 0; _state < array_length(_state_names); _state ++){
		
		var _state_name = _state_names[_state];
		var _data_array = struct_get(_data, _state_name);
			
		show_debug_message("_data_array: " + string(_data_array));
		show_debug_message("_state_name: " + string(_state_name));
			
		var _state_struct = {};
		
		for (var _dir = 0; _dir < array_length(global.DIR); _dir ++){
			
			var _new_sprite = create_new_sprite(_spritesheet,
												_data.sprite_data.frame_w, _data.sprite_data.frame_h,
												_data_array[_dir].xframe_start, _data_array[_dir].yframe_start,
												_data_array[_dir].xframes_per_state,
												_data.sprite_data.xorigin, _data.sprite_data.yorigin);
												
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