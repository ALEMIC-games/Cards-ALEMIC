extends Node

var player

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
			while card.pressed:
				yield(get_tree(), "physics_frame")
				
				line.points = [
					Vector2.ZERO,
					(player.get_global_mouse_position() - player.global_position).limit_length(500)
					]
				
				if Input.is_action_just_released("click"):
					var cards_is_hovered = false
					for c in get_tree().get_nodes_in_group("card"):
						if c.is_hovered():
							cards_is_hovered = true
					
					if not cards_is_hovered:
						player.global_position += (player.get_global_mouse_position() - player.global_position).clamped(500)
						line.points = []
			
			player.remove_child(line)


