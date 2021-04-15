extends Node

onready var RESULT = $RESULT
onready var OUT_LINE_SHADER = preload("res://SYSTEMS/OUTLINE.tres")
var NODE
var NAME
var CONTENT

func _ready():
	RESULT.readonly = false
	RESULT.text = ""
	_SYNC_CONTENT()
	for BUTTONS in get_node("BUTTONS").get_children():
		var PATH = BUTTONS.get_path()
		BUTTONS.shortcut_in_tooltip = false
		BUTTONS.toggle_mode = true
		BUTTONS.use_parent_material = false
		var POS = get_node(PATH).rect_position
		BUTTONS.connect("button_down", self, "_button_down", [PATH, POS])
		BUTTONS.connect("button_up", self, "_button_up", [PATH, POS])
		BUTTONS.connect("pressed", self, "_button_pressed", [PATH])
		BUTTONS.connect("mouse_entered", self, "_button_mouse_entered", [PATH])
		BUTTONS.connect("mouse_exited", self, "_button_mouse_exited", [PATH])

func _button_down(PATH, POS):
	NODE = get_node(PATH)
	if NODE.pressed != true:
		NODE.rect_position = Vector2(POS.x, POS.y + 8)

func _button_up(PATH, POS):
	NODE = get_node(PATH)
	NODE.pressed = false
	NODE.rect_position = POS

func _button_pressed(PATH):
	NODE = get_node(PATH)
	NAME = NODE.get_node("LABEL").text
	if NAME == "=":
		_EQUALS()
	elif NAME == "C":
		RESULT.text = ""
		_SYNC_CONTENT()
	elif NAME == "%":
		_TYPE_IN("*0.01")
	elif RESULT.text == "ERROR :/":
		RESULT.readonly = true
		for BUTTONS in get_node("BUTTONS").get_children():
			if BUTTONS.pressed == true:
				RESULT.readonly = false
				RESULT.text = ""
				_SYNC_CONTENT()
				_TYPE_IN(NAME)
	else:
		_TYPE_IN(NAME)

func _button_mouse_entered(PATH):
	NODE = get_node(PATH)
	NODE.material = OUT_LINE_SHADER

func _button_mouse_exited(PATH):
	NODE = get_node(PATH)
	NODE.material = null

func _calculation(input):
	var SCRIPT = GDScript.new()
	SCRIPT.set_source_code("tool\nfunc eval():\n\treturn(" + input + ")")
	var ERROR = SCRIPT.reload()
	if ERROR != OK:
		return false
	var OBJECT = Reference.new()
	OBJECT.set_script(SCRIPT)
	var ANS = OBJECT.eval()
	return ANS

func _TYPE_IN(ADD_ON):
	var OLD_TEXT = RESULT.text
	var NEW_TEXT = OLD_TEXT + NAME
	RESULT.text = NEW_TEXT
	var OLD_CONTENT = CONTENT
	var NEW_CONTENT = OLD_CONTENT + ADD_ON
	CONTENT = NEW_CONTENT

func _EQUALS():
	var COMMAND = CONTENT
	var ANS = _calculation(COMMAND)
	if typeof(ANS) == TYPE_BOOL:
		RESULT.text = "ERROR :/"
	else:
		RESULT.text = str(ANS)
	_PRINT_RESULT()
	_SYNC_CONTENT()

func _SYNC_CONTENT():
	CONTENT = RESULT.text

func _on_RESULT_text_changed():
	_SYNC_CONTENT()

func _PRINT_RESULT():
	print(RESULT.text)
