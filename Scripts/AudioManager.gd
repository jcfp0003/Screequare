extends Node

@onready var AUDIOPLAYER_PLAY := $PlaySfxPlayer;
@onready var AUDIOPLAYER_GUIHOVER := $GUIHoverSfxPlayer;

var AUDIOBUS_SFX := AudioServer.get_bus_index("SFX");

func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AUDIOBUS_SFX, linear_to_db(value));

func _on_play_pressed():
	AUDIOPLAYER_PLAY.play();

func _gui_item_hovered():
	AUDIOPLAYER_GUIHOVER.play();
