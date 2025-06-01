window_set_fullscreen(true);

global.ACTOR_STATES = ["idle", "moving", "died"];
global.DIR = ["ne", "e", "se", "s", "sw", "w", "nw", "n"];

#region CREATE BATTLE ACTOR SPRITES

global.battle_sprites = {
	civilian : create_character_sprites(ss_civilian_male),
}

#endregion