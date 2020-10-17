extends Area2D

enum zoom_types {
	ZOOM_OUT,
	ZOOM_IN
}

enum ease_types {
	EASE_IN,
	EASE_OUT,
	EASE_IN_OUT,
	EASE_OUT_IN
}

enum trans_types {
	TRANS_LINEAR,
	TRANS_SINE,
	TRANS_QUINT,
	TRANS_QUART,
	TRANS_QUAD,
	TRANS_EXPO,
	TRANS_ELASTIC,
	TRANS_CUBIC,
	TRANS_CIRC,
	TRANS_BOUNCE,
	TRANS_BACK
}

export (bool) var enabled := true
export (float) var speed := 1.0
export (float) var zoom_scale := 0.0
export (zoom_types) var zoom_type = zoom_types.ZOOM_OUT
export (trans_types) var trans_type = trans_types.TRANS_SINE
export (ease_types) var ease_type = ease_types.EASE_OUT

var target_in := false
var target_zoom := 0.0

func _ready():
	if zoom_type == zoom_types.ZOOM_OUT:
		target_zoom = 1.0 + zoom_scale
	elif zoom_type == zoom_types.ZOOM_IN:
		target_zoom = 1.0 - zoom_scale	

func _start_tween(camera : Camera2D, target_zoom_vector := Vector2(1,1)) -> void:
	if camera.zoom == target_zoom_vector:
		return
	$Tween.interpolate_property(camera, "zoom", camera.zoom, target_zoom_vector, speed, trans_type, ease_type)
	$Tween.start()


func _on_CameraZoom_area_entered(area):
	if !target_in and enabled:
		target_in = true
		var body = area.get_parent()
		_start_tween(body.active_camera, Vector2(target_zoom, target_zoom))

func _on_CameraZoom_area_exited(area):
	if target_in and enabled:
		target_in = false
		var body = area.get_parent()
		_start_tween(body.active_camera)
