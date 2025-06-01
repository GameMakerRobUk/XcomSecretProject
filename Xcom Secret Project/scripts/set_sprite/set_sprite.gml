function set_sprite(_image_index = 0){
	var _state_struct = struct_get(sprites, state);
	sprite_index = struct_get(_state_struct, dir);
	image_index = _image_index;
}