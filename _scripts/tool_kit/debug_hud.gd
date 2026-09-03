extends Control


@onready var info_label: Label = $info_label


func _process(_delta: float) -> void:
	var fps := Engine.get_frames_per_second()
	var frame_time: float = 1000.0 / max(fps, 1)

	var hp_line := ""
	var player := get_tree().get_first_node_in_group("player")
	if player != null:
		hp_line = "\nHP: %d / %d" % [player.current_hp, player.MAX_HP]

	info_label.text = (
		"IBBD DEBUG\n"
		+ "FPS: %d\n" % fps
		+ "Frame Time: %.2f ms\n" % frame_time
		+ "Scene: %s" % get_tree().current_scene.name
		+ hp_line
	)