extends Button


var card_configuration = {
	'raffle_started' : ['teleport', 'owner', self]
}
signal raffle_started

func _ready():
	#connecting actions to triggers
	for key in card_configuration.keys():
		var action = card_configuration[key][0]
		var arguments = []
		for arg in card_configuration[key]:
			if not(arg is String and arg == action):
				arguments.append(arg)
		
		match key:
			'raffle_started':
				connect('raffle_started', Actions, action, arguments)

func _on_Card_toggled(button_pressed):
	if button_pressed:
		for card in get_tree().get_nodes_in_group("card"):
			if card != self:
				card.pressed = false
		emit_signal('raffle_started')
