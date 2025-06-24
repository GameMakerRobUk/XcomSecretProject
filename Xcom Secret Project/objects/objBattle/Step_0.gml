enum BATTLE {initialise, setup_turn_order, get_next_faction, team_take_turn, player_input};
enum TEAMS {player, enemy, neutral, none};

switch state {
	case BATTLE.initialise : {
		turn_order = []; 
		current_team = TEAMS.none;
		current_unit = noone;
		state = BATTLE.setup_turn_order;
		
		units[TEAMS.player] = [];
		units[TEAMS.enemy] = [];
		units[TEAMS.neutral] = [];
		
		with objBattleSoldier  array_push(other.units[TEAMS.player], id);
		with objBattleZombie   array_push(other.units[TEAMS.enemy], id);
		with objBattleCivilian array_push(other.units[TEAMS.neutral], id);
		
	}; break;
	
	case BATTLE.setup_turn_order : {
		array_push(turn_order, TEAMS.player, TEAMS.enemy, TEAMS.neutral);
		state = BATTLE.get_next_faction;
	}; break;
	
	case BATTLE.get_next_faction : {
		if (array_length(turn_order) == 0){
			state = BATTLE.setup_turn_order;	
			exit;
		}
		current_team = array_shift(turn_order);
		state = BATTLE.team_take_turn;
	}; break;
	
	case BATTLE.team_take_turn : {
		switch current_team {
			case TEAMS.player : {
				select_next_unit(TEAMS.player);
				setup_battle_player_input();
			}; break;
			
			case TEAMS.enemy : {
				
			}; break;
			
			case TEAMS.neutral : {
				
			}; break;
			
			case TEAMS.none : {
				show_debug_message("ERROR current team is none")
			}; break;
		}
	}; break;
	
	case BATTLE.player_input : {
		
	};
}