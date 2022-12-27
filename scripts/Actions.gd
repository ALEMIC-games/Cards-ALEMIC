extends Node

var player
var unhandled_button

func _ready():
	var unh_btn_canv = CanvasLayer.new()
	unh_btn_canv.layer = -1
	get_tree().current_scene.add_child(unh_btn_canv)
	unhandled_button = Button.new()
	unhandled_button.anchor_bottom = 1
	unhandled_button.anchor_right = 1
	unhandled_button.modulate.a = 0
	unh_btn_canv.add_child(unhandled_button)

func teleport(obj, card):
	match obj:
		'owner':
			#line prepare
			var line = Line2D.new()
			line.width = 10
			var width_curve = Curve.new()
			width_curve.add_point(Vector2(0, 1))
			width_curve.add_point(Vector2(1, 0))
			line.width_curve = width_curve
			line.default_color = Color.white
			line.antialiased = true
			line.show_behind_parent = true
			player.add_child(line)
			
			#take_input
			var unh_btn_was_pressed = false
			while card.pressed:
				yield(get_tree(), "physics_frame")
				line.points = [
					Vector2.ZERO,
					(player.get_global_mouse_position() - player.global_position).limit_length(500)
					]
				
				if unh_btn_was_pressed and not unhandled_button.pressed:
					player.global_position += (player.get_global_mouse_position() - player.global_position).limit_length(500)
					line.points = []
				unh_btn_was_pressed = unhandled_button.pressed
			
			player.remove_child(line)


