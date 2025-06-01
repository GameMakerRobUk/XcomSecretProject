alarm[0] = 20;

var _dir_pos = array_get_index(global.DIR, dir);
var _state_pos = array_get_index(global.ACTOR_STATES, state);

_dir_pos ++;

if (_dir_pos >= array_length(global.DIR)){
	_dir_pos = 0;
	
	_state_pos ++;
	
	if (_state_pos >= array_length(global.ACTOR_STATES)){
		_state_pos = 0;	
	}
}

dir = global.DIR[_dir_pos];
state = global.ACTOR_STATES[_state_pos];

set_sprite();