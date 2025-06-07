#macro CAM_W camera_get_view_width(view_camera[0])
#macro CAM_H camera_get_view_height(view_camera[0])
#macro CAM_SPEED 8
cx = 0;
cy = 0;

initialised = false;
follow = noone;
follow_index = 0;
actors = [];
with parBattleActor array_push(other.actors, id);

zoom_resolutions = [
	{w : 420, h : 270},
	{w : 840, h : 540},
	{w : 1260, h : 810},
	{w : 1920, h : 1080},
];

zoom_index = 1;
cam_w = zoom_resolutions[zoom_index].w;
cam_h = zoom_resolutions[zoom_index].h;