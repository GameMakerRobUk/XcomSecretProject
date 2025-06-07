timer = 0;
index = 0;
row = 0;
paused = false;
width = 33;
height = 41;

soldier_with_gun = ds_list_create();

a_draw[e_body.head_torso][0] = true;
a_draw[e_body.legs][0] = true;
a_draw[e_body.left_arm][0] = true;
a_draw[e_body.right_arm][0] = true;
a_draw[e_body.weapon][0] = true;
a_draw[e_body.head_torso][1] = "Head + Torso: ";
a_draw[e_body.legs][1] = "Legs; ";
a_draw[e_body.left_arm][1] = "Left Arm: ";
a_draw[e_body.right_arm][1] = "Right Arm: ";
a_draw[e_body.weapon][1] = "Weapon: ";

selected_option = 0;

enum e_spr_sol{ sprite, row }
enum e_body{head_torso, legs, left_arm, right_arm, weapon};

spr_sol[e_body.head_torso][e_spr_sol.sprite] = ss_xcom_soldier_male; spr_sol[e_body.head_torso][e_spr_sol.row] = height * 4;
spr_sol[e_body.legs][e_spr_sol.sprite] = ss_xcom_soldier_male; spr_sol[e_body.legs][e_spr_sol.row] = height * 2;
spr_sol[e_body.left_arm][e_spr_sol.sprite] = ss_xcom_soldier_male; spr_sol[e_body.left_arm][e_spr_sol.row] = e_spr.arms_unknown_1 * height;
spr_sol[e_body.right_arm][e_spr_sol.sprite] = ss_xcom_soldier_male; spr_sol[e_body.right_arm][e_spr_sol.row] = e_spr.arms_unknown_2 * height;
spr_sol[e_body.weapon][e_spr_sol.sprite] = hand_objects_sheet; spr_sol[e_body.weapon][e_spr_sol.row] = 0;

spr_sol_walk[e_body.head_torso][e_spr_sol.sprite] = ss_xcom_soldier_male; spr_sol_walk[e_body.head_torso][e_spr_sol.row] = height * 4;
spr_sol_walk[e_body.legs][e_spr_sol.sprite] = ss_xcom_soldier_male; spr_sol_walk[e_body.legs][e_spr_sol.row] = height * 7;
spr_sol_walk[e_body.left_arm][e_spr_sol.sprite] = ss_xcom_soldier_male; spr_sol_walk[e_body.left_arm][e_spr_sol.row] = height * 5;
spr_sol_walk[e_body.right_arm][e_spr_sol.sprite] = ss_xcom_soldier_male; spr_sol_walk[e_body.right_arm][e_spr_sol.row] = height * 6;
spr_sol_walk[e_body.weapon][e_spr_sol.sprite] = -1; spr_sol_walk[e_body.weapon][e_spr_sol.row] = -1;

for (var i = 0; i < 8; i ++) draw_order[i] = [];

array_push(draw_order[0], e_body.weapon, e_body.left_arm, e_body.legs, e_body.head_torso, e_body.right_arm);
array_push(draw_order[1], e_body.left_arm, e_body.head_torso, e_body.right_arm, e_body.legs, e_body.weapon);
array_push(draw_order[2], e_body.left_arm, e_body.head_torso, e_body.legs, e_body.right_arm, e_body.weapon);
array_push(draw_order[3], e_body.left_arm, e_body.head_torso, e_body.legs, e_body.right_arm, e_body.weapon);
array_push(draw_order[4], e_body.left_arm, e_body.head_torso, e_body.legs, e_body.right_arm, e_body.weapon);
array_push(draw_order[5], e_body.left_arm, e_body.head_torso, e_body.legs, e_body.right_arm, e_body.weapon);
array_push(draw_order[6], e_body.weapon, e_body.left_arm, e_body.head_torso, e_body.legs, e_body.right_arm);
array_push(draw_order[7], e_body.weapon, e_body.left_arm, e_body.head_torso, e_body.legs, e_body.right_arm);

enum e_facing{n, ne, e, se, s, sw, w, nw}
/*
	Torso/Head
	Legs
	Left Arm
	Right Arm
	Weapon (if any)
	
	[DRAW ORDER]
	0 - Gun, Left Arm, Head, Right Arm, Legs
	1 - Left Arm, Head, Right Arm, Legs, Gun
	2 - Left Arm, Head, Right Arm, Legs, Gun
	3 - Left Arm, Head, Right Arm, Legs, Gun
	4 - Right Arm, Head, legs, Left Arm, Gun
	5 - Right Arm, Head, legs, Left Arm, Gun
	6 - Gun, Right Arm, Head, legs, Left Arm
	7 - Gun, Left Arm, Head, Legs, Right Arm
*/

//2-up 4-down 6-up 0-down

enum e_spr{
	idle_arm_left,	
	idle_arm_right,
	idle_legs,
	idle_legs_kneel,
	idle_head,
	walk_arm_left_n,
	walk_arm_right_n,
	walk_legs_n,
	walk_arm_left_ne,
	walk_arm_right_ne,
	walk_legs_ne,
	walk_arm_left_e,
	walk_arm_right_e,
	walk_legs_e,
	walk_arm_left_se,
	walk_arm_right_se,
	walk_legs_se,
	walk_arm_left_s,
	walk_arm_right_s,
	walk_legs_s,
	walk_arm_left_sw,
	walk_arm_right_sw,
	walk_legs_sw,
	walk_arm_left_w,
	walk_arm_right_w,
	walk_legs_w,
	walk_arm_left_nw,
	walk_arm_right_nw,
	walk_legs_nw,
	arms_unknown_1,
	arms_unknown_2,
	death_animation,
	girls_head,
}
var n = 0;

txt[n] = "idle_arm_left"; n ++;
txt[n] = "idle_arm_right"; n ++;
txt[n] = "idle_legs"; n ++;
txt[n] = "idle_legs_kneel"; n ++;
txt[n] = "idle_head"; n ++;
txt[n] = "walk_arm_left_n"; n ++;
txt[n] = "walk_arm_right_n"; n ++;
txt[n] = "walk_legs_n"; n ++;
txt[n] = "walk_arm_left_ne"; n ++;
txt[n] = "walk_arm_right_ne"; n ++;
txt[n] = "walk_legs_ne"; n ++;
txt[n] = "walk_arm_left_e"; n ++;
txt[n] = "walk_arm_right_e"; n ++;
txt[n] = "walk_legs_e"; n ++;
txt[n] = "walk_arm_left_se"; n ++;
txt[n] = "walk_arm_right_se"; n ++;
txt[n] = "walk_legs_se"; n ++;
txt[n] = "walk_arm_left_s"; n ++;
txt[n] = "walk_arm_right_s"; n ++;
txt[n] = "walk_legs_s"; n ++;
txt[n] = "walk_arm_left_sw"; n ++;
txt[n] = "walk_arm_right_sw"; n ++;
txt[n] = "walk_legs_sw"; n ++;
txt[n] = "walk_arm_left_w"; n ++;
txt[n] = "walk_arm_right_w"; n ++;
txt[n] = "walk_legs_w"; n ++;
txt[n] = "walk_arm_left_nw"; n ++;
txt[n] = "walk_arm_right_nw"; n ++;
txt[n] = "walk_legs_nw"; n ++;
txt[n] = "arms_unknown_1"; n ++;
txt[n] = "arms_unknown_2"; n ++;
txt[n] = "arms_unknown_3"; n ++;
txt[n] = "arms_unknown_4"; n ++;
txt[n] = "death animation"; n ++;
txt[n] = "girls head"; n ++;
txt[n] = "shouldnt see this"; n ++;