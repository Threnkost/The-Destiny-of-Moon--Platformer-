extends Area2D

const TRANS_TYPE = Tween.TRANS_CUBIC
const EASE_TYPE  = Tween.EASE_OUT

enum zoom_types {
	ZOOM_OUT,
	ZOOM_IN
}

export (bool) var enabled := true
export (float) var speed := 1.0
export (float) var zoom_scale := 0.0
export (zoom_types) var zoom_type = zoom_types.ZOOM_OUT

var target_in := false

func _on_CameraZoomOut_body_entered(body):
	#if body.has_variable("active_camera"):
	if !target_in and enabled:
		target_in = true
		var target_zoom = Vector2.ZERO
		match zoom_type:
			zoom_types.ZOOM_OUT:
				target_zoom = 1.0 + zoom_scale
			zoom_types.ZOOM_IN:
				target_zoom = 1.0 - zoom_scale
		$Tween.interpolate_property(body.active_camera, "zoom", body.active_camera.zoom, target_zoom, speed, TRANS_TYPE, EASE_TYPE)
		$Tween.start()

func _on_CameraZoomOut_body_exited(body):
	#if body.has_variable("active_camera"):
	if target_in and enabled:
		target_in = false
		var target_zoom = Vector2(1.0, 1.0)
		$Tween.interpolate_property(body.active_camera, "zoom", body.active_camera.zoom, target_zoom, speed, TRANS_TYPE, EASE_TYPE)
		$Tween.start()
