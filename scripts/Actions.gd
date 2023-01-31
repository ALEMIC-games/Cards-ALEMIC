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
			line.show_behind_parent = true
			line.begin_cap_mode = Line2D.LINE_CAP_ROUND
			player.add_child(line)
			
			#take_input
			var unh_btn_was_pressed = false
			while card.pressed:
				yield(get_tree(), "idle_frame")
				if unhandled_button.is_hovered():
					line.points = [
						Vector2.DOWN*5,
						(player.get_global_mouse_position() - player.global_position).limit_length(500)
						]
					player.get_node('Sprite').flip_h = (player.get_global_mouse_position() - player.global_position).x < 0
				else:
					line.points = [
						Vector2.ZERO,
						Vector2.ZERO
						]
				
				if unh_btn_was_pressed and not unhandled_button.pressed\
				and player.get_node('AnimationPlayer').current_animation != 'throw':
					line.points = []
					var new_pos = player.global_position + (player.get_global_mouse_position() - player.global_position).limit_length(500)+Vector2.UP*5
					player.get_node('AnimationPlayer').play('throw', -1, 1.5)
					yield(player.get_node('AnimationPlayer'), 'climax_reached')
					var card_ptcl = load("res://scenes/LittleCard.tscn").instance()
					get_tree().current_scene.add_child(card_ptcl)
					card_ptcl.global_position = player.global_position
					card_ptcl.look_at(new_pos)
					var tw = get_tree().create_tween()
					tw.tween_property(card_ptcl, 'global_position', new_pos, (new_pos-player.global_position).length()/1000)
					tw.parallel().tween_property(card_ptcl, 'rotation', (new_pos-player.global_position).length()*2*PI, (new_pos-player.global_position).length()/1000)
					tw.play()
					yield(tw, "finished")
					card_ptcl.queue_free()
					
					yield(get_tree(), "physics_frame")
					print(new_pos-player.global_position)
					print(player.move_and_slide((new_pos-player.global_position)/player.get_physics_process_delta_time()))
				unh_btn_was_pressed = unhandled_button.pressed
			
			player.remove_child(line)


