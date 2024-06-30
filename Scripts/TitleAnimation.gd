extends Label

var shadow_hue = 0.0;
var shadow_max_offset = 6.0;

# Update shadow position randomly and color by hue each frame
func _process(delta):
	self.label_settings.shadow_color = Color.from_hsv(shadow_hue, 1.0, 1.0, 1.0)
	if shadow_hue < 1.0:
		shadow_hue += 0.001
	else:
		shadow_hue = 0.0
	
	var added_offset = Vector2(randf_range(-shadow_max_offset, shadow_max_offset), randf_range(-shadow_max_offset, shadow_max_offset));
	self.label_settings.shadow_offset = lerp(self.label_settings.shadow_offset, added_offset, 0.1);
