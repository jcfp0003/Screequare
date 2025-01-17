extends Node

signal SIGNAL_GAME_BUTTON_PRESSED;
signal SIGNAL_GAME_BUTTON_MISSED;
signal SIGNAL_GAME_STARTED;
signal SIGNAL_GAME_ENDED;

# Game button window relocation speed factor
const WIN_MOVE_SPEED := 0.2;
# Score slider values
const AVAIL_SCORES := [10, 25, 50];
# Game button lifetime random range
const TIMER_RANGE := [1.25, 1.85];

@onready var GAME_WINDOW : Window = $GameWindow;
@onready var LABEL_TIME : Label= $TimeLabel;
@onready var LABEL_SCORE : Label = $GameWindow/ScoreLabel;
@onready var PROGRESS_CIRCLE : TextureProgressBar = $GameWindow/RemainingCircleTimer;
@onready var AUDIO_CLICKED : AudioStreamPlayer = $ClickSfxPlayer;
@onready var AUDIO_MISSED : AudioStreamPlayer = $MissSfxPlayer;

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

var timer_initial := 0.0;
var timer_current := 0.0;

# Start game button pressed, reset game progress and relocate button window randomly
func _play_button_press():
	GAME_WINDOW.visible = true;
	
	game_active = true;
	game_timer = 0.0;
	game_score = AVAIL_SCORES[score_selector];
	
	_reset_btn_timer();
	
	gamewin_target_position = GlobalFunctions._move_win_to_rand(GAME_WINDOW.size);
	GAME_WINDOW.position = gamewin_target_position;
	SIGNAL_GAME_STARTED.emit();

# Game score button pressed, decrease count and relocate window randomly
func _main_button_press():
	game_score -= 1;
	if game_score <= 0:
		GAME_WINDOW.visible = false;
		game_active = false;
		SIGNAL_GAME_ENDED.emit();
		return;
	
	AUDIO_CLICKED.play();
	_reset_btn_timer();
	gamewin_target_position = GlobalFunctions._move_win_to_rand(GAME_WINDOW.size);
	SIGNAL_GAME_BUTTON_PRESSED.emit();

# Game score button not pressed in time, increase count and relocate randomly
func _missed_button_press():
	_reset_btn_timer();
	AUDIO_MISSED.play();
	game_score += 1;
	gamewin_target_position = GlobalFunctions._move_win_to_rand(GAME_WINDOW.size);
	SIGNAL_GAME_BUTTON_MISSED.emit();

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
	
	# Update current click timer
	timer_current -= delta;
	PROGRESS_CIRCLE.value = timer_current / timer_initial;
	if timer_current <= 0.0:
		_missed_button_press();

# Resets game button timer to a new random value
func _reset_btn_timer():
	timer_initial = randf_range(TIMER_RANGE[0], TIMER_RANGE[1]);
	timer_current = timer_initial;

func _exit_pressed():
	get_tree().quit();

#func _ready():
	#for i in DisplayServer.get_screen_count():
		#print(DisplayServer.screen_get_position(i), DisplayServer.screen_get_size(i));
