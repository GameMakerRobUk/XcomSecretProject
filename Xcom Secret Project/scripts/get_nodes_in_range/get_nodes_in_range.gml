function get_nodes_in_range(_start_node, _range, _allow_blocked = false, _units_block = true, _friendlies_block = false){
	show_debug_message("get_nodes_in_range");
	//with objNode{
	//	parent = noone;
	//	dist = 0;
	//	landable = false;
	//}
	
	initialise_nodes();
	
	var _open = ds_priority_create();
	var _closed = [];
	var _in_range = [];
	var _landable = [];
	
	ds_priority_add(_open, _start_node, 0);
	
	//show_debug_message("_range: " + string(_range))
	
	while (ds_priority_size(_open) > 0){
		var _node = ds_priority_delete_min(_open); 
		//show_debug_message("new node dist: " + string(_node.dist))
		var _neighbour_dist = _node.dist + 1;
		array_push(_closed, _node);
		
		//show_debug_message("_node: " + string(_node) + " | _dist: " + string(_neighbour_dist))
		
		if (_node.dist >= _range.min && _node.dist <= _range.max){
			//show_debug_message("node is in range")
			array_push(_in_range, _node);	
		}
		
		if (_neighbour_dist > _range.max){
			//show_debug_message("distance too great for neighbours (" + string(_neighbour_dist) + ")");
			continue;
		}
	
		//show_debug_message("_node.neighbours: " + string(_node.neighbours))
		//Get the neighbours
		for (var i = 0; i < array_length(_node.neighbours); i ++){
			var _neighbour = _node.neighbours[i];
			var _in_open = ds_priority_find_priority(_open, _neighbour);
			//show_debug_message("_neighbour: " + string(_neighbour))
			
			var _blocked_by_unit = false;
			if (_units_block && _neighbour.unit != noone){
				//show_debug_message("There's a live unit")
				if (_neighbour.unit.team == current_team && !_friendlies_block){
					//show_debug_message("It's a friendly and friendlies don't block")
					_blocked_by_unit = false;
				}else{
					//show_debug_message("either it's an enemy unit or friendlies block")
					_blocked_by_unit = true;
				}
			}
			
			if (_neighbour.unit == noone){
				array_push(_landable, _neighbour);
				_neighbour.landable = true;
			}
			
			//if (_allow_blocked || !_neighbour.is_blocked) && (!_units_block || _neighbour.unit == noone || _neighbour.unit.inst == noone){
			if (_allow_blocked || !_neighbour.blocked) && (!_blocked_by_unit){
				if ( (_in_open == undefined && array_get_index(_closed, _neighbour) == -1) ){
					//First time seeing this node
					_neighbour.parent = _node;
					_neighbour.dist = _neighbour_dist;
					//show_debug_message("adding neighbour to open")
					ds_priority_add(_open, _neighbour, _neighbour_dist);
				}else{
					if (_neighbour_dist < _neighbour.dist){
						_neighbour.parent = _node;
						_neighbour.dist = _neighbour_dist;
						ds_priority_change_priority(_open, _neighbour, _neighbour_dist);
						//show_debug_message("updating neighbours priority")
					}
				}
			}else{
				array_push(_closed, _neighbour);
			}
		}
	}
	
	ds_priority_destroy(_open);
	
	return {in_range : _in_range, landable : _landable};
}	