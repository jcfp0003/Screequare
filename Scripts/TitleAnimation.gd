extends Control

@onready var LABEL_TITLE : Label = $Title;
@onready var ANIM_TREE_TITLE : AnimationTree = $TitleAnimTree;

var shadow_hue = 0.0;
var shadow_max_offset = 6.0;

# Update title animations each frame
func _process(delta):
	# Title shadow color by hue and shadow position randomly
	LABEL_TITLE.label_settings.shadow_color = Color.from_hsv(shadow_hue, 1.0, 1.0, 1.0)
	if shadow_hue < 1.0:
		shadow_hue += 0.001
	else:
		shadow_hue = 0.0
	var added_offset = Vector2(randf_range(-shadow_max_offset, shadow_max_offset), randf_range(-shadow_max_offset, shadow_max_offset));
	LABEL_TITLE.label_settings.shadow_offset = lerp(LABEL_TITLE.label_settings.shadow_offset, added_offset, 0.1);

func _play_btn_hovered():
	ANIM_TREE_TITLE.set("parameters/conditions/playHovered", true);
	ANIM_TREE_TITLE.set("parameters/conditions/playUnhovered", false);
	ANIM_TREE_TITLE.set("parameters/conditions/exitHovered", false);
	ANIM_TREE_TITLE.set("parameters/conditions/exitUnhovered", false);

func _play_btn_unhovered():
	ANIM_TREE_TITLE.set("parameters/conditions/playHovered", false);
	ANIM_TREE_TITLE.set("parameters/conditions/playUnhovered", true);
	ANIM_TREE_TITLE.set("parameters/conditions/exitHovered", false);
	ANIM_TREE_TITLE.set("parameters/conditions/exitUnhovered", false);

func _exit_btn_hovered():
	ANIM_TREE_TITLE.set("parameters/conditions/playHovered", false);
	ANIM_TREE_TITLE.set("parameters/conditions/playUnhovered", false);
	ANIM_TREE_TITLE.set("parameters/conditions/exitHovered", true);
	ANIM_TREE_TITLE.set("parameters/conditions/exitUnhovered", false);

func _exit_btn_unhovered():
	ANIM_TREE_TITLE.set("parameters/conditions/playHovered", false);
	ANIM_TREE_TITLE.set("parameters/conditions/playUnhovered", false);
	ANIM_TREE_TITLE.set("parameters/conditions/exitHovered", false);
	ANIM_TREE_TITLE.set("parameters/conditions/exitUnhovered", true);
