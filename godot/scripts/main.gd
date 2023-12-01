extends Control
class_name main

enum GAMESTATE {NONE, SCREENTITLE, CONNECTION, GAME, SCORE}
static var gameState : GAMESTATE = GAMESTATE.NONE;

func _ready() -> void:
	changeState(GAMESTATE.SCREENTITLE);

func _process(delta : float) -> void:
	if gameState == GAMESTATE.SCREENTITLE and Input.is_action_just_pressed("mouseClicked"):
		changeState(GAMESTATE.CONNECTION);

func changeState(newGameState : GAMESTATE) -> void:
	match gameState:
		GAMESTATE.SCREENTITLE:
			$"ScreenTitle".queue_free();
		GAMESTATE.CONNECTION:
			$"Connection".queue_free();
		GAMESTATE.GAME:
			$"Game".queue_free();
			
	match newGameState:
		GAMESTATE.SCREENTITLE:
			add_child(preload("res://scenes/screen_title.tscn").instantiate());
		GAMESTATE.CONNECTION:
			add_child(preload("res://scenes/connection.tscn").instantiate());
		GAMESTATE.GAME:
			add_child(preload("res://scenes/game.tscn").instantiate());
		GAMESTATE.SCORE:
			add_child(preload("res://scenes/score.tscn").instantiate());
			
	gameState = newGameState
	
