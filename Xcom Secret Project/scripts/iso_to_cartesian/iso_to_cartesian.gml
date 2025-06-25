function iso_to_cartesian(_isometric_x, _isometric_y){
	var _cartesian_x = (2 * _isometric_y + _isometric_x) * 0.5;
	var _cartesian_y = (2 * _isometric_y - _isometric_x) * 0.5;
	
	return {x : _cartesian_x, y : _cartesian_y};
}