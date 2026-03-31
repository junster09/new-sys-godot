extends MenuButton

@export var activeRank:int

func _ready() -> void:
	get_popup().id_pressed.connect(onRadioPressed)

func onRadioPressed(_id):
	var popup = get_popup()
	self.text = popup.get_item_text(_id)
	activeRank = _id
