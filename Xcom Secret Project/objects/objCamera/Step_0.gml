var _cam_xspd = (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * CAM_SPEED;
var _cam_yspd = (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * CAM_SPEED;

if (mouse_wheel_down()){
	zoom_index = clamp(zoom_index + 1, 0, 3);
	var _res = zoom_resolutions[zoom_index];
	camera_set_view_size(view_camera[0], _res.w, _res.h);
	cam_w = _res.w;
	cam_h = _res.h;
}
if (mouse_wheel_up()){
	zoom_index = clamp(zoom_index - 1, 0, 3);
	var _res = zoom_resolutions[zoom_index];
	camera_set_view_size(view_camera[0], _res.w, _res.h);
	cam_w = _res.w;
	cam_h = _res.h;
}

if (follow != noone){
	cx = follow.x - (cam_w / 2);
	cy = follow.y - (cam_h / 2);
	
	if (_cam_xspd != 0 || _cam_yspd != 0){
		follow = noone;	
	}
	
}else{
	cx += _cam_xspd;
	cy += _cam_yspd;
}

if (keyboard_check_pressed(vk_backspace)){
	follow = actors[follow_index]; follow_index ++;
		
	show_debug_message("follow_index: " + string(follow_index) + " | actors: " + string(actors))
	
	if (follow_index >= array_length(actors)){
		follow_index = 0;
	}
}

cx = clamp(cx, -room_width, room_width - cam_w);
cy = clamp(cy, -room_height, room_height - cam_h);

camera_set_view_pos(view_camera[0], cx, cy);