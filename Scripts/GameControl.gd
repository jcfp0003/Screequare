extends Node

# Game button window relocation speed factor
const WIN_MOVE_SPEED := 0.2;
# Score slider values
const AVAIL_SCORES := [10, 25, 50];

@onready var GAME_WINDOW := $GameWindow;
@onready var LABEL_TIME := $TimeLabel;
@onready var LABEL_SCORE := $GameWindow/ScoreLabel;

# Score slider selected index
var score_selector := 0;

# Update score slider selected index on change
func _score_drag_changed(val: float):
	score_selector = val as int;

var game_active := false;
var game_timer := 0.0;
var game_score := 0;

# Game button window next target position, used on lerp
var gamewin_target_position := Vector2.ZERO;

# Start game button pressed, reset game progress and relocate button window randomly
func _play_button_press():
	GAME_WINDOW.visible = true;
	
	game_active = true;
	game_timer = 0.0;
	game_score = AVAIL_SCORES[score_selector];
	
	_move_win_to_rand();
	GAME_WINDOW.position = gamewin_target_position;

# Game score button pressed, decrease count and relocate window randomly
func _main_button_press():
	#game_score -= 1;
	if game_score <= 0:
		GAME_WINDOW.visible = false;
		game_active = false;
		return;
	
	_move_win_to_rand();

func _process(delta):
	# Move game window to random selected position
	GAME_WINDOW.position = lerp(GAME_WINDOW.position as Vector2, gamewin_target_position, WIN_MOVE_SPEED) as Vector2i;
	
	if not game_active:
		return;
	
	# Update gametime timer and score
	game_timer += delta;
	var minutes = game_timer / 60
	var seconds = fmod(game_timer, 60)
	var milliseconds = fmod(game_timer, 1) * 100
	LABEL_TIME.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	LABEL_SCORE.text = "%d" % game_score;

# Sets new random position in all screen area
func _move_win_to_rand():
	var target_display = randi_range(0, DisplayServer.get_screen_count() - 1);
	var display_pos = DisplayServer.screen_get_position(target_display);
	var display_siz = DisplayServer.screen_get_size(target_display);
	# Pick random position in screen, limited by game window size (400), and add position offset (for multiscreen layouts)
	gamewin_target_position.x = randi_range(0, display_siz.x - 400) + display_pos.x;
	gamewin_target_position.y = randi_range(0, display_siz.y - 400) + display_pos.y;
	
	#print(target_display, gamewin_target_position);

func _exit_pressed():
	get_tree().quit();

#func _ready():
	#for i in DisplayServer.get_screen_count():
		#print(DisplayServer.screen_get_position(i), DisplayServer.screen_get_size(i));
