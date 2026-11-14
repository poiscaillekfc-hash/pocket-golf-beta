extends Node2D

# POCKET GOLF : GREEN VALLEY
# Green Valley — Niveaux 1 à 9. Chaque niveau partage un décor animé.

const POWER := 6.8
const MAX_DRAG := 170.0
const BALL_RADIUS := 15.0
const CUP_ROLL_SPEED_LIMIT := 520.0
const CUP_HALF_WIDTH := 18.0
const COIN_RADIUS := 12.0
const ROLL_DECELERATION := 56.0
const PLATFORM_ROLL_DECELERATION := 70.0
const WIND_ACCELERATIONS := [0.0, 70.0, 145.0, 230.0]
const WIND_GROUND_SCALE := 0.4
const HOLES_PER_LEVEL := 3
const SAVE_PATH := "user://pocket_golf_green_valley.cfg"
const PINES := [
	Vector2(225, 0.84), Vector2(300, 0.52), Vector2(734, 0.84),
	Vector2(937, 0.68), Vector2(1015, 0.49)
]

# Le profil sert au dessin et à la collision. La taupe est facultative par parcours.
# La valeur de 'mole' indique x et la profondeur sous le sol à cet endroit.
const HOLES := [
	{
		"name": "La colline", "limit": 3, "start_x": 140.0, "cup_x": 1130.0,
		"profile": [Vector2(-50, 560), Vector2(350, 560), Vector2(480, 505),
			Vector2(680, 505), Vector2(850, 560), Vector2(1300, 560)],
		"coins": [], "required": 0, "mole": Vector2(281, 108),
		"tip": "Tire vers l’arrière, puis relâche."
	},
	{
		"name": "La descente", "limit": 3, "start_x": 155.0, "cup_x": 1080.0,
		"profile": [Vector2(-50, 435), Vector2(270, 435), Vector2(405, 465),
			Vector2(610, 545), Vector2(740, 575), Vector2(1300, 575)],
		"coins": [Vector2(510, 68)], "required": 1,
		"tip": "Récupère la pièce en l’air, puis vise le trou."
	},
	{
		"name": "La récolte", "limit": 5, "start_x": 145.0, "cup_x": 1095.0,
		"profile": [Vector2(-50, 560), Vector2(405, 560), Vector2(550, 505),
			Vector2(790, 505), Vector2(935, 560), Vector2(1300, 560)],
		"coins": [Vector2(390, 15), Vector2(740, 55)], "required": 2, "mole": Vector2(1039, 88),
		"tip": "Récupère les deux pièces, puis vise le trou."
	}
]

const RIVER_PINES := [Vector2(92, 0.62), Vector2(296, 0.59),
	Vector2(404, 0.72), Vector2(945, 0.64), Vector2(1203, 0.78)]
const RIVER_HOLES := [
	{
		"name": "Le pont de bois", "limit": 4, "start_x": 150.0, "cup_x": 1120.0,
		"profile": [Vector2(-50, 540), Vector2(365, 540), Vector2(465, 548),
			Vector2(507, 733), Vector2(691, 733), Vector2(744, 548), Vector2(1300, 548)],
		"water": Vector3(470.22, 737.41, 571), "bridge": Rect2(465, 548, 279, 13),
		"coins": [Vector2(843, 16)], "required": 1,
		"tip": "Traverse le pont ou saute par-dessus. Prends la pièce."
	},
	{
		"name": "Le green en cuvette", "limit": 3, "start_x": 260.0, "cup_x": 1040.0,
		"profile": [Vector2(-50, 540), Vector2(390, 540), Vector2(485, 555),
			Vector2(690, 555), Vector2(835, 501), Vector2(895, 501),
			Vector2(995, 560), Vector2(1090, 560), Vector2(1180, 511), Vector2(1300, 511)],
		"coins": [], "required": 0,
		"tip": "Dose ton tir. Les pentes de la cuvette ramènent la balle vers le trou."
	},
	{
		"name": "Le saut de la rivière", "limit": 5, "start_x": 178.0, "cup_x": 1136.0,
		"profile": [Vector2(-50, 542), Vector2(395, 542), Vector2(503, 542),
			Vector2(545, 735), Vector2(676, 735), Vector2(718, 542),
			Vector2(835, 542), Vector2(944, 552), Vector2(1300, 552)],
		"water": Vector3(509.10, 712.12, 570),
		"coins": [Vector2(790, 27)], "required": 1, "mole": Vector2(380, 109),
		"tip": "Approche-toi du bord, puis saute vers la pièce sur l’autre rive."
	}
]

const FOREST_PINES := [Vector2(86, 0.93), Vector2(308, 0.64), Vector2(818, 0.75),
	Vector2(1235, 0.89)]
const FOREST_HOLES := [
	{
		"name": "Le rocher incliné", "limit": 3, "start_x": 160.0, "cup_x": 1125.0,
		"profile": [Vector2(-50, 543), Vector2(716, 543), Vector2(829, 551), Vector2(1300, 551)],
		"rock": [Vector2(455, 544), Vector2(553, 508), Vector2(590, 496), Vector2(627, 503),
			Vector2(663, 541), Vector2(666, 553), Vector2(451, 553)],
		"coins": [], "required": 0,
		"tip": "Saute par-dessus le rocher ou joue un rebond sur sa face inclinée."
	},
	{
		"name": "Le tronc creux", "limit": 4, "start_x": 163.0, "cup_x": 1120.0,
		"profile": [Vector2(-50, 531), Vector2(692, 531), Vector2(849, 562), Vector2(1300, 562)],
		"tunnel": Rect2(449, 464, 243, 19),
		"coins": [Vector2(564, 15)], "required": 1,
		"tip": "Tire bas dans le tronc pour prendre la pièce. La descente t’aide à finir."
	},
	{
		"name": "La clairière", "limit": 5, "start_x": 150.0, "cup_x": 1095.0,
		"profile": [Vector2(-50, 556), Vector2(430, 556), Vector2(568, 514), Vector2(810, 514),
			Vector2(923, 555), Vector2(1020, 568), Vector2(1150, 568), Vector2(1235, 535), Vector2(1300, 535)],
		"coins": [Vector2(393, 15), Vector2(746, 49)], "required": 2, "mole": Vector2(242, 106),
		"tip": "Prends la pièce au pied de la butte, puis lève ton tir vers la seconde."
	}
]

const ORCHARD_TREES := [Vector2(82, 0.84), Vector2(319, 0.66), Vector2(893, 0.74), Vector2(1209, 0.91)]
const ORCHARD_HOLES := [
	{
		"name": "La pente du verger", "limit": 3, "start_x": 158.0, "cup_x": 1060.0,
		"profile": [Vector2(-50, 488), Vector2(285, 488), Vector2(430, 512), Vector2(635, 565),
			Vector2(1115, 565), Vector2(1250, 530), Vector2(1300, 530)],
		"coins": [], "required": 0,
		"tip": "Laisse la descente porter la balle, puis dose ton tir vers le drapeau."
	},
	{
		"name": "Le petit étang", "limit": 4, "start_x": 240.0, "cup_x": 1040.0,
		"profile": [Vector2(-50, 535), Vector2(501, 535), Vector2(551, 735), Vector2(653, 735),
			Vector2(700, 535), Vector2(1300, 535)],
		"water": Vector3(510.0, 691.54, 571.0),
		"coins": [Vector2(768, 24)], "required": 1,
		"tip": "Place-toi avant l’étang, puis saute vers la pièce sur l’autre rive."
	},
	{
		"name": "La terrasse des pommiers", "limit": 5, "start_x": 165.0, "cup_x": 1090.0,
		"profile": [Vector2(-50, 552), Vector2(426, 552), Vector2(556, 507), Vector2(795, 507),
			Vector2(908, 547), Vector2(1020, 559), Vector2(1140, 559), Vector2(1255, 532), Vector2(1300, 532)],
		"coins": [Vector2(430, 15), Vector2(713, 48)], "required": 2, "mole": Vector2(943, 78),
		"tip": "Prends la pièce basse, puis vise celle au-dessus de la terrasse."
	}
]

const RIDGE_HOLES := [
	{
		"name": "La pente douce", "limit": 3, "start_x": 168.0, "cup_x": 1018.0,
		"profile": [Vector2(-50, 511), Vector2(290, 511), Vector2(473, 529),
			Vector2(655, 556), Vector2(1165, 556), Vector2(1300, 556)],
		"coins": [], "required": 0,
		"tip": "Laisse rouler la balle dans la pente, puis dose ton approche."
	},
	{
		"name": "Le replat", "limit": 4, "start_x": 170.0, "cup_x": 1370.0, "width": 1570.0,
		"profile": [Vector2(-50, 558), Vector2(420, 558), Vector2(522, 535), Vector2(688, 493),
			Vector2(935, 493), Vector2(1080, 551), Vector2(1455, 551), Vector2(1590, 551)],
		"coins": [], "required": 0,
		"tip": "Pose la balle sur le replat pour jouer le green en contrebas."
	},
	{
		"name": "Le rebond de la crête", "limit": 5, "start_x": 171.0, "cup_x": 1771.0, "width": 1960.0,
		"profile": [Vector2(-50, 552), Vector2(460, 552), Vector2(622, 518), Vector2(805, 518),
			Vector2(931, 463), Vector2(1015, 447), Vector2(1115, 486), Vector2(1310, 580),
			Vector2(1410, 606), Vector2(1835, 606), Vector2(1920, 568), Vector2(1980, 568)],
		"coins": [], "required": 0,
		"tip": "Place ta balle avant la crête. Un rebond sur le versant descendant peut l’envoyer vers le green."
	}
]

const CLIFF_PINES := [Vector2(70, 0.63), Vector2(327, 0.47), Vector2(871, 0.54), Vector2(1221, 0.67)]
const CLIFF_HOLES := [
	{
		"name": "Le balcon", "limit": 3, "start_x": 170.0, "cup_x": 1045.0,
		"profile": [Vector2(-50, 508), Vector2(355, 508), Vector2(589, 562),
			Vector2(1100, 562), Vector2(1240, 526), Vector2(1300, 526)],
		"coins": [], "required": 0,
		"tip": "Laisse la pente porter la balle. La remontée derrière le drapeau la retient."
	},
	{
		"name": "Le bloc des fougères", "limit": 4, "start_x": 168.0, "cup_x": 1080.0,
		"profile": [Vector2(-50, 535), Vector2(735, 535), Vector2(875, 552), Vector2(1300, 552)],
		"rock": [Vector2(477, 538), Vector2(486, 493), Vector2(523, 464), Vector2(575, 452),
			Vector2(622, 473), Vector2(649, 499), Vector2(662, 539), Vector2(565, 541)],
		"coins": [Vector2(768, 27)], "required": 1,
		"tip": "Lève la balle par-dessus le bloc pour prendre la pièce de l’autre côté."
	},
	{
		"name": "Le ricochet des falaises", "limit": 5, "start_x": 172.0, "cup_x": 1580.0, "width": 1790.0,
		"profile": [Vector2(-50, 566), Vector2(535, 566), Vector2(640, 537), Vector2(915, 537),
			Vector2(1035, 487), Vector2(1200, 487), Vector2(1325, 444), Vector2(1660, 444),
			Vector2(1740, 418), Vector2(1810, 418)],
		"rock": [Vector2(735, 537), Vector2(910, 495), Vector2(962, 491),
			Vector2(992, 507), Vector2(979, 540), Vector2(735, 542)],
		"coins": [], "required": 0,
		"tip": "Monte par les terrasses ou vise la dalle inclinée pour gagner de la hauteur."
	}
]

const PERCHED_HOLES := [
	{
		"name": "Le saut du promontoire", "limit": 3, "start_x": 165.0, "cup_x": 1045.0,
		"profile": [Vector2(-50, 426), Vector2(444, 426), Vector2(457, 460), Vector2(478, 549),
			Vector2(1120, 549), Vector2(1220, 519), Vector2(1300, 519)],
		"coins": [], "required": 0,
		"tip": "Dose ton tir et laisse la balle tomber sur le green."
	},
	{
		"name": "La corniche", "limit": 4, "start_x": 159.0, "cup_x": 1087.0,
		"profile": [Vector2(-50, 348), Vector2(402, 348), Vector2(425, 380), Vector2(450, 474),
			Vector2(714, 474), Vector2(744, 510), Vector2(773, 562), Vector2(1300, 562)],
		"coins": [Vector2(574, 17)], "required": 1,
		"tip": "Pose la balle sur la corniche pour prendre la pièce, puis joue le green du bas."
	},
	{
		"name": "La pierre relais", "limit": 5, "start_x": 185.0, "cup_x": 1555.0, "width": 1770.0,
		"profile": [Vector2(-50, 343), Vector2(454, 343), Vector2(483, 383), Vector2(551, 742),
			Vector2(980, 742), Vector2(994, 620), Vector2(1040, 603), Vector2(1650, 603),
			Vector2(1720, 576), Vector2(1790, 576)],
		"rock": [Vector2(703, 465), Vector2(766, 464), Vector2(848, 482), Vector2(922, 510),
			Vector2(964, 531), Vector2(947, 568), Vector2(880, 586), Vector2(765, 549)],
		"relay": true, "void": Vector2(483, 994),
		"coins": [], "rock_coin": Vector2(745, 445), "required": 1,
		"tip": "Prends la pièce sur la pierre, puis vise le drapeau sur l’autre rive."
	}
]

const WIND_HOLES := [
	{
		"name": "La brise", "limit": 4, "start_x": 170.0, "cup_x": 1040.0,
		"profile": [Vector2(-50, 546), Vector2(350, 546), Vector2(518, 566),
			Vector2(1110, 566), Vector2(1245, 532), Vector2(1300, 532)],
		"coins": [], "required": 0, "wind": 1,
		"tip": "Le vent pousse la balle en l’air et pendant qu’elle roule."
	},
	{
		"name": "Le vallon à contrevent", "limit": 4, "start_x": 174.0, "cup_x": 1062.0,
		"profile": [Vector2(-50, 468), Vector2(300, 468), Vector2(424, 514),
			Vector2(535, 568), Vector2(696, 568), Vector2(790, 543), Vector2(911, 503),
			Vector2(1121, 503), Vector2(1254, 471), Vector2(1300, 471)],
		"coins": [], "required": 0, "wind": -2,
		"tip": "Le vent te freine à l’aller. Joue bas vers le vallon ou vise directement le green."
	},
	{
		"name": "Le grand saut", "limit": 5, "start_x": 168.0, "cup_x": 1460.0, "width": 1650.0,
		"profile": [Vector2(-50, 469), Vector2(352, 469), Vector2(403, 486), Vector2(459, 763),
			Vector2(1176, 763), Vector2(1230, 529), Vector2(1350, 514), Vector2(1510, 514),
			Vector2(1613, 449), Vector2(1670, 402)],
		"water": Vector3(424.83, 1215, 594),
		"rock": [Vector2(630, 607), Vector2(648, 551), Vector2(685, 529), Vector2(735, 541),
			Vector2(842, 541), Vector2(890, 515), Vector2(918, 524), Vector2(944, 602),
			Vector2(878, 660), Vector2(705, 663)],
		"coins": [], "required": 0, "wind": 3,
		"tip": "Pose la balle sur la corniche, ou profite du vent fort pour franchir le ravin d’un coup."
	}
]

const CANOPY_HOLES := [
	{
		"name": "Le pont des cimes", "limit": 16, "start_x": 120.0, "cup_x": 1128.0,
		"profile": [Vector2(-50, 618), Vector2(600, 618), Vector2(665, 612),
			Vector2(691, 612), Vector2(729, 765), Vector2(929, 765),
			Vector2(969, 614), Vector2(1175, 614), Vector2(1295, 570), Vector2(1320, 570)],
		"water": Vector3(696.0, 964.0, 637.0),
		"platforms": [Rect2(215, 550, 132, 15), Rect2(57, 470, 132, 15),
			Rect2(267, 368, 151, 15), Rect2(89, 195, 159, 15)],
		"suspension_bridge": [Vector2(445, 174), Vector2(563, 174), Vector2(618, 187),
			Vector2(689, 198), Vector2(765, 202), Vector2(837, 197), Vector2(908, 186),
			Vector2(967, 174), Vector2(1097, 174)],
		"rock": [Vector2(997, 395), Vector2(1007, 382), Vector2(1021, 373),
			Vector2(1189, 373), Vector2(1207, 365), Vector2(1227, 339), Vector2(1250, 295),
			Vector2(1282, 252), Vector2(1320, 225), Vector2(1320, 513), Vector2(1234, 500),
			Vector2(1167, 465), Vector2(1095, 438), Vector2(1031, 420)],
		"bounce_trunk": Rect2(475, 306, 33, 312),
		"air_coins": [Vector2(160, 176), Vector2(1033, 155), Vector2(775, 247), Vector2(629, 599)],
		"coins": [], "required": 4,
		"tip": "Monte vers la pièce de gauche, puis traverse le pont."
	}
]

# Les niveaux jouables sont dans l’ordre de progression.
const LEVELS := [HOLES, RIVER_HOLES, FOREST_HOLES, ORCHARD_HOLES, RIDGE_HOLES, CLIFF_HOLES, PERCHED_HOLES,
	WIND_HOLES, CANOPY_HOLES]
enum ShotEnd { SETTLED, OUT_OF_BOUNDS, WATER }
const SKY_BIRD_LIMIT := 2

var current_level := 1
var active_holes: Array = HOLES
var hole_index := 0
var hole: Dictionary
var ground_top := PackedVector2Array()
var soil_surface := PackedVector2Array()
var soil_mid := PackedVector2Array()
var soil_deep := PackedVector2Array()
var soil_bottom := PackedVector2Array()
var grass_base_edge := PackedVector2Array()
var grass_light_edge := PackedVector2Array()
var bridge_plank_style := StyleBoxFlat.new()
var ground_collision: CollisionPolygon2D
var bridge_collision: CollisionShape2D
var rock_collision: CollisionPolygon2D
var rock_span := Vector2.ZERO
var tunnel_collision: CollisionPolygon2D
var elevated_wood: StaticBody2D
var bridge_deck: CollisionPolygon2D
var bounce_trunk: CollisionShape2D
var tunnel_rustled := false
var ball: RigidBody2D
var ball_material: PhysicsMaterial
var coin_sound: AudioStreamPlayer
var open_sound: AudioStreamPlayer
var rim_sound: AudioStreamPlayer
var water_sound: AudioStreamPlayer
var grass_sound: AudioStreamPlayer
var wood_hit_sound: AudioStreamPlayer
var swing_sound: AudioStreamPlayer
var air_sound: AudioStreamPlayer
var flight_sound_pending := false
var shot_started_at := 0.0
var wood_roll_sound: AudioStreamPlayer
var last_contact_sound_time := -10.0
var splash_at := -10.0
var splash_origin := Vector2.ZERO
var cup_opened_at := -1.0
var open_sound_at := -1.0
var rim_near := false
var rim_sound_at := -1.0
var reacted_trees: Array[int] = []
var hole_scores: Array[int] = []
var new_record := false
var playing := false
var game_ui: CanvasLayer
var menu: Control
var menu_design: Control
var course_behind_results := false
var coins: Array[Vector2] = []
var collected: Array[int] = []
var save_data := ConfigFile.new()
var wallet := 0

var dragging := false
var drag_pos := Vector2.ZERO
var drag_start := Vector2.ZERO
var touch_index := -1
var shots := 0
var shot_active := false
var settled_time := 0.0
var tee_position := Vector2.ZERO
var course_width := 1280.0
var course_camera: Camera2D
var last_lie := Vector2.ZERO
var previous_position := Vector2.ZERO
var previous_velocity := Vector2.ZERO
var won := false
var level_complete := false
var transition_left := 0.0
var sink_from := Vector2.ZERO
var sink_progress := 0.0
var notice_left := 0.0
var start_intro_left := 0.0

var animation_time := 0.0
var bird_timer := 10.0
var tree_bird_at := -10.0
var last_impact_time := -10.0
var trail_timer := 0.0
var rng := RandomNumberGenerator.new()
var birds: Array[Dictionary] = []
var particles: Array[Dictionary] = []
var ball_trail: Array[Dictionary] = []
var score_panel: Panel
var info: Label
var power_label: Label
var power_bar: ProgressBar
var status_label: Label
var wallet_label: Label
var intro_label: Label
var wind_badge: Control
var wind := 0


func _ready() -> void:
	bridge_plank_style.bg_color = Color("#b38252")
	bridge_plank_style.border_color = Color("#765135")
	bridge_plank_style.set_border_width_all(2)
	bridge_plank_style.set_corner_radius_all(4)
	rng.randomize()
	save_data.load(SAVE_PATH)
	wallet = int(save_data.get_value("progress", "coins", 0))
	_create_ground()
	course_camera = Camera2D.new()
	course_camera.enabled = false
	add_child(course_camera)
	get_viewport().size_changed.connect(_fit_course_camera)
	_create_ui()
	_create_coin_sound()
	_create_extra_sounds()
	_create_menu()
	_load_hole(0)
	ball.freeze = true
	_show_home()


func _create_ground() -> void:
	var ground := StaticBody2D.new()
	ground.name = "Terrain"
	ground_collision = CollisionPolygon2D.new()
	ground.add_child(ground_collision)
	bridge_collision = CollisionShape2D.new()
	bridge_collision.shape = RectangleShape2D.new()
	bridge_collision.disabled = true
	ground.add_child(bridge_collision)
	add_child(ground)

	ball_material = PhysicsMaterial.new()
	ball_material.bounce = 0.25
	ball_material.friction = 0.24
	ground.physics_material_override = ball_material

	var stone := StaticBody2D.new()
	stone.name = "Rocher"
	var stone_material := PhysicsMaterial.new()
	stone_material.bounce = 0.46
	stone_material.friction = 0.13
	stone.physics_material_override = stone_material
	rock_collision = CollisionPolygon2D.new()
	rock_collision.disabled = true
	stone.add_child(rock_collision)
	add_child(stone)

	var timber := StaticBody2D.new()
	timber.name = "Tronc"
	timber.physics_material_override = ball_material
	tunnel_collision = CollisionPolygon2D.new()
	tunnel_collision.disabled = true
	timber.add_child(tunnel_collision)
	add_child(timber)

	elevated_wood = StaticBody2D.new()
	elevated_wood.name = "Plateformes"
	var platform_material := PhysicsMaterial.new()
	platform_material.bounce = 0.23
	platform_material.absorbent = true
	platform_material.friction = 0.65
	elevated_wood.physics_material_override = platform_material
	bridge_deck = CollisionPolygon2D.new()
	bridge_deck.disabled = true
	elevated_wood.add_child(bridge_deck)
	add_child(elevated_wood)

	var tree := StaticBody2D.new()
	tree.name = "Sapin"
	var bark := PhysicsMaterial.new()
	bark.bounce = 0.12
	bark.friction = 0.04
	tree.physics_material_override = bark
	bounce_trunk = CollisionShape2D.new()
	bounce_trunk.shape = RectangleShape2D.new()
	bounce_trunk.disabled = true
	tree.add_child(bounce_trunk)
	add_child(tree)


func _load_hole(index: int) -> void:
	hole_index = index
	hole = active_holes[index]
	# Le signe donne la direction, la valeur absolue donne le nombre de flèches.
	wind = clampi(int(hole.get("wind", 0)), -3, 3)
	wind_badge.visible = wind != 0
	wind_badge.queue_redraw()
	birds.clear()
	bird_timer = 0.8
	course_width = float(hole.get("width", 1280.0))
	_fit_course_camera()
	ground_top = PackedVector2Array(hole["profile"])
	ground_collision.polygon = _ground_polygon()
	_prepare_terrain_art()
	var deck: Rect2 = hole.get("bridge", Rect2())
	bridge_collision.disabled = deck.size.x <= 0.0
	if not bridge_collision.disabled:
		var shape := bridge_collision.shape as RectangleShape2D
		shape.size = deck.size
		bridge_collision.position = deck.get_center()
	rock_collision.disabled = not hole.has("rock")
	rock_span = Vector2.ZERO
	if not rock_collision.disabled:
		rock_collision.polygon = PackedVector2Array(hole["rock"])
		rock_span = Vector2(INF, -INF)
		for point in rock_collision.polygon:
			rock_span.x = minf(rock_span.x, point.x)
			rock_span.y = maxf(rock_span.y, point.x)
	var roof: Rect2 = hole.get("tunnel", Rect2())
	tunnel_collision.disabled = roof.size.x <= 0.0
	if not tunnel_collision.disabled:
		tunnel_collision.polygon = _tunnel_outline(roof)
	_load_elevated_surfaces()
	tunnel_rustled = false
	splash_at = -10.0
	coins.clear()
	for marker: Vector2 in hole["coins"]:
		coins.append(Vector2(marker.x, _ground_height(marker.x) - marker.y))
	for marker: Vector2 in hole.get("air_coins", []):
		coins.append(marker)
	if hole.has("rock_coin"):
		coins.append(hole["rock_coin"])
	collected.clear()
	reacted_trees.clear()
	if index == 0:
		hole_scores.clear()
		new_record = false
	cup_opened_at = -1.0
	open_sound_at = -1.0
	rim_near = false
	rim_sound_at = -1.0
	shots = 0
	shot_active = false
	settled_time = 0.0
	dragging = false
	touch_index = -1
	won = false
	level_complete = false
	transition_left = 0.0
	sink_progress = 0.0
	notice_left = 0.0
	last_impact_time = -10.0
	last_contact_sound_time = -10.0
	flight_sound_pending = false
	swing_sound.stop()
	air_sound.stop()
	wood_roll_sound.stop()
	wood_hit_sound.stop()
	grass_sound.stop()
	particles.clear()
	var start_x := float(hole["start_x"])
	tee_position = Vector2(start_x, _ground_height(start_x) - BALL_RADIUS - 2.0)
	last_lie = tee_position
	_spawn_ball(tee_position)
	var elevated_layout := not bridge_deck.disabled
	score_panel.size.y = 134.0 if elevated_layout else 170.0
	power_label.position.y = 84.0 if elevated_layout else 94.0
	power_bar.position.y = 113.0 if elevated_layout else 133.0
	start_intro_left = 0.85
	intro_label.position.y = 78.0 if wind != 0 else 26.0
	intro_label.text = "Trou %s  ·  %s" % [_hole_display_number(), hole["name"]]
	intro_label.visible = true
	_refresh_ui()


func _load_elevated_surfaces() -> void:
	for surface: Node in elevated_wood.get_children():
		if surface != bridge_deck:
			elevated_wood.remove_child(surface)
			surface.queue_free()
	for plank: Rect2 in hole.get("platforms", []):
		var surface := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = plank.size
		surface.shape = shape
		surface.position = plank.get_center()
		elevated_wood.add_child(surface)
	var deck := PackedVector2Array(hole.get("suspension_bridge", []))
	bridge_deck.disabled = deck.is_empty()
	if not bridge_deck.disabled:
		var outline := deck.duplicate()
		for i in range(deck.size() - 1, -1, -1):
			outline.append(deck[i] + Vector2(0, 15))
		bridge_deck.polygon = outline
	var trunk: Rect2 = hole.get("bounce_trunk", Rect2())
	bounce_trunk.disabled = not trunk.has_area()
	if not bounce_trunk.disabled:
		var shape := bounce_trunk.shape as RectangleShape2D
		shape.size = trunk.size
		bounce_trunk.position = trunk.get_center()


func _spawn_ball(at: Vector2) -> void:
	if is_instance_valid(ball):
		ball.queue_free()
		remove_child(ball)
	ball_trail.clear()
	trail_timer = 0.0
	ball = RigidBody2D.new()
	ball.name = "Balle"
	ball.position = at
	ball.linear_damp = 0.12
	ball.angular_damp = 0.7
	ball.continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	ball.physics_material_override = ball_material
	ball.contact_monitor = true
	ball.max_contacts_reported = 4
	ball.body_entered.connect(_on_ball_body_entered)
	ball.body_shape_entered.connect(_on_ball_shape_entered)

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = BALL_RADIUS
	shape.shape = circle
	ball.add_child(shape)
	add_child(ball)
	previous_position = at
	previous_velocity = Vector2.ZERO


func _ground_polygon() -> PackedVector2Array:
	var polygon := ground_top.duplicate()
	polygon.append(Vector2(ground_top[-1].x, 800.0))
	polygon.append(Vector2(ground_top[0].x, 800.0))
	return polygon


func _ground_height(x: float) -> float:
	for i in range(ground_top.size() - 1):
		var left := ground_top[i]
		var right := ground_top[i + 1]
		if x >= left.x and x <= right.x:
			return lerpf(left.y, right.y, (x - left.x) / (right.x - left.x))
	return ground_top[0].y if x < ground_top[0].x else ground_top[-1].y


func _cup_mouth() -> Vector2:
	var x := float(hole["cup_x"])
	return Vector2(x, _ground_height(x))


func _cup_open() -> bool:
	return collected.size() >= int(hole["required"])


func _create_coin_sound() -> void:
	coin_sound = AudioStreamPlayer.new()
	coin_sound.max_polyphony = 3
	add_child(coin_sound)
	var chime := AudioStreamWAV.new()
	chime.format = AudioStreamWAV.FORMAT_16_BITS
	chime.mix_rate = 22050
	var samples := PackedByteArray()
	samples.resize(3308 * 2)
	for i in range(3308):
		var t := float(i) / chime.mix_rate
		var envelope := minf(1.0, t * 260.0) * exp(-t * 29.0)
		var tone := sin(TAU * 880.0 * t) + 0.45 * sin(TAU * 1320.0 * t)
		samples.encode_s16(i * 2, roundi(tone * envelope * 3900.0))
	chime.data = samples
	coin_sound.stream = chime


# -----------------------------------
# INTERFACE
# -----------------------------------

func _create_ui() -> void:
	var ui := CanvasLayer.new()
	game_ui = ui
	add_child(ui)

	score_panel = Panel.new()
	score_panel.position = Vector2(18, 16)
	score_panel.size = Vector2(350, 170)
	score_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color("#f8fff2", 0.92)
	panel_style.set_corner_radius_all(18)

	score_panel.add_theme_stylebox_override(
		"panel", panel_style
	)
	ui.add_child(score_panel)

	info = Label.new()
	info.position = Vector2(38, 29)
	info.add_theme_font_size_override("font_size", 24)
	info.add_theme_color_override(
		"font_color", Color("#245246")
	)
	ui.add_child(info)

	power_label = Label.new()
	power_label.position = Vector2(38, 94)
	power_label.add_theme_font_size_override(
		"font_size", 21
	)
	power_label.add_theme_color_override(
		"font_color", Color("#245246")
	)
	ui.add_child(power_label)

	power_bar = ProgressBar.new()
	power_bar.position = Vector2(38, 133)
	power_bar.custom_minimum_size = Vector2(300, 19)
	power_bar.min_value = 0
	power_bar.max_value = 100
	power_bar.show_percentage = false

	var bar_bg = StyleBoxFlat.new()
	bar_bg.bg_color = Color("#dcebd5")
	bar_bg.set_corner_radius_all(8)

	var bar_fill = StyleBoxFlat.new()
	bar_fill.bg_color = Color("#f1aa4e")
	bar_fill.set_corner_radius_all(8)

	power_bar.add_theme_stylebox_override(
		"background", bar_bg
	)
	power_bar.add_theme_stylebox_override(
		"fill", bar_fill
	)
	ui.add_child(power_bar)

	var reset = Button.new()
	reset.text = "Recommencer"
	reset.position = Vector2(1056, 25)
	reset.custom_minimum_size = Vector2(192, 55)

	var reset_style = StyleBoxFlat.new()
	reset_style.bg_color = Color("#fff5da")
	reset_style.set_corner_radius_all(14)

	reset.add_theme_stylebox_override(
		"normal", reset_style
	)
	reset.add_theme_color_override(
		"font_color", Color("#31544c")
	)
	reset.pressed.connect(restart)
	ui.add_child(reset)
	var back := Button.new()
	back.text = "Niveaux"
	back.position = Vector2(1056, 90)
	back.custom_minimum_size = Vector2(192, 48)
	back.add_theme_stylebox_override("normal", reset_style)
	back.add_theme_color_override("font_color", Color("#31544c"))
	back.pressed.connect(_show_levels)
	ui.add_child(back)

	wallet_label = Label.new()
	wallet_label.position = Vector2(38, 60)
	wallet_label.add_theme_font_size_override("font_size", 18)
	wallet_label.add_theme_color_override("font_color", Color("#245246"))
	ui.add_child(wallet_label)

	status_label = Label.new()
	status_label.position = Vector2(27, 671)
	status_label.add_theme_font_size_override("font_size", 21)
	status_label.add_theme_color_override("font_color", Color("#fff8e9"))
	status_label.add_theme_color_override("font_shadow_color", Color("#5d452c"))
	status_label.add_theme_constant_override("shadow_offset_y", 2)
	ui.add_child(status_label)

	intro_label = Label.new()
	intro_label.position = Vector2(425, 26)
	intro_label.custom_minimum_size = Vector2(430, 48)
	intro_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	intro_label.add_theme_font_size_override("font_size", 26)
	intro_label.add_theme_color_override("font_color", Color("#245246"))
	intro_label.add_theme_stylebox_override("normal", panel_style)
	ui.add_child(intro_label)

	wind_badge = Control.new()
	wind_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(wind_badge)
	wind_badge.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	wind_badge.offset_left = -90.0
	wind_badge.offset_right = 90.0
	wind_badge.offset_top = 22.0
	wind_badge.offset_bottom = 68.0
	wind_badge.draw.connect(_draw_wind_badge)
	_screen_label(wind_badge, "Vent", Rect2(14, 0, 50, 46), 20, Color("#245246"), 0.4, true)


func _draw_wind_badge() -> void:
	_menu_box(wind_badge, Rect2(0, 3, 180, 46), Color("#245246", 0.22), 20)
	_menu_box(wind_badge, Rect2(0, 0, 180, 46), Color("#f8fff2"), 20)
	_menu_box(wind_badge, Rect2(69, 6, 105, 34), Color("#dcefe5"), 14)

	var count := absi(wind)
	var direction := float(signi(wind))
	var ink := Color("#277365")
	for i in range(count):
		var center := Vector2(121.5 + (float(i) - (count - 1) * 0.5) * 28.0, 23.0)
		var tail := center - Vector2(8.0 * direction, 0.0)
		var tip := center + Vector2(9.0 * direction, 0.0)
		var upper := tip + Vector2(-6.0 * direction, -6.0)
		var lower := tip + Vector2(-6.0 * direction, 6.0)
		wind_badge.draw_line(tail, tip, ink, 3.2, true)
		wind_badge.draw_polyline(PackedVector2Array([upper, tip, lower]), ink, 3.2, true)
		for end: Vector2 in [tail, upper, lower]:
			wind_badge.draw_circle(end, 1.6, ink, true, -1.0, true)


func _create_menu() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 2
	add_child(layer)
	menu = Control.new()
	layer.add_child(menu)
	menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu.resized.connect(_fit_menu)


func _clear_menu() -> void:
	for child in menu.get_children():
		menu.remove_child(child)
		child.queue_free()
	menu_design = null
	menu.show()
	game_ui.hide()


func _fit_menu() -> void:
	if not is_instance_valid(menu_design):
		return
	var fit := minf(menu.size.x / 1280.0, menu.size.y / 720.0)
	menu_design.scale = Vector2.ONE * fit
	menu_design.position = (menu.size - Vector2(1280, 720) * fit) * 0.5


func _screen(screen: String) -> Control:
	_clear_menu()
	course_behind_results = false
	queue_redraw()

	var base := ColorRect.new()
	base.color = Color("#133832")
	base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu.add_child(base)
	base.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	base.draw.connect(_draw_menu_background.bind(base, screen))
	base.resized.connect(base.queue_redraw)

	menu_design = Control.new()
	menu_design.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_design.size = Vector2(1280, 720)
	menu.add_child(menu_design)
	_fit_menu()
	return menu_design


func _place(control: Control, box: Rect2) -> void:
	control.position = box.position
	control.size = box.size


func _screen_label(parent: Control, caption: String, box: Rect2, font_size: int,
		ink: Color, weight: float = 0.0, centered: bool = false) -> Label:
	var label := _menu_text(parent, caption, font_size, ink)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if centered else HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if weight > 0.0:
		var font := FontVariation.new()
		font.base_font = ThemeDB.fallback_font
		font.variation_embolden = weight
		label.add_theme_font_override("font", font)
	_place(label, box)
	return label


func _screen_button(parent: Control, caption: String, action: Callable, box: Rect2,
		accent: bool = false) -> Button:
	var button := Button.new()
	button.text = caption
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_size_override("font_size", 23)
	var normal := Color("#f4d277") if accent else Color("#214a42")
	var hover := Color("#ffe494") if accent else Color("#2d5b50")
	var pressed := Color("#ddb857") if accent else Color("#173831")
	button.add_theme_stylebox_override("normal", _surface(normal, 16))
	button.add_theme_stylebox_override("hover", _surface(hover, 16))
	button.add_theme_stylebox_override("pressed", _surface(pressed, 16))
	var focus := _surface(Color.TRANSPARENT, 16)
	focus.set_border_width_all(2)
	focus.border_color = Color("#fff2c8")
	button.add_theme_stylebox_override("focus", focus)
	var ink := Color("#20382d") if accent else Color("#f2fae8")
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		button.add_theme_color_override(state, ink)
	button.pressed.connect(action)
	parent.add_child(button)
	_place(button, box)
	return button


func _section_header(root: Control, caption: String, back: Callable) -> void:
	_screen_button(root, "‹   Retour", back, Rect2(64, 46, 143, 50))
	_screen_label(root, caption, Rect2(64, 115, 1100, 77), 57, Color("#fbf8e6"), 0.8)
	var rule := ColorRect.new()
	rule.color = Color("#547a65", 0.55)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(rule)
	_place(rule, Rect2(64, 207, 1152, 2))


func _show_home() -> void:
	playing = false
	var root := _screen("home")
	_screen_label(root, "Pocket", Rect2(75, 175, 490, 114), 100, Color("#fff8e4"), 1.0)
	_screen_label(root, "Golf", Rect2(71, 260, 490, 140), 132, Color("#f4d277"), 1.0)
	_screen_button(root, "Jouer    ›", _show_worlds, Rect2(80, 448, 260, 73), true)


func _show_worlds() -> void:
	var root := _screen("worlds")
	_section_header(root, "Choisir un monde", _show_home)
	_world_card(root, Rect2(64, 243, 368, 356), "Monde 1", "Green Valley", 0, _show_levels)
	_world_card(root, Rect2(456, 243, 368, 356), "Monde 2", "Dunes dorées", 1, Callable())
	_world_card(root, Rect2(848, 243, 368, 356), "Monde 3", "Sommets givrés", 2, Callable())


func _world_card(root: Control, box: Rect2, number: String, title: String,
		biome: int, action: Callable) -> void:
	var available := action.is_valid()
	var card := Button.new()
	card.text = "%s  ·  %s" % [number, title]
	card.flat = true
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color", "font_disabled_color"]:
		card.add_theme_color_override(state, Color.TRANSPARENT)
	card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if available else Control.CURSOR_ARROW
	card.disabled = not available
	root.add_child(card)
	_place(card, box)
	if available:
		card.pressed.connect(action)
	var art := Control.new()
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(art)
	_place(art, Rect2(Vector2.ZERO, box.size))
	art.draw.connect(_draw_world_card.bind(art, card, biome, available))
	card.mouse_entered.connect(art.queue_redraw)
	card.mouse_exited.connect(art.queue_redraw)
	card.focus_entered.connect(art.queue_redraw)
	card.focus_exited.connect(art.queue_redraw)

	_screen_label(card, number, Rect2(21, 238, 309, 28), 18, Color("#bad5bd"), 0.25)
	_screen_label(card, title, Rect2(21, 268, 329, 42), 32, Color("#f7faea"), 0.55)
	_screen_label(card, "12 niveaux" if available else "À venir",
		Rect2(21, 315, 309, 24), 17, Color("#f4d277") if available else Color("#c4d3cd"))
	if available:
		_screen_label(card, "›", Rect2(306, 270, 45, 45), 37, Color("#f4d277"), 0.5, true)


func _show_levels() -> void:
	playing = false
	course_camera.enabled = false
	dragging = false
	shot_active = false
	touch_index = -1
	ball.freeze = true
	var root := _screen("levels")
	_section_header(root, "Green Valley", _show_worlds)

	var cover := Control.new()
	cover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(cover)
	_place(cover, Rect2(64, 242, 347, 372))
	cover.draw.connect(_draw_level_cover.bind(cover))
	var completed := 0
	for number in range(1, LEVELS.size() + 1):
		if _best_score(number) > 0 or save_data.get_value("progress", _unlock_key(number + 1), false):
			completed += 1
	var completion := "12 niveaux"
	if completed == 1:
		completion = "1 niveau terminé sur 12"
	elif completed > 1:
		completion = "%d niveaux terminés sur 12" % completed
	_screen_label(cover, completion, Rect2(24, 284, 298, 38), 22, Color("#f7faea"), 0.45)
	var best := _best_score(1)
	if best > 0:
		_screen_label(cover, "Record du niveau 1 · %d coups" % best,
			Rect2(24, 325, 299, 25), 17, Color("#e7ca7a"))

	for number in range(1, 13):
		var column := (number - 1) % 4
		var row := floori(float(number - 1) / 4.0)
		var box := Rect2(446 + column * 196, 242 + row * 129, 182, 114)
		_level_tile(root, box, number)


func _level_tile(root: Control, box: Rect2, number: int) -> void:
	var available := _can_play(number)
	var caption := "Jouer" if available else ("À débloquer" if number <= LEVELS.size() else "À venir")
	var button := Button.new()
	button.text = "%d   %s" % [number, caption]
	button.flat = true
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color", "font_disabled_color"]:
		button.add_theme_color_override(state, Color.TRANSPARENT)
	button.disabled = not available
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if available else Control.CURSOR_ARROW
	root.add_child(button)
	_place(button, box)
	var art := Control.new()
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(art)
	_place(art, Rect2(Vector2.ZERO, box.size))
	art.draw.connect(_draw_level_tile.bind(art, button, available))
	button.mouse_entered.connect(art.queue_redraw)
	button.mouse_exited.connect(art.queue_redraw)
	button.focus_entered.connect(art.queue_redraw)
	button.focus_exited.connect(art.queue_redraw)
	if available:
		button.pressed.connect(_start_level.bind(number))
	var ink := Color("#213a31") if available else Color("#d3e1d3")
	_screen_label(button, str(number), Rect2(17, 13, 104, 49), 36, ink, 0.65)
	var best := _best_score(number)
	var detail := "Record · %d coups" % best if best > 0 else caption
	_screen_label(button, detail, Rect2(18, 72, 149, 29), 17, ink, 0.20)


func _menu_panel(dim: Color, size: Vector2) -> VBoxContainer:
	_clear_menu()
	var backdrop := ColorRect.new()
	backdrop.color = dim
	menu.add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var center := CenterContainer.new()
	menu.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = size
	panel.add_theme_stylebox_override("panel", _surface(Color("#f8fff2"), 26, 30.0))
	center.add_child(panel)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 15)
	stack.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(stack)
	return stack


func _surface(color: Color, radius: int, padding: float = 0.0) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(radius)
	style.content_margin_top = padding
	style.content_margin_bottom = padding
	style.content_margin_left = padding
	style.content_margin_right = padding
	return style


func _menu_text(parent: Control, caption: String, font_size: int, color: Color = Color("#245246")) -> Label:
	var label := Label.new()
	label.text = caption
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)
	return label


func _menu_button(parent: Control, caption: String, action: Callable, size: Vector2, primary: bool = false) -> Button:
	var button := Button.new()
	button.text = caption
	button.custom_minimum_size = size
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_size_override("font_size", 22)
	button.add_theme_stylebox_override("normal", _surface(Color("#257054") if primary else Color("#e0efd9"), 15))
	button.add_theme_stylebox_override("hover", _surface(Color("#30805f") if primary else Color("#cce8c4"), 15))
	button.add_theme_stylebox_override("pressed", _surface(Color("#205c47") if primary else Color("#badcae"), 15))
	button.add_theme_stylebox_override("disabled", _surface(Color("#eef0e8"), 15))
	var ink := Color.WHITE if primary else Color("#245246")
	for color_name in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		button.add_theme_color_override(color_name, ink)
	button.add_theme_color_override("font_disabled_color", Color("#607267"))
	parent.add_child(button)
	if action.is_valid():
		button.pressed.connect(action)
	else:
		button.disabled = true
	return button


func _best_key(number: int) -> String:
	return "level_%d_best" % number


func _best_score(number: int) -> int:
	return int(save_data.get_value("progress", _best_key(number), 0))


func _current_record_key() -> String:
	if active_holes.size() < HOLES_PER_LEVEL:
		return "level_%d_hole_%d_best" % [current_level, hole_index + 1]
	return _best_key(current_level)


func _hole_display_number() -> String:
	if active_holes.size() < HOLES_PER_LEVEL:
		return "%d.%d" % [current_level, hole_index + 1]
	return "%d/%d" % [hole_index + 1, active_holes.size()]


func _unlock_key(number: int) -> String:
	return "level_%d_unlocked" % number


func _can_play(number: int) -> bool:
	if number < 1 or number > LEVELS.size():
		return false
	return number == 1 or save_data.get_value("progress", _unlock_key(number), false) or _best_score(number - 1) > 0


func _start_level(number: int) -> void:
	if not _can_play(number):
		return
	current_level = number
	active_holes = LEVELS[number - 1]
	course_behind_results = false
	playing = true
	menu.hide()
	game_ui.show()
	_load_hole(0)


func _total_shots() -> int:
	var total := 0
	for count in hole_scores:
		total += count
	return total


func _show_results() -> void:
	var total := _total_shots()
	var best := int(save_data.get_value("progress", _current_record_key(), 0))
	var partial_level := active_holes.size() < HOLES_PER_LEVEL

	playing = false
	course_behind_results = true
	var next_level := current_level + 1
	var has_next := not partial_level and _can_play(next_level)
	var stack := _menu_panel(Color("#103b32", 0.32), Vector2(500, 505 if has_next else 440))
	var title := "Trou %s réussi !" % _hole_display_number() if partial_level else "Niveau %d réussi !" % current_level
	_menu_text(stack, title, 38)
	if not partial_level:
		for i in range(hole_scores.size()):
			_menu_text(stack, "Trou %d  ·  %d coup%s" % [i + 1, hole_scores[i], "" if hole_scores[i] == 1 else "s"], 21)
	_menu_text(stack, "%d coups" % total if partial_level else "Total  ·  %d coups" % total, 28)
	_menu_text(stack, ("%s  ·  %d coups" % ["Nouveau record" if new_record else "Meilleur total", best]), 19)
	if has_next:
		_menu_button(stack, "Jouer au niveau %d" % next_level, _start_level.bind(next_level), Vector2(260, 56), true)
	_menu_button(stack, "Rejouer le trou" if partial_level else "Rejouer le niveau",
		_start_level.bind(current_level), Vector2(260, 56), not has_next)
	_menu_button(stack, "Choisir un niveau", _show_levels, Vector2(260, 49))


func _draw_menu_background(canvas: Control, screen: String) -> void:
	var zoom := maxf(canvas.size.x / 1280.0, canvas.size.y / 720.0)
	canvas.draw_set_transform((canvas.size - Vector2(1280, 720) * zoom) * 0.5, 0.0, Vector2.ONE * zoom)
	if screen == "home":
		_draw_home_illustration(canvas)
		return
	_menu_gradient(canvas, Rect2(0, 0, 1280, 720), Color("#123831"), Color("#234c3f"))
	var tint := Color("#739677", 0.19)
	for i in range(6):
		var points := PackedVector2Array()
		for j in range(58):
			var t := float(j) / 57.0
			points.append(Vector2(740 + t * 635, 671 - i * 20.0 + sin(t * 7.5 + i * 0.17) * 32.0 - t * 110.0))
		canvas.draw_polyline(points, tint, 1.2, true)


func _draw_home_illustration(canvas: Control) -> void:
	_menu_gradient(canvas, Rect2(0, 0, 1280, 720), Color("#64adab"), Color("#f5d898"))
	for band in range(3, 0, -1):
		canvas.draw_circle(Vector2(998, 175), 73 + band * 23, Color("#ffeaa8", 0.13), true, -1.0, true)
	canvas.draw_circle(Vector2(998, 175), 73, Color("#fff1b6"), true, -1.0, true)
	_menu_cloud(canvas, Vector2(762, 146), 0.74, Color("#eaf3dc", 0.84))
	_menu_cloud(canvas, Vector2(1195, 251), 0.85, Color("#fff3cf", 0.82))
	_menu_shape(canvas, Color("#8ab7a1"), [0, 498, 512, 422, 675, 277, 747, 240, 809, 290, 875, 351,
		961, 267, 1004, 247, 1084, 312, 1154, 358, 1280, 270, 1280, 720, 0, 720])
	_menu_shape(canvas, Color("#bcd6b7"), [650, 300, 747, 240, 809, 290, 827, 307, 779, 289,
		751, 306, 725, 286, 700, 308])
	_menu_shape(canvas, Color("#639b84"), [485, 476, 674, 390, 720, 351, 765, 341, 841, 367, 899, 403,
		980, 389, 1059, 334, 1106, 326, 1166, 345, 1280, 410, 1280, 720, 485, 720])

	_menu_ridge(canvas, Color("#649569"), 456, 114, 0.43, 1.6)
	_menu_ridge(canvas, Color("#3d795c"), 531, 105, 0.62, 3.5)
	_menu_shape(canvas, Color("#83b36b"), [579, 542, 711, 530, 856, 540, 964, 518, 1049, 475,
		1121, 455, 1216, 459, 1280, 481, 1280, 720, 579, 720])
	_menu_shape(canvas, Color("#a9cd79"), [617, 594, 735, 577, 827, 587, 925, 579, 1010, 550,
		1097, 502, 1162, 491, 1280, 510, 1280, 720, 617, 720])
	_menu_shape(canvas, Color("#7aa559"), [633, 684, 775, 654, 895, 663, 1010, 639, 1082, 610,
		1168, 607, 1280, 632, 1280, 720, 633, 720])
	_menu_pond(canvas)
	for tree: Vector3 in [Vector3(674, 500, 0.65), Vector3(735, 493, 0.52), Vector3(805, 551, 0.52),
		Vector3(1159, 510, 0.67), Vector3(1217, 537, 1.05), Vector3(1275, 550, 0.83),
		Vector3(662, 718, 1.32), Vector3(1252, 712, 1.25)]:
		_menu_pine(canvas, Vector2(tree.x, tree.y), tree.z, Color("#245c4c"), Color("#458364"))
	_menu_flag(canvas, Vector2(1102, 527), 1.13)
	_menu_bird(canvas, Vector2(824, 219), 0.9, Color("#4e8176"))
	for pos: Vector2 in [Vector2(719, 688), Vector2(736, 681), Vector2(1193, 656),
		Vector2(1208, 663), Vector2(1153, 700), Vector2(1140, 693), Vector2(1022, 688)]:
		canvas.draw_line(pos, pos + Vector2(2, 7), Color("#336846"), 2.0, true)
		canvas.draw_circle(pos, 2.7, Color("#f6d77a"), true, -1.0, true)

	_menu_shape(canvas, Color("#163c33"), [0, 0, 559, 0, 583, 82, 591, 177, 578, 256,
		595, 355, 570, 454, 600, 548, 631, 637, 686, 720, 0, 720])
	_menu_shape(canvas, Color("#1c473c"), [0, 574, 119, 619, 199, 631, 330, 598, 432, 592,
		505, 613, 564, 656, 621, 720, 0, 720])
	_menu_shape(canvas, Color("#12362e"), [0, 653, 99, 681, 234, 660, 305, 665, 396, 690,
		506, 686, 616, 720, 0, 720])


func _draw_world_card(canvas: Control, button: Button, biome: int, available: bool) -> void:
	var focus := available and (button.is_hovered() or button.has_focus())
	var edge := Color("#f4d277") if focus else Color("#567767")
	_menu_box(canvas, Rect2(0, 5, 368, 351), Color("#102c28"), 20)
	_menu_box(canvas, Rect2(0, 0, 368, 350), edge, 20)
	_menu_box(canvas, Rect2(2, 2, 364, 346), Color("#1b4139") if available else Color("#1c3733"), 18)
	_draw_biome_art(canvas, Rect2(10, 10, 348, 213), biome)
	if not available:
		_menu_box(canvas, Rect2(10, 10, 348, 213), Color("#15332d", 0.16), 12)


func _draw_level_cover(canvas: Control) -> void:
	_menu_box(canvas, Rect2(0, 5, 347, 368), Color("#102c28"), 20)
	_menu_box(canvas, Rect2(0, 0, 347, 368), Color("#547765"), 20)
	_menu_box(canvas, Rect2(2, 2, 343, 364), Color("#1b4139"), 18)
	_draw_biome_art(canvas, Rect2(10, 10, 327, 257), 0)


func _draw_level_tile(canvas: Control, button: Button, available: bool) -> void:
	var focus := available and (button.is_hovered() or button.has_focus())
	var edge := Color("#fff0b5") if available else Color("#517564")
	_menu_box(canvas, Rect2(0, 4, 182, 110), Color("#112d28"), 17)
	_menu_box(canvas, Rect2(0, 0, 182, 110), edge, 17)
	var fill := Color("#f4d277") if available else Color("#264c42")
	if focus:
		fill = Color("#ffe49d")
	_menu_box(canvas, Rect2(2, 2, 178, 106), fill, 15)
	if available:
		_menu_flag(canvas, Vector2(148, 62), 0.48)
	else:
		canvas.draw_arc(Vector2(150, 27), 5.5, PI, TAU, 12, Color("#99b4a3"), 2.2, true)
		_menu_box(canvas, Rect2(142, 27, 16, 12), Color("#99b4a3"), 3)


func _draw_biome_art(canvas: Control, box: Rect2, biome: int) -> void:
	var palette := [
		["#66b5af", "#f6e2a7", "#8ebfa8", "#d1e3bc", "#5b9472", "#92bd68", "#578c59"],
		["#c9865e", "#ffe0a0", "#bb785c", "#efa474", "#c38559", "#e5aa64", "#ae694b"],
		["#6796b6", "#e2e9d4", "#819eaf", "#f3f5e6", "#789cac", "#b5d3ce", "#55798a"]
	][biome] as Array
	var points := PackedVector2Array()
	var stops := PackedColorArray()
	for y: float in [0.0, 1.0]:
		for x: float in [0.0, 1.0]:
			points.append(box.position + box.size * Vector2(x, y))
			stops.append(Color(palette[int(y)]))
	canvas.draw_polygon(PackedVector2Array([points[0], points[1], points[3], points[2]]),
		PackedColorArray([stops[0], stops[1], stops[3], stops[2]]))

	var art_origin := box.position
	var art_scale := box.size / Vector2(348, 213)
	var sun_at := Vector2(268, 48) if biome != 2 else Vector2(81, 45)
	canvas.draw_circle(art_origin + sun_at * art_scale, 23.0 * minf(art_scale.x, art_scale.y),
		Color("#fff1be"), true, -1.0, true)
	_menu_cloud(canvas, art_origin + Vector2(92, 45) * art_scale, 0.40 * art_scale.x, Color("#fdf1d3", 0.65))
	if biome == 1:
		_menu_shape(canvas, Color(palette[2]), [0, 134, 57, 114, 89, 85, 112, 82, 142, 58,
			196, 58, 209, 67, 220, 92, 260, 112, 285, 91, 320, 88, 348, 105, 348, 213, 0, 213], art_origin, art_scale)
		_menu_shape(canvas, Color(palette[3]), [89, 85, 112, 82, 142, 58, 196, 58, 209, 67,
			212, 76, 163, 68, 147, 77, 127, 79, 115, 94], art_origin, art_scale)
	else:
		_menu_shape(canvas, Color(palette[2]), [0, 144, 48, 108, 84, 78, 110, 66, 157, 108,
			193, 75, 225, 36, 243, 53, 277, 99, 308, 73, 348, 111, 348, 213, 0, 213], art_origin, art_scale)
		_menu_shape(canvas, Color(palette[3]), [174, 93, 225, 36, 243, 53, 269, 90,
			241, 70, 229, 77, 211, 67, 197, 84], art_origin, art_scale)
	_menu_shape(canvas, Color(palette[4]), [0, 153, 44, 137, 90, 131, 134, 143, 172, 151,
		211, 139, 251, 121, 292, 117, 330, 124, 348, 133, 348, 213, 0, 213], art_origin, art_scale)
	_menu_shape(canvas, Color(palette[5]), [0, 172, 40, 163, 82, 159, 127, 173, 175, 179,
		231, 163, 276, 147, 319, 151, 348, 161, 348, 213, 0, 213], art_origin, art_scale)
	_menu_shape(canvas, Color(palette[6]), [0, 197, 43, 190, 96, 198, 139, 202, 206, 197,
		254, 182, 302, 177, 348, 184, 348, 213, 0, 213], art_origin, art_scale)
	if biome == 1:
		for pos: Vector2 in [Vector2(47, 188), Vector2(79, 197), Vector2(316, 170)]:
			_menu_cactus(canvas, art_origin + pos * art_scale, art_scale.x)
	else:
		var dark := Color("#245b4d") if biome == 0 else Color("#426978")
		var light := Color("#4c8b63") if biome == 0 else Color("#8bb0b1")
		for tree: Vector3 in [Vector3(36, 183, 0.71), Vector3(63, 174, 0.51), Vector3(304, 170, 0.55),
			Vector3(325, 177, 0.67)]:
			_menu_pine(canvas, art_origin + Vector2(tree.x, tree.y) * art_scale, tree.z * art_scale.x, dark, light)
	if biome == 0:
		_menu_flag(canvas, art_origin + Vector2(244, 173) * art_scale, 0.60 * art_scale.x)


func _menu_box(canvas: Control, rect: Rect2, color: Color, radius: int) -> void:
	canvas.draw_style_box(_surface(color, radius), rect)


func _menu_gradient(canvas: Control, rect: Rect2, top: Color, bottom: Color) -> void:
	var vertices := PackedVector2Array([rect.position, Vector2(rect.end.x, rect.position.y), rect.end,
		Vector2(rect.position.x, rect.end.y)])
	canvas.draw_polygon(vertices, PackedColorArray([top, top, bottom, bottom]))


func _menu_shape(canvas: Control, color: Color, coordinates: Array, origin := Vector2.ZERO,
		factor := Vector2.ONE) -> void:
	var points := PackedVector2Array()
	for i in range(0, coordinates.size(), 2):
		points.append(origin + Vector2(coordinates[i], coordinates[i + 1]) * factor)
	canvas.draw_colored_polygon(points, color)


func _menu_ridge(canvas: Control, color: Color, baseline: float, rise: float, frequency: float, phase: float) -> void:
	var points := PackedVector2Array()
	for i in range(65):
		var x := i * 20.0
		var y := baseline + sin(float(i) * frequency / 4.0 + phase) * rise * 0.50
		y += sin(float(i) * frequency / 2.0 + phase * 0.7) * rise * 0.16
		points.append(Vector2(x, y))
	points.append(Vector2(1280, 720))
	points.append(Vector2(0, 720))
	canvas.draw_colored_polygon(points, color)


func _menu_cloud(canvas: Control, at: Vector2, size_factor: float, color: Color) -> void:
	_menu_shape(canvas, color, [-78, 8, -58, -1, -46, -1, -29, -17, -9, -21, 13, -15,
		27, -3, 47, -7, 67, -2, 85, 8, 68, 13, -66, 13], at, Vector2.ONE * size_factor)


func _menu_pine(canvas: Control, base: Vector2, size_factor: float, dark: Color, light: Color) -> void:
	var factor := Vector2.ONE * size_factor
	_menu_shape(canvas, Color("#665843"), [-4, 0, -2, -31, 4, -31, 6, 0], base, factor)
	_menu_shape(canvas, dark, [0, -98, 16, -69, 10, -69, 24, -48, 16, -49, 31, -20, 13, -23,
		15, -15, 0, -19, -16, -16, -14, -23, -30, -20, -16, -49, -23, -47, -10, -69, -16, -68], base, factor)
	_menu_shape(canvas, light, [0, -98, 0, -19, -16, -16, -14, -23, -30, -20, -16, -49, -23, -47,
		-10, -69, -16, -68], base, factor)


func _menu_flag(canvas: Control, base: Vector2, size_factor: float) -> void:
	var factor := Vector2.ONE * size_factor
	_menu_shape(canvas, Color("#34664d", 0.7), [-21, 0, -12, -4, 5, -5, 22, 0, 10, 4, -10, 4], base, factor)
	canvas.draw_line(base, base + Vector2(0, -72) * size_factor, Color("#fff7d6"), 3.3 * size_factor, true)
	_menu_shape(canvas, Color("#f39c62"), [1, -69, 17, -66, 38, -58, 17, -52, 1, -54], base, factor)
	_menu_shape(canvas, Color("#e56b50"), [1, -56, 17, -55, 38, -58, 17, -52, 1, -54], base, factor)


func _menu_bird(canvas: Control, at: Vector2, factor: float, color: Color) -> void:
	var points := PackedVector2Array()
	for point: Vector2 in [Vector2(-14, -4), Vector2(-7, -3), Vector2(0, 3), Vector2(7, -3), Vector2(14, -4)]:
		points.append(at + point * factor)
	canvas.draw_polyline(points, color, 2.7 * factor, true)


func _menu_pond(canvas: Control) -> void:
	_menu_shape(canvas, Color("#669f7e"), [729, 626, 749, 610, 787, 600, 837, 601, 867, 592,
		903, 592, 924, 604, 909, 617, 869, 632, 803, 648, 760, 644], Vector2(0, 4))
	_menu_shape(canvas, Color("#68acaa"), [729, 626, 749, 610, 787, 600, 837, 601, 867, 592,
		903, 592, 924, 604, 909, 617, 869, 632, 803, 648, 760, 644])
	_menu_shape(canvas, Color("#8ac4b8"), [747, 618, 787, 606, 838, 608, 874, 598, 904, 598,
		899, 606, 865, 616, 814, 620, 772, 629])
	for at: Vector2 in [Vector2(784, 628), Vector2(829, 635), Vector2(866, 610), Vector2(752, 631)]:
		canvas.draw_line(at, at + Vector2(22, -2), Color("#c8dec5", 0.66), 2, true)


func _menu_cactus(canvas: Control, at: Vector2, factor: float) -> void:
	var tint := Color("#537052")
	canvas.draw_line(at, at + Vector2(0, -28) * factor, tint, 7.0 * factor, true)
	canvas.draw_polyline(PackedVector2Array([at + Vector2(-12, -21) * factor, at + Vector2(-12, -12) * factor,
		at + Vector2(10, -12) * factor, at + Vector2(10, -19) * factor]), tint, 4.0 * factor, true)


func _make_ball_sound(kind: String) -> AudioStreamWAV:
	var durations := {"water": 0.30, "grass": 0.21, "wood_hit": 0.15,
		"swing": 0.29, "air": 0.34, "wood_roll": 1.40}
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	var duration: float = durations[kind]
	var count := roundi(duration * stream.mix_rate)
	var looped := kind == "wood_roll"
	var data := PackedByteArray()
	data.resize(count * 2)

	var noise := RandomNumberGenerator.new()
	noise.seed = 3419
	var low := 0.0
	var middle := 0.0
	var seam := 768
	var texture := PackedFloat32Array()
	var soft_texture := PackedFloat32Array()
	var brushed := 0.0
	var rounded := 0.0
	# Le souffle et l’herbe ont leur propre filtre, avec une atténuation progressive des aigus.
	for i in range(count + seam):
		var white := noise.randf_range(-1.0, 1.0)
		low = lerpf(low, white, 0.037)
		middle = lerpf(middle, white, 0.13)
		var band := middle - low
		texture.append(band)
		brushed = lerpf(brushed, band, 0.17)
		rounded = lerpf(rounded, brushed, 0.18)
		soft_texture.append(rounded)

	for i in range(count):
		var t := float(i) / stream.mix_rate
		var grain := texture[i]
		if looped and i < seam:
			grain = lerpf(texture[count + i], grain, smoothstep(0.0, float(seam), float(i)))
		var sample := 0.0
		match kind:
			"water":
				# Le corps grave descend, puis deux petites bulles répondent.
				var base := sin(TAU * (174.0 * t - 225.0 * t * t))
				var bubble := _water_bubble(t - 0.046, 228.0) + 0.38 * _water_bubble(t - 0.112, 295.0)
				sample = base * exp(-t * 28.0) * 0.81 + bubble * 0.45
				sample += grain * exp(-t * 48.0) * 0.25
				sample *= smoothstep(0.0, 0.003, t)
			"grass":
				var brush := smoothstep(0.0, 0.029, t) * (1.0 - smoothstep(0.047, 0.185, t))
				var weight := sin(TAU * (125.0 * t - 110.0 * t * t)) * exp(-t * 47.0)
				sample = (soft_texture[i] * 2.9 + weight * 0.12) * brush
			"wood_hit":
				var body := sin(TAU * 184.0 * t) * exp(-t * 29.0)
				var tap := sin(TAU * 428.0 * t) * exp(-t * 48.0)
				var edge := sin(TAU * 722.0 * t) * exp(-t * 88.0)
				sample = (0.53 * body + 0.38 * tap + 0.13 * edge) * smoothstep(0.0, 0.003, t)
			"swing":
				var sweep := smoothstep(0.0, 0.065, t) * (1.0 - smoothstep(0.077, duration, t))
				var edge := sin(PI * smoothstep(0.0, duration, t))
				sample = (soft_texture[i] * 2.7 + grain * edge * 0.26) * sweep
			"air":
				var drift := pow(sin(PI * t / duration), 1.7)
				sample = soft_texture[i] * drift * 2.4
			"wood_roll":
				var joint := fposmod(t * 10.0, 1.0)
				var hum := 0.095 * sin(TAU * 145.0 * t) + 0.048 * sin(TAU * 255.0 * t)
				sample = (grain * 0.72 + hum) * (0.76 + 0.24 * cos(TAU * joint))
		if not looped:
			sample *= 1.0 - smoothstep(duration - 0.045, duration, t)
		data.encode_s16(i * 2, roundi(clampf(sample, -1.0, 1.0) * 15500.0))
	stream.data = data
	if looped:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		stream.loop_end = count
	return stream


func _water_bubble(t: float, pitch: float) -> float:
	if t < 0.0:
		return 0.0
	return sin(TAU * (pitch * t + 230.0 * t * t)) * exp(-t * 31.0) * smoothstep(0.0, 0.006, t)


func _ball_sound_player(kind: String) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.stream = _make_ball_sound(kind)
	add_child(player)
	return player


func _update_ball_audio(delta: float) -> void:
	var wood_volume := 0.0
	if playing and shot_active:
		var velocity := ball.linear_velocity
		var grounded := ball.get_contact_count() > 0
		var elapsed := animation_time - shot_started_at
		if flight_sound_pending and elapsed >= 0.27:
			flight_sound_pending = false
			if not grounded and velocity.length() > 410.0:
				air_sound.volume_db = lerpf(-33.0, -28.0, smoothstep(410.0, 950.0, velocity.length()))
				air_sound.play()
		if grounded and _ball_on_bridge():
			wood_volume = 0.31 * smoothstep(22.0, 550.0, absf(velocity.x))
			wood_roll_sound.pitch_scale = lerpf(0.75, 1.30, smoothstep(22.0, 550.0, absf(velocity.x)))
		if air_sound.playing and grounded:
			air_sound.volume_db = move_toward(air_sound.volume_db, -60.0, delta * 280.0)
	elif air_sound.playing:
		air_sound.volume_db = move_toward(air_sound.volume_db, -60.0, delta * 280.0)
	_fade_ball_loop(wood_roll_sound, wood_volume, delta)


func _fade_ball_loop(player: AudioStreamPlayer, target: float, delta: float) -> void:
	var current := db_to_linear(player.volume_db)
	if not player.playing:
		if target < 0.002:
			return
		current = 0.0
		player.volume_db = -60.0
		player.play()
	var next := lerpf(current, target, 1.0 - exp(-delta * 36.0))
	if target == 0.0 and next < 0.002:
		player.stop()
		player.volume_db = -60.0
	else:
		player.volume_db = linear_to_db(maxf(next, 0.001))


func _ball_on_bridge() -> bool:
	if ball.get_colliding_bodies().has(elevated_wood):
		return true
	if bridge_collision.disabled:
		return false
	var deck: Rect2 = hole["bridge"]
	var center := ball.position
	var sole := center.y + BALL_RADIUS
	return center.x >= deck.position.x and center.x <= deck.end.x and absf(sole - deck.position.y) <= 4.0


func _on_ball_shape_entered(_body_rid: RID, body: Node, body_shape_index: int, _local_shape_index: int) -> void:
	if not playing or not shot_active or not body is StaticBody2D:
		return
	var down_speed := previous_velocity.y
	if down_speed < 52.0 or animation_time - last_contact_sound_time < 0.105:
		return
	var surface := body as StaticBody2D
	var owner := surface.shape_find_owner(body_shape_index)
	var shape_owner := surface.shape_owner_get_owner(owner)
	var is_wood := surface == elevated_wood or shape_owner == bridge_collision or shape_owner == tunnel_collision
	var player := wood_hit_sound if is_wood else grass_sound
	var strength := smoothstep(52.0, 650.0, down_speed)
	player.volume_db = lerpf(-21.0, -9.0, strength) if is_wood else lerpf(-24.0, -15.0, strength)
	player.pitch_scale = lerpf(1.08, 0.92, strength) if is_wood else 1.0
	player.play()
	last_contact_sound_time = animation_time


func _hit_water(from: Vector2, to: Vector2) -> bool:
	if not hole.has("water") or to.y <= from.y:
		return false
	var water: Vector3 = hole["water"]
	var center_y := water.z - BALL_RADIUS + 5.0
	if to.y < center_y or from.y >= center_y:
		return false
	var x := lerpf(from.x, to.x, (center_y - from.y) / (to.y - from.y))
	# Au niveau de l'eau, le sol d'une berge doit passer sous la surface.
	if x <= water.x or x >= water.y or _ground_height(x) < water.z + 4.0:
		return false
	var bridge: Rect2 = hole.get("bridge", Rect2())
	if bridge.size.x > 0.0 and x >= bridge.position.x and x <= bridge.end.x:
		return false

	var origin := Vector2(x, water.z)
	splash_at = animation_time
	splash_origin = origin
	water_sound.play()
	for i in range(17):
		var speed := Vector2(rng.randf_range(-105.0, 105.0), rng.randf_range(-230.0, -82.0))
		_add_particle(origin, speed, Color("#bcf5f1"), rng.randf_range(0.23, 0.53), rng.randf_range(2.0, 4.4), 540.0)
	_end_shot(ShotEnd.WATER)
	return true


func _river_far_y(x: float) -> float:
	return 437.0 + sin(x * 0.0066 + 0.22) * 9.0 + sin(x * 0.012) * 2.0


func _river_near_y(x: float) -> float:
	return _river_far_y(x) + 50.0 + sin(x * 0.0049 + 1.7) * 6.0


func _river_hill_y(x: float) -> float:
	return _river_far_y(x) - (32.0 + sin(x * 0.006 - 1.2) * 5.0)


func _draw_river_background() -> void:
	var far_edge := PackedVector2Array()
	var near_edge := PackedVector2Array()
	var bank := PackedVector2Array()
	for i in range(85):
		var x := -32.0 + i * 16.0
		far_edge.append(Vector2(x, _river_far_y(x)))
		near_edge.append(Vector2(x, _river_near_y(x)))
		bank.append(Vector2(x, _river_hill_y(x)))
	bank.append(Vector2(far_edge[-1].x, 765.0))
	bank.append(Vector2(far_edge[0].x, 765.0))
	draw_colored_polygon(bank, Color("#88bc83"))
	draw_polyline(far_edge, Color("#659e83"), 2.2, true)
	draw_polyline(near_edge, Color("#669e83"), 1.8, true)
	_draw_gradient_band(far_edge, near_edge, 0.0, 0.51, Color("#72b8b2"), Color("#3c9295"))
	_draw_gradient_band(far_edge, near_edge, 0.51, 1.0, Color("#3c9295"), Color("#69aba0"))
	_draw_gradient_band(far_edge, near_edge, 0.024, 0.09, Color("#b5dec3", 0.50), Color("#b5dec3", 0.03))
	_draw_gradient_band(far_edge, near_edge, 0.92, 0.985, Color("#b5dec3", 0.02), Color("#b5dec3", 0.31))

	for i in range(8):
		var phase := fposmod(float(i) / 8.0 + animation_time * 0.009, 1.0)
		var center := lerpf(-95.0, 1380.0, phase)
		var width := 35.0 + float((i * 31) % 37)
		var depth := 0.25 + float((i * 13) % 6) * 0.095
		var reflection := PackedVector2Array()
		for j in range(21):
			var ratio := float(j) / 20.0
			var x := center + (ratio - 0.5) * width
			var curve := sin(ratio * PI) * sin(animation_time * 0.70 + i) * 1.4
			reflection.append(Vector2(x, lerpf(_river_far_y(x), _river_near_y(x), depth) + curve))
		for j in range(20, -1, -1):
			var thickness := 2.5 * sin(float(j) / 20.0 * PI)
			reflection.append(reflection[j] + Vector2(0.0, thickness))
		draw_colored_polygon(reflection, Color("#c4e7d5", 0.39))

	for tree: Vector2 in [Vector2(47, 0.28), Vector2(92, 0.32), Vector2(251, 0.28),
		Vector2(759, 0.31), Vector2(816, 0.27), Vector2(1032, 0.29), Vector2(1065, 0.26)]:
		var root_y := lerpf(_river_hill_y(tree.x), _river_far_y(tree.x), 0.42)
		_draw_pine(tree.x, root_y, tree.y)


func _draw_gradient_band(upper: PackedVector2Array, lower: PackedVector2Array,
		start: float, end: float, top_color: Color, bottom_color: Color) -> void:
	# Chaque bande est un ruban de triangles qui suit le contour de ses deux bords.
	var vertices := PackedVector2Array()
	var colors := PackedColorArray()
	for i in range(upper.size()):
		vertices.append(upper[i].lerp(lower[i], start))
		vertices.append(upper[i].lerp(lower[i], end))
		colors.append(top_color)
		colors.append(bottom_color)
	var indices := PackedInt32Array()
	for i in range(upper.size() - 1):
		var first := i * 2
		indices.append_array(PackedInt32Array([first, first + 2, first + 1,
			first + 1, first + 2, first + 3]))
	RenderingServer.canvas_item_add_triangle_array(get_canvas_item(), indices, vertices, colors)


func _draw_playable_water() -> void:
	if not hole.has("water"):
		return
	var water: Vector3 = hole["water"]
	var surface := PackedVector2Array()
	var bottom := PackedVector2Array()
	for i in range(57):
		var ratio := float(i) / 56.0
		var x := lerpf(water.x, water.y, ratio)
		var floor_y := _ground_height(x)
		var taper := sin(ratio * PI)
		var swell := sin(ratio * TAU * 1.8 - animation_time * 1.65) * taper * 3.8
		var surface_y := minf(floor_y, water.z + swell) - 0.3
		surface.append(Vector2(x, surface_y))
		bottom.append(Vector2(x, floor_y))
	_draw_gradient_band(surface, bottom, 0.0, 0.46, Color("#57c6c5"), Color("#268fa4"))
	_draw_gradient_band(surface, bottom, 0.46, 1.0, Color("#268fa4"), Color("#086d8b"))

	for i in range(2):
		var upper := PackedVector2Array()
		var lower := PackedVector2Array()
		var depth := 0.20 + float(i) * 0.31
		for j in range(surface.size()):
			var ratio := float(j) / float(surface.size() - 1)
			var bend := sin(ratio * TAU + animation_time * 0.65 + i) * 0.08
			upper.append(surface[j].lerp(bottom[j], depth + bend))
			lower.append(surface[j].lerp(bottom[j], depth + bend + 0.14 * sin(ratio * PI)))
		_draw_gradient_band(upper, lower, 0.0, 1.0, Color("#a6e9de", 0.01), Color("#91dfd7", 0.16))

	_draw_gradient_band(surface, bottom, 0.0, 0.063, Color("#dcfff0", 0.81), Color("#b3f9e9", 0.03))
	draw_polyline(surface, Color("#bce7d5", 0.89), 1.7, true)
	_draw_splash_rings(water, surface, bottom)


func _draw_splash_rings(water: Vector3, surface: PackedVector2Array, bottom: PackedVector2Array) -> void:
	var elapsed := animation_time - splash_at
	for i in range(3):
		var age := elapsed - float(i) * 0.12
		if age < 0.0 or age > 0.75:
			continue
		var margin := minf(splash_origin.x - water.x, water.y - splash_origin.x)
		var radius := minf(7.0 + 75.0 * age, maxf(0.0, margin - 7.0))
		if radius < 3.0:
			continue
		var ring := PackedVector2Array()
		for j in range(29):
			var angle := float(j) * TAU / 28.0
			var x := splash_origin.x + cos(angle) * radius
			var ratio := inverse_lerp(water.x, water.y, x)
			var index := clampi(roundi(ratio * (surface.size() - 1)), 0, surface.size() - 1)
			var depth := bottom[index].y - surface[index].y
			var offset := clampf(8.0 + sin(angle) * radius * 0.10, 1.0, maxf(1.0, depth - 2.0))
			ring.append(Vector2(x, surface[index].y + offset))
		draw_polyline(ring, Color("#e1fffb", 0.85 * (1.0 - age / 0.75)), 1.7, true)


func _draw_bridge() -> void:
	var deck: Rect2 = hole.get("bridge", Rect2())
	if deck.size.x <= 0.0:
		return
	for x in [deck.position.x + 23.0, deck.end.x - 23.0]:
		var post_top := Vector2(x, deck.position.y - 21.0)
		var post_base := Vector2(x, deck.position.y + 44.0)
		draw_line(post_top, post_base, Color("#765236"), 13.0, true)
		draw_line(post_top + Vector2(-1.5, 0.0), post_base + Vector2(-1.5, -1.0), Color("#b17d50"), 8.0, true)
		draw_line(post_top + Vector2(-3.0, 1.0), post_base + Vector2(-3.0, -2.0), Color("#dfae73"), 2.0, true)
		draw_circle(post_top, 5.2, Color("#c49363"), true, -1.0, true)
	draw_line(deck.position + Vector2(23.0, -16.0), Vector2(deck.end.x - 23.0, deck.position.y - 16.0),
		Color("#a57248", 0.78), 4.0, true)
	draw_style_box(bridge_plank_style, deck)
	for i in range(1, 15):
		var x := deck.position.x + deck.size.x * float(i) / 15.0
		draw_line(Vector2(x, deck.position.y + 3.0), Vector2(x, deck.end.y - 1.0), Color("#805637"), 1.5, true)
		if i % 3 == 1:
			draw_circle(Vector2(x - 4.0, deck.position.y + 7.5), 1.5, Color("#75593c"), true, -1.0, true)
	draw_line(deck.position + Vector2(4, 2), Vector2(deck.end.x - 4.0, deck.position.y + 2),
		Color("#edba7b"), 2.0, true)


func _create_extra_sounds() -> void:
	# Les ouvertures et les frôlements utilisent des lecteurs indépendants.
	open_sound = AudioStreamPlayer.new()
	open_sound.stream = _make_effect_sound(true)
	add_child(open_sound)
	rim_sound = AudioStreamPlayer.new()
	rim_sound.stream = _make_effect_sound(false)
	add_child(rim_sound)
	water_sound = _ball_sound_player("water")
	water_sound.volume_db = -7.0
	grass_sound = _ball_sound_player("grass")
	wood_hit_sound = _ball_sound_player("wood_hit")
	swing_sound = _ball_sound_player("swing")
	air_sound = _ball_sound_player("air")
	wood_roll_sound = _ball_sound_player("wood_roll")
	wood_roll_sound.volume_db = -60.0


func _make_effect_sound(opening: bool) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	var duration := 0.35 if opening else 0.13
	var count := roundi(duration * stream.mix_rate)
	var data := PackedByteArray()
	data.resize(count * 2)
	for i in range(count):
		var t := float(i) / stream.mix_rate
		var sample := 0.0
		if opening:
			var slide := sin(TAU * (420.0 * t + 980.0 * t * t)) * exp(-t * 28.0)
			var rise := 0.0
			if t >= 0.075:
				var note := t - 0.075
				rise = (sin(TAU * 987.77 * note) + 0.42 * sin(TAU * 1480.0 * note))
				rise *= minf(note * 180.0, 1.0) * exp(-note * 17.0)
			sample = (0.65 * slide + rise) * minf(t * 190.0, 1.0) * 4600.0
		else:
			sample = (sin(TAU * 400.0 * t) + 0.40 * sin(TAU * 1050.0 * t))
			sample *= minf(t * 320.0, 1.0) * exp(-t * 42.0) * 3050.0
		data.encode_s16(i * 2, roundi(sample))
	stream.data = data
	return stream


func _begin_cup_opening() -> void:
	cup_opened_at = animation_time
	open_sound_at = animation_time + 0.12
	var mouth := _cup_mouth()
	for i in range(10):
		var velocity := Vector2(rng.randf_range(-100.0, 100.0), rng.randf_range(-155.0, -68.0))
		_add_particle(mouth, velocity, Color("#ffd877"), rng.randf_range(0.23, 0.45), 3.0, 340.0)


func _draw_cup_cover() -> void:
	draw_rect(Rect2(-18.0, -2.0, 36.0, 8.0), Color("#375345"))
	var opening := 0.0
	if _cup_open():
		opening = 1.0 if cup_opened_at < 0.0 else smoothstep(0.0, 0.27, animation_time - cup_opened_at)
	if opening < 1.0:
		var lift := sin(opening * PI) * 9.0
		var color := Color("#c2a071", 1.0 - opening)
		var cover := Rect2(-18.0 + opening * 42.0, -2.0 - lift, 36.0, 8.0)
		draw_rect(cover, color)
		draw_line(cover.position, cover.position + Vector2(36.0, 0.0), Color("#fff2c3", 1.0 - opening), 2.0, true)


func _react_near_trees(from: Vector2, to: Vector2) -> void:
	var pines := _course_pines()
	for i in range(pines.size()):
		if reacted_trees.has(i):
			continue
		var pine: Vector2 = pines[i]
		if _over_water(pine.x) or _over_void(pine.x):
			continue
		var branch := Vector2(pine.x, _ground_height(pine.x) - 88.0 * pine.y)
		if Geometry2D.get_closest_point_to_segment(branch, from, to).distance_to(branch) > 40.0 * pine.y + 15.0:
			continue
		reacted_trees.append(i)
		if birds.size() < SKY_BIRD_LIMIT and animation_time - tree_bird_at >= 4.0:
			tree_bird_at = animation_time
			var edges := _bird_screen_edges()
			var direction := -1.0 if branch.x < (edges.x + edges.y) * 0.5 else 1.0
			birds.append({"pos": branch, "speed": direction * 155.0, "rise": 175.0, "phase": 0.0, "size": 0.68})
		for j in range(5):
			var velocity := Vector2(rng.randf_range(-48.0, 48.0), rng.randf_range(-62.0, -20.0))
			_add_particle(branch, velocity, Color("#a3c86b"), rng.randf_range(0.6, 0.95), 3.3, 100.0)


func _draw_mole() -> void:
	if not hole.has("mole"):
		return
	var location: Vector2 = hole["mole"]
	var center := Vector2(location.x, _ground_height(location.x) + location.y)
	draw_set_transform(center)
	draw_circle(Vector2(-25.0, 0.0), 29.0, Color("#78543f"), true, -1.0, true)
	draw_circle(Vector2(25.0, 0.0), 29.0, Color("#78543f"), true, -1.0, true)
	draw_rect(Rect2(-25.0, -29.0, 50.0, 58.0), Color("#78543f"))
	draw_line(Vector2(-39.0, 23.0), Vector2(39.0, 23.0), Color("#a77450"), 3.0, true)
	var cheer := sin(animation_time * 15.0) * 3.0 if won else 0.0
	draw_circle(Vector2(0.0, 7.0 + cheer), 19.0, Color("#5e453d"), true, -1.0, true)
	draw_circle(Vector2(0.0, -3.0 + cheer), 16.0, Color("#8b6856"), true, -1.0, true)
	var look := (ball.position - center).normalized() * 1.6 if playing else Vector2.ZERO
	for side: float in [-1.0, 1.0]:
		var eye := Vector2(5.0 * side, -7.0 + cheer)
		draw_circle(eye, 3.5, Color("#f9ecd1"), true, -1.0, true)
		draw_circle(eye + look, 1.8, Color("#2f2925"), true, -1.0, true)
		var paw := Vector2(19.0 * side, (-13.0 if won else 14.0) + cheer)
		draw_circle(paw, 5.0, Color("#d2a188"), true, -1.0, true)
	draw_circle(Vector2(0.0, 1.0 + cheer), 4.5, Color("#e1a18e"), true, -1.0, true)
	draw_set_transform(Vector2.ZERO)


func _process(delta: float) -> void:
	_update_ball_audio(delta)
	if not playing and not course_behind_results:
		return
	animation_time += delta
	_update_birds(delta)
	queue_redraw()
	if not playing:
		return
	if open_sound_at >= 0.0 and animation_time >= open_sound_at:
		open_sound_at = -1.0
		open_sound.play()
	if start_intro_left > 0.0:
		start_intro_left -= delta
		intro_label.visible = start_intro_left > 0.0
	if notice_left > 0.0:
		notice_left -= delta
		if notice_left <= 0.0:
			_refresh_ui()
	_update_particles(delta)
	_update_trail(delta)

	var percent := roundi(_power_ratio() * 100.0)
	power_bar.value = percent
	power_label.text = "Puissance : %d %%" % percent


func _physics_process(delta: float) -> void:
	if not playing:
		return
	if won:
		sink_progress = minf(sink_progress + delta / 0.28, 1.0)
	if transition_left > 0.0:
		transition_left -= delta
		if transition_left <= 0.0:
			if won and hole_index == active_holes.size() - 1:
				level_complete = active_holes.size() >= HOLES_PER_LEVEL
				_show_results()
			else:
				_load_hole(hole_index + 1 if won else 0)
		return
	if won:
		return

	var position_now := ball.position
	if shot_active:
		if hole.get("relay", false) and position_now.y > 656.0:
			_end_shot(ShotEnd.OUT_OF_BOUNDS)
			return
		if _hit_water(previous_position, position_now):
			return
		_collect_coins(previous_position, position_now)
		_rustle_tunnel(previous_position, position_now)
		_react_near_trees(previous_position, position_now)
		var velocity := ball.linear_velocity
		var grounded := ball.get_contact_count() > 0
		var horizontal_speed := maxf(absf(velocity.x), absf(position_now.x - previous_position.x) / delta)
		var landing := _lands_in_cup(previous_position, position_now, previous_velocity, delta)
		var near_ground := grounded or absf(position_now.y - previous_position.y) < 3.0
		var rolling_in := near_ground and horizontal_speed <= CUP_ROLL_SPEED_LIMIT
		var speed := maxf(velocity.length(), previous_position.distance_to(position_now) / delta)
		var crosses_opening := _crosses_cup(previous_position, position_now)
		var near_rim := _cup_open() and (landing or _crosses_cup(previous_position, position_now, Vector2(25.0, 11.0)))
		if near_rim and not rim_near and speed > 20.0 and animation_time >= rim_sound_at:
			rim_sound_at = animation_time + 0.24
			rim_sound.play()
		rim_near = near_rim
		if landing or crosses_opening:
			if _cup_open() and (landing or rolling_in):
				_finish_hole()
				return
			if not _cup_open() and notice_left <= 0.0:
				var missing := int(hole["required"]) - collected.size()
				var piece_label := "pièce" if missing == 1 else "pièces"
				_show_notice("Il manque %d %s pour ouvrir le trou." % [missing, piece_label])

		if position_now.x < -BALL_RADIUS or position_now.x > course_width + BALL_RADIUS or position_now.y > 775.0:
			_end_shot(ShotEnd.OUT_OF_BOUNDS)
			return

		var wind_strength := absi(wind)
		var wind_direction := signi(wind)
		if wind_strength > 0:
			var acceleration: float = WIND_ACCELERATIONS[wind_strength] * wind_direction
			if grounded:
				acceleration *= WIND_GROUND_SCALE
			ball.apply_central_force(Vector2(acceleration * ball.mass, 0.0))
		if grounded and absf(velocity.x) > 0.5:
			var deceleration := ROLL_DECELERATION
			for plank: Rect2 in hole.get("platforms", []):
				var on_top := absf(position_now.y + BALL_RADIUS - plank.position.y) <= 3.0
				if on_top and position_now.x >= plank.position.x and position_now.x <= plank.end.x:
					deceleration = PLATFORM_ROLL_DECELERATION
					break
			ball.apply_central_force(Vector2(-signf(velocity.x) * deceleration, 0.0))

		# En vent fort, laisser la balle repartir avant de terminer le coup.
		var strong_wind := wind_strength == 3
		var settle_speed := 38.0 if strong_wind else 19.0
		var settle_delay := 1.15 if strong_wind else 0.20
		var can_settle := not strong_wind or velocity.x * wind_direction >= -0.5
		if grounded and can_settle and velocity.length() < settle_speed:
			settled_time += delta
			if settled_time >= settle_delay:
				_end_shot()
		else:
			settled_time = 0.0
	previous_position = ball.position
	previous_velocity = ball.linear_velocity


func _lands_in_cup(from: Vector2, to: Vector2, incoming: Vector2, delta: float) -> bool:
	# Le choc avec le sol peut avoir déjà inversé la vitesse dans ce pas de physique.
	# On garde la vitesse d'avant le contact pour retrouver le point d'arrivée.
	if incoming.y < maxf(90.0, absf(incoming.x) * 0.55):
		return false
	var mouth := _cup_mouth()
	var contact_y := mouth.y - BALL_RADIUS - 1.0
	if from.y > contact_y + 2.0 or to.y < contact_y - 5.0:
		return false
	var time := maxf(0.0, (contact_y - from.y) / incoming.y)
	if time > delta * 1.12:
		return false
	return absf(from.x + incoming.x * time - mouth.x) <= CUP_HALF_WIDTH


func _crosses_cup(from: Vector2, to: Vector2, radii: Vector2 = Vector2(CUP_HALF_WIDTH, 7.0)) -> bool:
	# La zone est centrée sur une balle au ras de l'ouverture, sous le drapeau.
	var target := _cup_mouth() - Vector2(0.0, BALL_RADIUS)
	var capture_scale := Vector2(1.0 / radii.x, 1.0 / radii.y)
	var a := (from - target) * capture_scale
	var b := (to - target) * capture_scale
	return Geometry2D.get_closest_point_to_segment(Vector2.ZERO, a, b).length_squared() <= 1.0


func _collect_coins(from: Vector2, to: Vector2) -> void:
	var was_open := _cup_open()
	for i in range(coins.size()):
		if collected.has(i):
			continue
		var nearest := Geometry2D.get_closest_point_to_segment(coins[i], from, to)
		if nearest.distance_to(coins[i]) > BALL_RADIUS + COIN_RADIUS:
			continue
		collected.append(i)
		coin_sound.play()
		_emit_landing_particles(coins[i], 165.0)
		notice_left = 0.0
		_refresh_ui()
	if not was_open and _cup_open():
		_begin_cup_opening()


func _finish_hole() -> void:
	won = true
	shot_active = false
	dragging = false
	ball.freeze = true
	sink_from = ball.position
	sink_progress = 0.0
	notice_left = 0.0
	transition_left = 0.95
	hole_scores.append(shots)

	for i in collected:
		# Le niveau 1 conserve ses anciennes clés pour ne pas recréditer ses pièces.
		var key := "%d_%d" % [hole_index, i]
		if current_level != 1:
			key = "%d_%s" % [current_level, key]
		if not save_data.get_value("collected", key, false):
			save_data.set_value("collected", key, true)
			wallet += 1
	save_data.set_value("progress", "coins", wallet)
	if hole_index == active_holes.size() - 1:
		if active_holes.size() >= HOLES_PER_LEVEL:
			save_data.set_value("progress", _unlock_key(current_level + 1), true)
		var total := _total_shots()
		var record_key := _current_record_key()
		var best := int(save_data.get_value("progress", record_key, 0))
		new_record = best == 0 or total < best
		if new_record:
			save_data.set_value("progress", record_key, total)
	_save_progress()
	_refresh_ui()
	status_label.text = "Trou réussi !"


func _save_progress() -> void:
	if save_data.save(SAVE_PATH) != OK:
		push_warning("Impossible d’enregistrer la progression de Green Valley.")


func _end_shot(reason: ShotEnd = ShotEnd.SETTLED) -> void:
	shot_active = false
	settled_time = 0.0
	if shots >= int(hole["limit"]):
		ball.freeze = true
		transition_left = 1.25
		notice_left = 0.0
		status_label.text = "Plus de coups. Retour au trou 1."
		if reason == ShotEnd.WATER:
			status_label.text = "Dans l’eau ! Retour au trou 1."
		elif reason == ShotEnd.OUT_OF_BOUNDS:
			status_label.text = "Hors parcours ! Retour au trou 1."
		return
	match reason:
		ShotEnd.OUT_OF_BOUNDS:
			_spawn_ball(tee_position)
			_show_notice("Hors parcours ! La balle revient au départ du trou.")
		ShotEnd.WATER:
			_spawn_ball(last_lie)
			_show_notice("Dans l’eau ! La balle revient à son dernier emplacement.")
		ShotEnd.SETTLED:
			ball.linear_velocity = Vector2.ZERO
			ball.angular_velocity = 0.0


func _refresh_ui() -> void:
	info.text = "Trou %s · %d coups restants" % [_hole_display_number(), int(hole["limit"]) - shots]
	wallet_label.text = "Pièces gagnées : %d" % wallet
	if int(hole["required"]) > 0:
		var required := int(hole["required"])
		var detail: String = "Trou ouvert." if _cup_open() else hole["tip"]
		if hole.has("bounce_trunk"):
			if _cup_open():
				detail = "Saute par-dessus l’eau vers le drapeau."
			elif collected.has(0) and collected.has(1):
				detail = "Pose-toi à droite, puis tire sous le pont vers le tronc."
				if collected.has(2) and not collected.has(3):
					detail = "Récupère la pièce entre le tronc et l’eau."
		status_label.text = "%d/%d %s · %s" % [
			collected.size(), required, "pièce" if required == 1 else "pièces", detail
		]
	else:
		status_label.text = hole["tip"]


func _show_notice(message: String) -> void:
	notice_left = 1.45
	status_label.text = message


func _fit_course_camera() -> void:
	# Les positions, la gravité et les collisions restent en unités du parcours.
	# Seuls les trous larges utilisent cette caméra fixe.
	var viewport_size := get_viewport_rect().size
	var zoom := viewport_size.x / course_width
	course_camera.zoom = Vector2.ONE * zoom
	course_camera.position = Vector2(viewport_size.x * 0.5 / zoom, 720.0 - viewport_size.y * 0.5 / zoom)
	course_camera.enabled = course_width > 1280.0 and (playing or course_behind_results)
	if course_camera.enabled:
		course_camera.force_update_scroll()


func _screen_to_world(pos: Vector2) -> Vector2:
	return get_canvas_transform().affine_inverse() * pos


func _pull_vector() -> Vector2:
	return ball.position - _screen_to_world(drag_pos) if dragging else Vector2.ZERO


func _power_ratio() -> float:
	return clampf(_pull_vector().length() / MAX_DRAG, 0.0, 1.0)


func _input(event: InputEvent) -> void:
	if not playing or won or transition_left > 0.0 or not is_instance_valid(ball):
		return

	if event is InputEventScreenTouch:
		if event.pressed and touch_index == -1:
			touch_index = event.index
			_handle_pointer(true, event.position)
		elif event.index == touch_index and not event.pressed:
			touch_index = -1
			if event.canceled:
				dragging = false
			else:
				_handle_pointer(false, event.position)
	elif event is InputEventScreenDrag:
		if dragging and event.index == touch_index:
			drag_pos = event.position
	elif touch_index == -1 and event.device != InputEvent.DEVICE_ID_EMULATION:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			_handle_pointer(event.pressed, event.position)
		elif event is InputEventMouseMotion and dragging:
			drag_pos = event.position


func _handle_pointer(pressed: bool, pos: Vector2) -> void:
	if pressed:
		var point := _screen_to_world(pos)
		if not shot_active and ball.get_contact_count() > 0 and ball.linear_velocity.length() < 25.0:
			if point.distance_to(ball.position) < 90.0:
				dragging = true
				drag_start = pos
				drag_pos = pos
		return
	if not dragging:
		return

	drag_pos = pos
	var direction := _pull_vector()
	dragging = false
	if direction.length() <= 10.0 or drag_start.distance_to(pos) <= 8.0:
		return

	rim_near = false
	last_lie = ball.position
	previous_position = ball.position
	shot_active = true
	settled_time = 0.0
	shots += 1
	_refresh_ui()
	var impulse := direction.limit_length(MAX_DRAG) * POWER
	previous_velocity = impulse / ball.mass
	ball.apply_central_impulse(impulse)
	var force := smoothstep(65.0, MAX_DRAG * POWER, impulse.length())
	swing_sound.volume_db = lerpf(-25.0, -12.0, force)
	swing_sound.pitch_scale = lerpf(0.96, 1.12, force)
	swing_sound.play()
	shot_started_at = animation_time
	flight_sound_pending = impulse.y < -120.0
	_emit_shot_particles()


func restart() -> void:
	_load_hole(0)


# -----------------------------------
# DESSIN DU MONDE
# -----------------------------------

func _draw() -> void:
	if not playing and not course_behind_results:
		return
	if course_camera.enabled:
		var inverse := get_canvas_transform().affine_inverse()
		var backdrop_scale := get_viewport_rect().size / Vector2(1280.0, 720.0)
		draw_set_transform(inverse.origin, 0.0, backdrop_scale / course_camera.zoom.x)
	_draw_sky()
	_draw_sun()
	_draw_clouds()
	_draw_mountains()
	_draw_distant_hills()
	if current_level == 1 or current_level >= 8:
		_draw_valley_details()
	if current_level == 2:
		_draw_river_background()
	elif current_level == 3:
		_draw_forest_background()
	elif current_level == 4:
		_draw_orchard()
	elif current_level == 5:
		_draw_ridge_background()
	elif current_level == 6:
		_draw_cliff_background()
	elif current_level == 7:
		_draw_perched_background()
	elif current_level == 9:
		_draw_canopy_valley()
	draw_set_transform(Vector2.ZERO)
	_draw_birds()
	_draw_vegetation_back()
	if current_level == 6 and not rock_collision.disabled:
		if hole_index == 1:
			_draw_cliff_boulder(rock_collision.polygon)
		else:
			_draw_cliff_slab(rock_collision.polygon)
	_draw_terrain()
	if hole.get("relay", false):
		_draw_relay_rock()
	_draw_playable_water()
	_draw_bridge()
	_draw_elevated_surfaces()
	if current_level == 8 and hole.has("rock"):
		_draw_wind_ledge()
	if current_level == 3:
		_draw_forest_obstacle()
	elif current_level == 6:
		_draw_cliff_ferns()
	_draw_mole()
	_draw_grass_and_flowers()
	_draw_foreground()
	if current_level == 9:
		_draw_canopy_banks()
	if current_level == 8 and absi(wind) >= 2:
		_draw_wind_streaks()
	if playing:
		_draw_flag_and_hole()
		_draw_coins()
		_draw_ball_trail()
		_draw_ball()
		_draw_particles()
		if dragging:
			_draw_aiming_guide()


func _draw_wind_ledge() -> void:
	var edge := rock_collision.polygon
	var left_seam := Vector2(735, 561)
	var right_seam := Vector2(871, 553)
	var foot := Vector2(805, 625)
	draw_colored_polygon(edge, Color("#627b75"))
	_cliff_patch([edge[0], edge[1], edge[2], left_seam, foot, edge[8], edge[9]], Color("#8ca396"))
	_cliff_patch([edge[1], edge[2], edge[3], edge[4], edge[5], edge[6], right_seam, left_seam], Color("#aabb9d"))
	_cliff_patch([edge[6], edge[7], edge[8], foot, right_seam], Color("#718b81"))
	var lip := edge.slice(2, 7)
	_cliff_patch([edge[2], edge[3], edge[4], edge[5], edge[6], Vector2(921, 534),
		Vector2(891, 527), Vector2(847, 553), Vector2(733, 550), Vector2(674, 537)], Color("#91bf71"))
	draw_polyline(lip, Color("#cfe69c"), 3.0, true)
	draw_polyline(PackedVector2Array([Vector2(740, 573), Vector2(760, 583), Vector2(756, 601)]),
		Color("#657f72"), 2.0, true)


func _draw_elevated_surfaces() -> void:
	if bridge_deck.disabled:
		return
	_draw_canopy_fir()
	_draw_canopy_ledge()

	for plank: Rect2 in hole["platforms"]:
		draw_style_box(bridge_plank_style, plank)
		draw_rect(Rect2(plank.position + Vector2(3, 8), Vector2(plank.size.x - 6, 5)), Color("#986039"))
		draw_line(plank.position + Vector2(5, 3), Vector2(plank.end.x - 5, plank.position.y + 3),
			Color("#f3c681"), 2.5, true)
		for offset: float in [0.30, 0.58, 0.81]:
			var at := plank.position + Vector2(plank.size.x * offset, 7)
			draw_line(at, at + Vector2(14, 0), Color("#d09a5f"), 1.1, true)
		for x: float in [plank.position.x + 11, plank.end.x - 11]:
			draw_circle(Vector2(x, plank.position.y + 9), 2.2, Color("#68492e"), true, -1.0, true)
			draw_circle(Vector2(x - 0.6, plank.position.y + 8.2), 0.8, Color("#e1b77f"), true, -1.0, true)

	var deck := PackedVector2Array(hole["suspension_bridge"])
	var rope := PackedVector2Array()
	for point in deck.slice(1, -1):
		rope.append(point - Vector2(0, 27))
	for i in range(rope.size() - 1):
		var step_count := ceili(rope[i].distance_to(rope[i + 1]) / 22.0)
		for j in range(step_count):
			var at := rope[i].lerp(rope[i + 1], float(j) / step_count)
			draw_line(at, at + Vector2(0, 27), Color("#8f6744"), 1.6, true)
	draw_polyline(rope, Color("#785034"), 4.5, true)
	draw_polyline(rope, Color("#dcb37b"), 2.0, true)
	for at: Vector2 in [deck[1], deck[-2]]:
		draw_line(at + Vector2(0, 15), at - Vector2(0, 38), Color("#795036"), 9.0, true)
		draw_line(at + Vector2(-2, 13), at - Vector2(2, 38), Color("#d3975c"), 3.0, true)
		draw_polyline(PackedVector2Array([at + Vector2(-14, 12), at - Vector2(0, 20),
			at + Vector2(14, 12)]), Color("#a57950"), 3.2, true)
		draw_circle(at - Vector2(0, 27), 4.5, Color("#edc684"), true, -1.0, true)
	var board_bottom := PackedVector2Array()
	for at in deck:
		board_bottom.append(at + Vector2(0, 15))
	_draw_gradient_band(deck, board_bottom, 0.0, 1.0, Color("#ce8b50"), Color("#874e32"))
	draw_polyline(board_bottom, Color("#694631"), 2.2, true)
	draw_polyline(deck, Color("#e9b674"), 3.5, true)
	for i in range(deck.size() - 1):
		var plank_count := ceili(deck[i].distance_to(deck[i + 1]) / 14.0)
		for j in range(plank_count):
			var at := deck[i].lerp(deck[i + 1], float(j) / plank_count)
			draw_line(at + Vector2(0, 3), at + Vector2(0, 14), Color("#795033"), 1.4, true)
			draw_line(at + Vector2(2, 6), at + Vector2(7, 6), Color("#e1a163"), 1.1, true)


func _draw_canopy_fir() -> void:
	var trunk: Rect2 = hole["bounce_trunk"]
	_draw_pine(trunk.get_center().x, trunk.end.y, 1.88, trunk.size.x, 53.0)


func _draw_canopy_ledge() -> void:
	var cliff := rock_collision.polygon
	var grass := cliff.slice(1, 9)
	var turf_bottom := PackedVector2Array()
	var ledge_lower := PackedVector2Array()
	for at in grass:
		var depth := lerpf(3.0, 10.0 + sin(at.x * 0.12) * 2.0, smoothstep(1007.0, 1040.0, at.x))
		turf_bottom.append(at + Vector2(1, depth))
		ledge_lower.append(at + Vector2(6, depth + lerpf(7.0, 23.0, smoothstep(1007.0, 1040.0, at.x))))

	draw_colored_polygon(cliff, Color("#80685e"))
	_cliff_patch([cliff[0], cliff[1], cliff[2], cliff[3], cliff[4], cliff[5], cliff[6], cliff[7], cliff[8],
		Vector2(1320, 335), Vector2(1250, 367), Vector2(1221, 401), Vector2(1167, 413),
		Vector2(1093, 411), cliff[13]], Color("#b29377"))
	_cliff_patch([cliff[0], cliff[13], cliff[12], Vector2(1100, 417), Vector2(1051, 409)],
		Color("#a4806b"))
	_cliff_patch([Vector2(1093, 411), Vector2(1167, 413), Vector2(1221, 401), Vector2(1250, 367),
		Vector2(1320, 335), cliff[9], cliff[10], cliff[11], cliff[12]], Color("#695b5d"))
	_cliff_patch([Vector2(1167, 413), Vector2(1221, 401), Vector2(1261, 419),
		Vector2(1233, 458), cliff[11]], Color("#90796d"))
	_cliff_patch([Vector2(1250, 367), Vector2(1320, 335), cliff[9], cliff[10],
		Vector2(1256, 458), Vector2(1261, 419)], Color("#7b6a66"))
	_draw_gradient_band(turf_bottom, ledge_lower, 0.0, 1.0, Color("#d1ac7b"), Color("#a98368"))
	_draw_gradient_band(grass, turf_bottom, 0.0, 1.0, Color("#bedf64"), Color("#4d914e"))
	draw_polyline(grass, Color("#648c43"), 2.6, true)
	draw_polyline(turf_bottom, Color("#4b7847"), 1.8, true)
	for i in range(7):
		var x := 1034.0 + i * 23.0
		var depth := 8.0 + sin(x * 0.12) * 2.0
		draw_circle(Vector2(x, 373.0 + depth - 0.5), 3.0, Color("#669d4b"), true, -1.0, true)
	draw_polyline(PackedVector2Array([Vector2(1043, 399), Vector2(1062, 397), Vector2(1079, 405),
		Vector2(1103, 405)]), Color("#d9b58e"), 2.1, true)
	draw_polyline(PackedVector2Array([Vector2(1130, 424), Vector2(1167, 426), Vector2(1184, 417)]),
		Color("#b5947e"), 2.0, true)
	_draw_soil_pebble(Vector2(1149, 403), 1.05, Color("#b2957d"))
	_draw_soil_pebble(Vector2(1214, 425), 1.35, Color("#927867"))
	# La végétation est implantée sur la pente, au-delà de la zone d’atterrissage.
	_draw_bush(1268, 271.0, 0.58)
	_draw_fern(Vector2(1238, 319), 0.30)
	_draw_flower(1252, 293, Color("#fff0c8"))


func _draw_canopy_valley() -> void:
	var ridge := PackedVector2Array()
	var foot := PackedVector2Array()
	for i in range(83):
		var x := -30.0 + 17.0 * i
		var y := 521.0 + 31.0 * sin(x * 0.005 - 1.4) + 11.0 * sin(x * 0.012 + 2.4)
		ridge.append(Vector2(x, y))
		foot.append(Vector2(x, 690.0))
	_draw_gradient_band(ridge, foot, 0.0, 1.0, Color("#8cc18b"), Color("#4b9977"))
	for i in range(18):
		var x := 27.0 + 74.0 * i + (i * 7 % 23)
		var y := 540.0 + 31.0 * sin(x * 0.005 - 1.4) + 11.0 * sin(x * 0.012 + 2.4)
		var size := 0.15 + (i * 13 % 11) * 0.021
		_forest_silhouette(Vector2(x, y), size, Color("#61a57e"), Color("#80b788"))


func _draw_canopy_banks() -> void:
	for x: float in [19.0, 394.0, 552.0, 673.0, 986.0, 1199.0, 1258.0]:
		var y := _ground_height(x)
		var sway := sin(animation_time * 1.6 + x) * 1.9
		for j in range(3):
			var root := Vector2(x + (j - 1) * 5.5, y + 2)
			var blade := PackedVector2Array([root + Vector2(-3, 0),
				root + Vector2((j - 1) * 6 + sway, -9.0 - j * 2.8), root + Vector2(3, 0)])
			draw_colored_polygon(blade, Color("#509450").lerp(Color("#9bc55b"), j * 0.34))
	for x: float in [156.0, 578.0, 991.0, 1178.0]:
		_draw_flower(x, _ground_height(x) + 2.0, Color("#fff0bd"))


func _draw_wind_streaks() -> void:
	var direction := float(signi(wind))
	var strength := float(absi(wind))
	var span := course_width + 140.0
	var drift := animation_time * (35.0 + strength * 22.0) * direction
	for i in range(12):
		var x := fposmod(float(i) * 151.0 + drift, span) - 70.0
		var y := 163.0 + float((i * 47) % 248) + sin(animation_time * 1.2 + i) * 5.0
		var fade := smoothstep(-45.0, 65.0, x) * (1.0 - smoothstep(course_width - 50.0, course_width + 30.0, x))
		var start := Vector2(x, y)
		var length := (23.0 + float(i % 3) * 9.0 + strength * 4.0) * direction
		var curve := PackedVector2Array([start, start + Vector2(length * 0.28, -3.0),
			start + Vector2(length * 0.7, -4.0), start + Vector2(length, -2.0)])
		draw_polyline(curve, Color("#fffdeb", fade * 0.57), 1.6, true)
		if i % 3 == 0:
			var leaf := start + Vector2(length * 0.56, -7.0)
			_draw_fern_leaf(leaf, leaf + Vector2(direction * 9.0, -3.0), 2.1, Color("#e4c371", fade * 0.9))


func _draw_perched_background() -> void:
	for layer in range(2):
		var edge := PackedVector2Array()
		var lower := PackedVector2Array()
		for i in range(91):
			var x := -35.0 + float(i) * 15.0
			var y := _perched_hill_y(x, layer)
			edge.append(Vector2(x, y))
			lower.append(Vector2(x, 765.0))
		var light := Color("#aac7aa") if layer == 0 else Color("#8ab69a")
		var dark := Color("#7fa997") if layer == 0 else Color("#609e81")
		_draw_gradient_band(edge, lower, 0.0, 1.0, light, dark)
		draw_polyline(edge, light.lightened(0.07), 1.5, true)
		var count := 17 if layer == 0 else 12
		for i in range(count):
			var x := float(i) * (83.0 if layer == 0 else 118.0) - 10.0 + float((i * 19) % 24)
			var size := 0.23 + float((i * 7 + layer * 3) % 8) * 0.027
			var color := dark.lightened(0.08)
			_forest_silhouette(Vector2(x, _perched_hill_y(x, layer) + 13.0), size, color, color.lightened(0.12))


func _perched_hill_y(x: float, layer: int) -> float:
	return 473.0 + float(layer) * 88.0 + sin(x * 0.007 + layer * 1.8) * 26.0 		+ sin(x * 0.015 - layer) * 6.0


func _draw_relay_rock() -> void:
	var edge := rock_collision.polygon
	# Le pilier s'enfonce dans le ravin sous la face jouable.
	var pillar := PackedVector2Array([Vector2(792, 530), Vector2(924, 536),
		Vector2(908, 626), Vector2(896, 742), Vector2(831, 742), Vector2(812, 631)])
	draw_colored_polygon(pillar, Color("#719082"))
	_cliff_patch([Vector2(868, 554), Vector2(920, 548), Vector2(908, 626),
		Vector2(896, 742), Vector2(866, 742), Vector2(876, 635)], Color("#607e74"))
	draw_colored_polygon(edge, Color("#879e91"))
	_cliff_patch([edge[0], edge[1], edge[2], edge[3], edge[4], Vector2(876, 518),
		Vector2(789, 489)], Color("#b4c6ae"))
	_cliff_patch([Vector2(789, 489), Vector2(876, 518), edge[4], edge[5], edge[6],
		Vector2(856, 557)], Color("#647e76"))
	_cliff_patch([edge[1], edge[2], edge[3], Vector2(911, 514), Vector2(842, 488),
		Vector2(783, 475)], Color("#92b17d"))
	draw_polyline(PackedVector2Array([edge[1], edge[2], edge[3]]), Color("#dce2bc"), 2.2, true)
	var outline := edge.duplicate()
	outline.append(edge[0])
	draw_polyline(outline, Color("#567469"), 2.1, true)
	_draw_fern(Vector2(866, 489), 0.29)


func _draw_cliff_background() -> void:
	var left := PackedVector2Array([Vector2(-55, 217), Vector2(35, 201), Vector2(104, 166),
		Vector2(246, 157), Vector2(352, 190), Vector2(385, 220), Vector2(437, 227),
		Vector2(462, 297), Vector2(503, 330), Vector2(491, 374), Vector2(533, 415),
		Vector2(558, 499), Vector2(527, 607), Vector2(-55, 614)])
	var right := PackedVector2Array([Vector2(742, 582), Vector2(737, 473), Vector2(771, 437),
		Vector2(784, 371), Vector2(836, 332), Vector2(836, 273), Vector2(899, 250),
		Vector2(935, 218), Vector2(1035, 202), Vector2(1088, 160), Vector2(1210, 157),
		Vector2(1310, 180), Vector2(1340, 605)])
	draw_colored_polygon(left, Color("#aabca8"))
	draw_colored_polygon(right, Color("#b3c2ac"))
	_cliff_patch([Vector2(-36, 247), Vector2(105, 189), Vector2(235, 177), Vector2(300, 192),
		Vector2(279, 326), Vector2(216, 448), Vector2(201, 573), Vector2(-36, 586)], Color("#c7d1ba"))
	_cliff_patch([Vector2(352, 208), Vector2(409, 242), Vector2(434, 315), Vector2(478, 347),
		Vector2(471, 385), Vector2(508, 435), Vector2(531, 516), Vector2(495, 587),
		Vector2(353, 587), Vector2(355, 458), Vector2(381, 369)], Color("#94aa98"))
	_cliff_patch([Vector2(864, 309), Vector2(912, 273), Vector2(1001, 243), Vector2(1098, 180),
		Vector2(1208, 175), Vector2(1288, 197), Vector2(1300, 477), Vector2(1060, 525),
		Vector2(985, 428), Vector2(953, 351)], Color("#ced6bc"))
	_cliff_patch([Vector2(797, 449), Vector2(808, 391), Vector2(852, 348), Vector2(879, 370),
		Vector2(923, 389), Vector2(948, 460), Vector2(990, 530), Vector2(976, 580), Vector2(768, 580)], Color("#93aa96"))
	_cliff_patch([Vector2(-40, 214), Vector2(35, 201), Vector2(104, 166), Vector2(246, 157),
		Vector2(352, 190), Vector2(385, 220), Vector2(324, 207), Vector2(230, 178),
		Vector2(110, 189), Vector2(49, 218), Vector2(-40, 234)], Color("#82a87b"))
	_cliff_patch([Vector2(900, 251), Vector2(935, 218), Vector2(1035, 202), Vector2(1088, 160),
		Vector2(1210, 157), Vector2(1309, 180), Vector2(1310, 195), Vector2(1208, 175),
		Vector2(1097, 182), Vector2(1040, 223), Vector2(951, 238)], Color("#88a97d"))
	_cliff_patch([Vector2(68, 359), Vector2(172, 344), Vector2(229, 355), Vector2(200, 372),
		Vector2(121, 379), Vector2(79, 373)], Color("#8cab80"))
	_cliff_patch([Vector2(989, 332), Vector2(1091, 312), Vector2(1169, 318), Vector2(1148, 335),
		Vector2(1078, 340), Vector2(1013, 344)], Color("#8baa7c"))
	for site: Vector3 in [Vector3(104, 370, 70), Vector3(149, 371, 78), Vector3(195, 365, 50),
		Vector3(1029, 336, 75), Vector3(1081, 331, 84), Vector3(1130, 329, 58)]:
		_draw_cliff_ivy(Vector2(site.x, site.y), site.z, site.x * 0.034)
	for shelf: Vector3 in [Vector3(111, 364, 0.74), Vector3(164, 356, 0.88), Vector3(200, 358, 0.60),
		Vector3(1035, 333, 0.64), Vector3(1091, 322, 0.87), Vector3(1135, 324, 0.70)]:
		_draw_fern(Vector2(shelf.x, shelf.y), shelf.z)

	draw_polyline(left, Color("#7b9986", 0.73), 2.2, true)
	draw_polyline(right, Color("#849d89", 0.73), 2.2, true)
	var valley := PackedVector2Array()
	for i in range(91):
		var x := -36.0 + float(i) * 15.0
		valley.append(Vector2(x, 467.0 + sin(x * 0.007 + 1.28) * 21.0))
	valley.append(Vector2(1314, 750))
	valley.append(Vector2(-36, 750))
	draw_colored_polygon(valley, Color("#80ad83"))


func _cliff_patch(points: Array[Vector2], color: Color) -> void:
	draw_colored_polygon(PackedVector2Array(points), color)


func _draw_cliff_ivy(root: Vector2, length: float, phase: float) -> void:
	var stem := PackedVector2Array()
	for i in range(19):
		var t := float(i) / 18.0
		var bend := sin(t * 5.8 + phase + animation_time * 0.66) * 6.0 * t
		var point := root + Vector2(bend + 10.0 * t, length * t)
		stem.append(point)
		if i > 1 and i % 2 == 0:
			var side := -1.0 if i % 4 == 0 else 1.0
			var tip := point + Vector2(side * (12.0 - t * 5.0), 5.0)
			var tint := Color("#81ae72") if side < 0.0 else Color("#699860")
			_draw_fern_leaf(point, tip, 4.0 - t * 1.8, tint)
	draw_polyline(stem, Color("#527958"), 1.6, true)


func _draw_fern(base: Vector2, scale: float) -> void:
	var sway := sin(animation_time * 1.16 + base.x * 0.027) * 3.0
	# Les frondes latérales se chevauchent sous les frondes plus claires.
	_draw_fern_frond(base, Vector2(-47, -22), scale, sway, Color("#5e9958"), Color("#81b56b"))
	_draw_fern_frond(base, Vector2(46, -24), scale, sway, Color("#568d56"), Color("#7caf67"))
	_draw_fern_frond(base, Vector2(-31, -46), scale, sway, Color("#70a95c"), Color("#91c779"))
	_draw_fern_frond(base, Vector2(34, -43), scale, sway, Color("#69a25c"), Color("#8dc17a"))
	_draw_fern_frond(base, Vector2(3, -59), scale, sway, Color("#85b968"), Color("#a0ce84"))


func _draw_fern_frond(base: Vector2, reach: Vector2, scale: float, sway: float,
		fill: Color, light: Color) -> void:
	var upper := PackedVector2Array()
	var lower := PackedVector2Array()
	var vein := PackedVector2Array()
	var arch := absf(reach.x) * 0.35
	for i in range(37):
		var t := float(i) / 36.0
		var center := base + (reach * t + Vector2(sway * t * t, -sin(t * PI) * arch)) * scale
		var normal := Vector2(-reach.y, reach.x).normalized()
		# Quatre lobes larges donnent une silhouette de fougère lisible à petite taille.
		var lobes := 0.88 + 0.12 * cos((t * 3.5 - 0.45) * TAU)
		var width := pow(maxf(0.0, sin(t * PI)), 0.65) * (13.0 - 4.3 * t) * lobes * scale
		upper.append(center - normal * width)
		if i > 0 and i < 36:
			lower.append(center + normal * width * 0.84)
		if i >= 4 and i <= 31:
			vein.append(center)
	var outline := upper.duplicate()
	for i in range(lower.size() - 1, -1, -1):
		outline.append(lower[i])
	draw_colored_polygon(outline, fill)

	var highlight := PackedVector2Array()
	for i in range(7, 28):
		var opposite := lower[i - 1]
		highlight.append(upper[i].lerp(opposite, 0.23))
	for i in range(27, 6, -1):
		highlight.append(upper[i].lerp(lower[i - 1], 0.43))
	draw_colored_polygon(highlight, light)
	draw_polyline(vein, Color("#53804f", 0.71), maxf(0.8, 1.35 * scale), true)
	outline.append(outline[0])
	draw_polyline(outline, Color("#3c704e"), maxf(1.0, 1.85 * scale), true)


func _draw_fern_leaf(base: Vector2, tip: Vector2, width: float, tint: Color) -> void:
	var delta := tip - base
	var side := Vector2(-delta.y, delta.x).normalized() * width
	var center := base + delta * 0.49
	draw_colored_polygon(PackedVector2Array([base, center + side, tip, center - side * 0.74]), tint)
	draw_line(base, tip, tint.darkened(0.14), maxf(0.65, width * 0.22), true)


func _draw_cliff_boulder(edge: PackedVector2Array) -> void:
	var ridge := Vector2(548, 475)
	var seam := Vector2(596, 507)
	draw_colored_polygon(edge, Color("#84998c"))
	_cliff_patch([edge[0], edge[1], edge[2], edge[3], ridge, Vector2(499, 493)], Color("#c0cbb7"))
	_cliff_patch([edge[3], edge[4], edge[5], edge[6], Vector2(582, 539), seam, ridge], Color("#6c8578"))
	_cliff_patch([edge[0], Vector2(499, 493), ridge, seam, Vector2(582, 539), edge[7]], Color("#97ada0"))
	draw_polyline(PackedVector2Array([edge[1], edge[2], edge[3], edge[4]]), Color("#d2d9c1"), 2.0, true)
	draw_polyline(PackedVector2Array([Vector2(530, 505), Vector2(548, 510),
		Vector2(555, 523)]), Color("#637e72", 0.64), 1.55, true)
	var outline := edge.duplicate()
	outline.append(edge[0])
	draw_polyline(outline, Color("#637e72"), 1.45, true)


func _draw_cliff_ferns() -> void:
	for plant: Vector2 in [Vector2(0.10, 0.72), Vector2(0.25, 0.67), Vector2(0.36, 0.54),
		Vector2(0.67, 0.75), Vector2(0.79, 0.61), Vector2(0.94, 0.74)]:
		var x := plant.x * course_width
		if not _under_forest_obstacle(x, 44.0):
			_draw_fern(Vector2(x, _ground_height(x) + 1.0), plant.y)


func _draw_cliff_slab(edge: PackedVector2Array) -> void:
	draw_colored_polygon(edge, Color("#788e82"))
	_cliff_patch([edge[0], edge[1], edge[2], edge[3], Vector2(948, 517), Vector2(837, 531)], Color("#b3c2ac"))
	_cliff_patch([edge[3], edge[4], edge[5], Vector2(857, 535), Vector2(948, 517)], Color("#637d71"))
	draw_polyline(PackedVector2Array([edge[0], edge[1], edge[2]]), Color("#d0d9bf"), 2.1, true)


func _draw_ridge_background() -> void:
	for layer in range(2):
		var edge := PackedVector2Array()
		for i in range(121):
			var x := -28.0 + float(i) * 12.0
			var y := _ridge_hill_height(x, layer)
			edge.append(Vector2(x, y))
		var hill := edge.duplicate()
		hill.append(Vector2(edge[-1].x, 750))
		hill.append(Vector2(edge[0].x, 750))
		var color := Color("#8ec89f") if layer == 0 else Color("#74b68c")
		draw_colored_polygon(hill, color)
		draw_polyline(edge, color.lightened(0.12), 1.35, true)
		for x: float in ([70.0, 111.0, 408.0, 464.0, 748.0, 1139.0, 1183.0] if layer == 0
				else [211.0, 282.0, 606.0, 657.0, 977.0, 1018.0, 1243.0]):
			var base := Vector2(x, _ridge_hill_height(x, layer) + 11.0)
			var size := 0.22 + 0.035 * sin(x * 0.03)
			var needles := Color("#70ac8b") if layer == 0 else Color("#5f9d7c")
			_forest_silhouette(base, size, needles, needles.lightened(0.12))


func _ridge_hill_height(x: float, layer: int) -> float:
	var phase := float(layer) * 1.6
	return 418.0 + float(layer) * 61.0 + sin(x * 0.008 + phase) * 25.0 + sin(x * 0.017 - phase) * 4.0


func _orchard_hill(x: float, near: bool) -> float:
	if near:
		return 490.0 + sin(x * 0.0084 + 1.42) * 28.0 + sin(x * 0.018) * 3.0
	return 422.0 + sin(x * 0.0051 - 0.9) * 24.0


func _draw_orchard() -> void:
	_draw_orchard_row(false, Color("#a5cda0"), 13, 105.0)
	_draw_orchard_row(true, Color("#85b884"), 8, 175.0)


func _draw_orchard_row(near: bool, tint: Color, count: int, spacing: float) -> void:
	var edge := PackedVector2Array()
	for i in range(93):
		var x := -44.0 + i * 15.0
		edge.append(Vector2(x, _orchard_hill(x, near)))
	var fill := edge.duplicate()
	fill.append(Vector2(edge[-1].x, 752.0))
	fill.append(Vector2(edge[0].x, 752.0))
	draw_colored_polygon(fill, tint)
	draw_polyline(edge, tint.lightened(0.10), 1.4, true)
	for i in range(count):
		var x := 15.0 + i * spacing + float((i * 23) % 30)
		var size := (0.36 if near else 0.23) + float((i * 11) % 7) * 0.021
		_draw_apple_tree(Vector2(x, _orchard_hill(x, near) + 12.0), size, true)


func _draw_apple_tree(base: Vector2, size: float, distant := false) -> void:
	var sway := sin(animation_time * 0.96 + base.x * 0.017) * 3.4 * size
	var crown := base + Vector2(sway, -78.0 * size)
	var shadow := PackedVector2Array()
	for i in range(24):
		var angle := float(i) * TAU / 24.0
		shadow.append(base + Vector2(cos(angle) * 39.0, sin(angle) * 5.5 - 1.0) * size)
	draw_colored_polygon(shadow, Color("#335d4a", 0.20))
	var bark := Color("#8f845b") if distant else Color("#7e6145")
	draw_line(base + Vector2(0, 2) * size, crown, bark, 12.0 * size, true)
	draw_line(base + Vector2(-2.3, -3.0) * size, crown + Vector2(-2.3, 3.0) * size,
		bark.lightened(0.19), 3.0 * size, true)
	var deep := Color("#78a876") if distant else Color("#3e855d")
	var mid := Color("#8cb67e") if distant else Color("#59a46d")
	var light := Color("#9ac186") if distant else Color("#70b878")
	var canopy := PackedVector2Array()
	for i in range(54):
		var angle := float(i) * TAU / 54.0
		var lobe := 1.0 + 0.08 * cos(angle * 5.0 + 0.8) + 0.027 * sin(angle * 3.0)
		canopy.append(crown + Vector2(cos(angle) * 53.0, sin(angle) * 41.0) * size * lobe)
	draw_colored_polygon(canopy, mid)
	var edge := canopy.duplicate()
	edge.append(edge[0])
	draw_polyline(edge, deep, 1.35, true)
	draw_circle(crown + Vector2(-12.0, -12.0) * size, 27.0 * size, light, true, -1.0, true)
	if distant:
		return
	for apple: Vector2 in [Vector2(-25, 6), Vector2(16, -21), Vector2(28, 12)]:
		var center := crown + apple * size
		draw_circle(center + Vector2(0, 1.6) * size, 5.2 * size, Color("#a95247"), true, -1.0, true)
		draw_circle(center, 4.3 * size, Color("#e88c65"), true, -1.0, true)
		draw_circle(center + Vector2(-1.2, -1.5) * size, 1.3 * size, Color("#ffd3a2"), true, -1.0, true)


func _draw_forest_background() -> void:
	_draw_forest_row(false, Color("#a9cfaa"), Color("#83b698"), Color("#96c2a0"), 27, 54.0)
	_draw_forest_row(true, Color("#79ae85"), Color("#508d72"), Color("#609c7b"), 15, 94.0)


func _draw_forest_row(near: bool, hill: Color, needles: Color, lit_needles: Color,
		count: int, spacing: float) -> void:
	var ridge := PackedVector2Array()
	for i in range(94):
		var x := -56.0 + i * 15.0
		ridge.append(Vector2(x, _forest_hill(x, near)))
	var bank := ridge.duplicate()
	bank.append(Vector2(ridge[-1].x, 760.0))
	bank.append(Vector2(ridge[0].x, 760.0))
	draw_colored_polygon(bank, hill)
	draw_polyline(ridge, hill.lightened(0.07), 1.25, true)

	for i in range(count):
		var x := -45.0 + i * spacing + float((i * 17) % 21)
		var size := (0.50 if near else 0.28) + float((i * 7 + 2) % 9) * 0.037
		_forest_silhouette(Vector2(x, _forest_hill(x, near) + 10.0), size, needles, lit_needles)


func _forest_hill(x: float, near: bool) -> float:
	if near:
		return 475.0 + sin(x * 0.0075 + 1.4) * 17.0 + sin(x * 0.017) * 3.0
	return 411.0 + sin(x * 0.006 - 0.8) * 23.0


func _forest_silhouette(base: Vector2, size: float, needles: Color, lit_needles: Color) -> void:
	draw_rect(Rect2(base + Vector2(-6.0, -34.0) * size, Vector2(12.0, 34.0) * size),
		needles.darkened(0.11))
	_draw_pine_canopy(base, size, needles, lit_needles)


func _draw_pine_canopy(base: Vector2, size: float, needles: Color, lit_needles: Color,
		sway: float = 0.0) -> void:
	var shape := PackedVector2Array([Vector2(0, -143), Vector2(12, -119), Vector2(30, -98),
		Vector2(27, -94), Vector2(17, -95), Vector2(25, -79), Vector2(42, -59), Vector2(39, -54),
		Vector2(25, -57), Vector2(34, -41), Vector2(50, -24), Vector2(47, -19),
		Vector2(16, -21), Vector2(6, -24), Vector2(-6, -24), Vector2(-16, -21),
		Vector2(-47, -19), Vector2(-50, -24), Vector2(-34, -41), Vector2(-25, -57),
		Vector2(-39, -54), Vector2(-42, -59), Vector2(-25, -79), Vector2(-17, -95),
		Vector2(-27, -94), Vector2(-30, -98), Vector2(-12, -119)])
	for i in range(shape.size()):
		var point := shape[i]
		shape[i] = base + point * size + Vector2(sway * (-point.y / 143.0), 0.0)
	var rounded := PackedVector2Array()
	var lit := PackedVector2Array([shape[0] + Vector2(0.0, 4.0) * size,
		base + Vector2(-2.0 * size + sway * 0.62, -88.0 * size),
		base + Vector2(-7.0 * size + sway * 0.40, -58.0 * size), shape[14]])
	for i in range(shape.size()):
		var corner := shape[i]
		var previous := shape[posmod(i - 1, shape.size())]
		var following := shape[(i + 1) % shape.size()]
		var before := corner.move_toward(previous, minf(4.0 * size, corner.distance_to(previous) * 0.32))
		var after := corner.move_toward(following, minf(4.0 * size, corner.distance_to(following) * 0.32))
		for step in range(4):
			var t := float(step) / 3.0
			var point := before.lerp(corner, t).lerp(corner.lerp(after, t), t)
			rounded.append(point)
			if i >= 15:
				lit.append(point)
	draw_colored_polygon(rounded, needles)
	draw_colored_polygon(lit, lit_needles)
	rounded.append(rounded[0])
	draw_polyline(rounded, needles, 1.0, true)


func _draw_forest_obstacle() -> void:
	if hole.has("rock"):
		_draw_forest_rock(rock_collision.polygon)
	elif hole.has("tunnel"):
		_draw_hollow_log(hole["tunnel"])


func _draw_forest_rock(outline: PackedVector2Array) -> void:
	var left := outline[0]
	var crest := outline[2]
	var shoulder := outline[3]
	var foot := outline[4]
	var base := outline[5]
	var heel := outline[6]
	var seam := Vector2(585, 535)
	var corner := Vector2(617, 518)
	draw_colored_polygon(outline, Color("#687d77"))
	draw_colored_polygon(PackedVector2Array([left, outline[1], crest, shoulder,
		corner, Vector2(558, 528), Vector2(509, 535)]), Color("#aec1b6"))
	draw_colored_polygon(PackedVector2Array([left, Vector2(509, 535), Vector2(558, 528),
		corner, seam, Vector2(554, 545), heel]), Color("#8da49a"))
	draw_colored_polygon(PackedVector2Array([shoulder, foot, base, Vector2(587, 553),
		seam, corner]), Color("#536b65"))
	draw_colored_polygon(PackedVector2Array([Vector2(558, 528), Vector2(572, 525),
		Vector2(585, 527), Vector2(580, 532), Vector2(565, 534)]), Color("#bacac0"))
	draw_polyline(PackedVector2Array([Vector2(606, 533), Vector2(620, 536),
		Vector2(626, 544)]), Color("#435c58", 0.65), 1.5, true)
	var edge := outline.duplicate()
	edge.append(left)
	draw_polyline(edge, Color("#4e665e"), 2.0, true)


func _draw_hollow_log(roof: Rect2) -> void:
	var left := roof.position.x
	var right := roof.end.x
	var top := roof.position.y
	var opening := roof.end.y
	var floor_y := _ground_height((left + right) * 0.5)
	# Le fond sombre rend le passage visible. La voûte utilise le contour de collision.
	var cavity := PackedVector2Array([Vector2(left + 1, opening - 2), Vector2(right - 1, opening - 2),
		Vector2(right - 1, floor_y), Vector2(left + 1, floor_y)])
	draw_polygon(cavity, PackedColorArray([Color("#463f33"), Color("#463f33"),
		Color("#795c42"), Color("#795c42")]))
	draw_rect(Rect2(left + 3, floor_y - 4, roof.size.x - 6.0, 4.0), Color("#a17b54"))

	var bark := _tunnel_outline(roof)
	draw_colored_polygon(bark, Color("#9c6948"))
	draw_colored_polygon(PackedVector2Array([bark[1], bark[2], bark[3], bark[4], bark[5],
		Vector2(right - 15, top - 1), Vector2(left + 141, top - 8),
		Vector2(left + 65, top - 5), Vector2(left + 8, top)]), Color("#c38d60"))
	draw_colored_polygon(PackedVector2Array([Vector2(left + 7, opening - 9),
		Vector2(left + 88, opening - 12), Vector2(right - 9, opening - 8),
		bark[6], bark[0]]), Color("#785037"))
	draw_polyline(PackedVector2Array([Vector2(left + 22, top - 4), Vector2(left + 74, top - 8),
		Vector2(left + 112, top - 7)]), Color("#e0ad79"), 2.3, true)
	draw_polyline(PackedVector2Array([Vector2(left + 25, top + 8), Vector2(left + 70, top + 5),
		Vector2(left + 107, top + 8), Vector2(left + 124, top + 7)]), Color("#704b36"), 2.0, true)
	draw_polyline(PackedVector2Array([Vector2(left + 150, top + 5), Vector2(right - 40, top + 2),
		Vector2(right - 25, top + 4)]), Color("#704b36"), 2.0, true)

	var knot := Vector2(left + 138.0, top + 5.0)
	draw_set_transform(knot, -0.12, Vector2(1.85, 0.70))
	draw_circle(Vector2.ZERO, 6.0, Color("#704b36"), true, -1.0, true)
	draw_circle(Vector2.ZERO, 3.4, Color("#c99163"), true, -1.0, true)
	draw_set_transform(Vector2.ZERO)

	# Les arcs de bois de bout restent à l’intérieur des extrémités de l’écorce.
	for x: float in [left + 12.0, right - 11.0]:
		var cut := Vector2(x, top + 3.0)
		draw_set_transform(cut, -0.15, Vector2(0.80, 1.25))
		draw_circle(Vector2.ZERO, 10.5, Color("#e3b483"), true, -1.0, true)
		draw_arc(Vector2.ZERO, 7.0, -1.25, 4.60, 26, Color("#a7714f"), 1.25, true)
		draw_arc(Vector2.ZERO, 3.8, -1.0, 4.7, 22, Color("#a7714f"), 1.0, true)
		draw_set_transform(Vector2.ZERO)


func _tunnel_outline(roof: Rect2) -> PackedVector2Array:
	var left := roof.position.x
	var right := roof.end.x
	var top := roof.position.y
	return PackedVector2Array([Vector2(left - 7.0, roof.end.y),
		Vector2(left, top - 13.0), Vector2(left + 67.0, top - 17.0),
		Vector2(left + 138.0, top - 20.0), Vector2(right - 35.0, top - 15.0),
		Vector2(right + 7.0, top - 5.0), Vector2(right + 8.0, roof.end.y)])


func _rustle_tunnel(from: Vector2, to: Vector2) -> void:
	if tunnel_rustled or not hole.has("tunnel"):
		return
	var roof: Rect2 = hole["tunnel"]
	var inside := Rect2(Vector2(roof.position.x + 17.0, roof.end.y + BALL_RADIUS - 2.0),
		Vector2(roof.size.x - 34.0, 31.0))
	if not inside.has_point(from) and not inside.has_point(to):
		return
	tunnel_rustled = true
	var edge_x := roof.end.x - 16.0 if to.x >= from.x else roof.position.x + 16.0
	for i in range(6):
		var position := Vector2(edge_x + rng.randf_range(-13.0, 13.0), roof.position.y - 12.0)
		var velocity := Vector2(rng.randf_range(-31.0, 32.0), rng.randf_range(-35.0, -10.0))
		_add_particle(position, velocity, Color("#acc671"), rng.randf_range(0.53, 0.91), 3.3, 96.0)


func _draw_sky() -> void:
	var box := PackedVector2Array([Vector2(-80, -10), Vector2(1450, -10),
		Vector2(1450, 760), Vector2(-80, 760)])
	var blue := Color("#71bee8")
	var haze := Color("#d9efe1")
	draw_polygon(box, PackedColorArray([blue, blue, haze, haze]))


func _draw_sun() -> void:
	var center := Vector2(1050, 144)
	draw_circle(center, 91.0, Color("#fff7c7", 0.17), true, -1.0, true)
	draw_circle(center, 72.0, Color("#fff4b6", 0.24), true, -1.0, true)
	draw_circle(center, 53.0, Color("#ebd89b"), true, -1.0, true)
	draw_circle(center - Vector2(0, 2), 51.0, Color("#fff1b7"), true, -1.0, true)
	draw_arc(center, 44.0, PI * 1.02, PI * 1.56, 24, Color("#fffad7"), 2.4, true)


func _draw_cloud(center: Vector2, scale: float) -> void:
	# Une seule silhouette adoucit les jonctions entre les volumes du nuage.
	var crest := PackedVector2Array()
	var base := PackedVector2Array()
	var profile := PackedFloat32Array([0.0, 12.0, 22.0, 23.0, 28.0, 44.0,
		49.0, 43.0, 32.0, 34.0, 29.0, 20.0, 0.0])
	for i in range(61):
		var t := float(i) / 60.0
		var x := -72.0 + 144.0 * t
		var section := mini(floori(float(i) / 5.0), 11)
		var fraction := (float(i) - float(section * 5)) / 5.0
		var height := lerpf(profile[section], profile[section + 1], smoothstep(0.0, 1.0, fraction))
		var taper := pow(maxf(0.0, sin(t * PI)), 0.44)
		crest.append(center + Vector2(x, -height) * scale)
		base.append(center + Vector2(x, taper * 13.0) * scale)
	_draw_gradient_band(crest, base, 0.0, 1.0, Color("#fffdf1"), Color("#e0f1ed"))
	_draw_gradient_band(crest, base, 0.75, 1.0, Color("#d4e9e8", 0.15), Color("#bddfe5", 0.62))
	var rim := crest.duplicate()
	for i in range(base.size() - 2, 0, -1):
		rim.append(base[i])
	rim.append(rim[0])
	draw_polyline(rim, Color("#a9d0dd", 0.86), maxf(0.95, 1.7 * scale), true)


func _draw_clouds() -> void:
	var a = fposmod(
		195.0 + animation_time * 10.0 + 140.0,
		1550.0
	) - 140.0

	var b = fposmod(
		616.0 + animation_time * 16.0 + 140.0,
		1550.0
	) - 140.0

	var c = fposmod(
		903.0 + animation_time * 7.0 + 140.0,
		1550.0
	) - 140.0

	_draw_cloud(
		Vector2(a, 138 + sin(animation_time * 0.5) * 3),
		0.90
	)
	_draw_cloud(
		Vector2(b, 100 + sin(animation_time * 0.35 + 1.0) * 4),
		0.65
	)
	_draw_cloud(
		Vector2(c, 248 + sin(animation_time * 0.42 + 2.0) * 3),
		0.55
	)


# -----------------------------------
# MONTAGNES ET COLLINES
# -----------------------------------

func _draw_mountains() -> void:
	_draw_mountain(Vector2(155, 242), Vector2(286, 271), Color("#accdbd"), Color("#92b7a9"), true)
	_draw_mountain(Vector2(1166, 279), Vector2(317, 248), Color("#b3d3bd"), Color("#9cbfb0"), false)
	_draw_mountain(Vector2(633, 176), Vector2(367, 346), Color("#9ac1b1"), Color("#7baa9b"), true)


func _draw_mountain(peak: Vector2, size: Vector2, lit: Color, shade: Color, snowy: bool) -> void:
	var unit_outline := [Vector2(-1.03, 1.0), Vector2(-0.78, 0.76), Vector2(-0.51, 0.48),
		Vector2(-0.27, 0.25), Vector2(-0.07, 0.044), Vector2(-0.025, 0.009),
		Vector2(0.011, 0), Vector2(0.055, 0.022), Vector2(0.15, 0.12),
		Vector2(0.36, 0.32), Vector2(0.61, 0.54), Vector2(0.80, 0.79), Vector2(1.06, 1.0)]
	var outline := PackedVector2Array()
	for point: Vector2 in unit_outline:
		outline.append(peak + point * size)
	draw_colored_polygon(outline, lit)
	var facet := PackedVector2Array()
	for i in range(6, outline.size()):
		facet.append(outline[i])
	facet.append(peak + Vector2(0.02, 1.0) * size)
	facet.append(peak + Vector2(0.12, 0.59) * size)
	facet.append(peak + Vector2(-0.065, 0.29) * size)
	draw_colored_polygon(facet, shade)
	if snowy:
		var snow := PackedVector2Array([outline[3], outline[4], outline[5], outline[6],
			outline[7], outline[8], outline[9], peak + Vector2(0.16, 0.25) * size,
			peak + Vector2(0.10, 0.29) * size, peak + Vector2(-0.045, 0.23) * size,
			peak + Vector2(-0.15, 0.30) * size])
		draw_colored_polygon(snow, Color("#e6efe0"))
	draw_polyline(outline, shade.darkened(0.07), 1.7, true)


func _draw_valley_details() -> void:
	# Une lisière basse laisse la vallée ouverte et reprend les contours des sapins du niveau 3.
	for x: float in [40.0, 104.0, 126.0, 343.0, 377.0, 540.0, 779.0, 805.0, 987.0, 1150.0, 1179.0]:
		var y := 443.0 + sin(x * 0.008 + animation_time * 0.025) * 32.0 + 12.0
		var size := 0.19 + 0.04 * (1.0 + sin(x * 0.035))
		_forest_silhouette(Vector2(x, y), size, Color("#6cad8c"), Color("#80b899"))
	var contour := PackedVector2Array()
	for i in range(61):
		var x := -30.0 + float(i) * 23.0
		var y := 494.0 + sin(x * 0.011 + 1.8 + animation_time * 0.013) * 23.0
		contour.append(Vector2(x, y + 1.0))
	draw_polyline(contour, Color("#8cca97"), 2.0, true)


func _draw_distant_hills() -> void:
	var back_hill = PackedVector2Array([
		Vector2(-80, 720)
	])

	for i in range(62):
		var x = -80.0 + float(i) * 24.0
		var y = 443.0 + sin(
			x * 0.008 + animation_time * 0.025
		) * 32.0

		back_hill.append(Vector2(x, y))

	back_hill.append(Vector2(1400, 720))
	draw_colored_polygon(
		back_hill, Color("#7fc8a0")
	)

	var front_hill = PackedVector2Array([
		Vector2(-80, 720)
	])

	for i in range(62):
		var x = -80.0 + float(i) * 24.0
		var y = 494.0 + sin(
			x * 0.011 + 1.8 + animation_time * 0.013
		) * 23.0

		front_hill.append(Vector2(x, y))

	front_hill.append(Vector2(1400, 720))
	draw_colored_polygon(
		front_hill, Color("#69b985")
	)


# -----------------------------------
# VEGETATION ANIMEE
# -----------------------------------

func _draw_pine(x: float, ground_y: float, scale: float,
		trunk_width: float = 0.0, canopy_lift: float = 0.0) -> void:
	var base := Vector2(x, ground_y)
	var shadow := PackedVector2Array()
	for i in range(24):
		var angle := TAU * float(i) / 24.0
		shadow.append(base + Vector2(cos(angle) * 36.0, sin(angle) * 5.5 - 2.0) * scale)
	draw_colored_polygon(shadow, Color("#285745", 0.29))

	var sway := sin(animation_time * 1.2 + x * 0.014) * 5.0 * scale
	var foot := base + Vector2(0.0, 2.0 * scale)
	var crown := base + Vector2(sway * 0.28, -34.0 * scale - canopy_lift)
	var width := trunk_width if trunk_width > 0.0 else 12.0 * scale
	draw_line(foot, crown, Color("#806449"), width, true)
	draw_line(foot + Vector2(-2.5 * scale, -2.0), crown + Vector2(-2.5 * scale, 0.0),
		Color("#ad8963"), 3.0 * scale, true)
	_draw_pine_canopy(base - Vector2(0.0, canopy_lift), scale * 1.06,
		Color("#287859"), Color("#45946c"), sway)


func _draw_bush(x: float, y: float, scale: float) -> void:
	var sway = sin(
		animation_time * 1.7 + x * 0.016
	) * 3.0 * scale

	draw_circle(
		Vector2(x - 17 * scale + sway, y - 9 * scale),
		21 * scale, Color("#297e5d"), true, -1.0, true
	)
	draw_circle(
		Vector2(x + 13 * scale + sway, y - 10 * scale),
		24 * scale, Color("#348d64"), true, -1.0, true
	)
	draw_circle(
		Vector2(x - 6 * scale + sway, y - 23 * scale),
		24 * scale, Color("#57ad73"), true, -1.0, true
	)
	var highlight := Vector2(x - 11.0 * scale + sway, y - 31.0 * scale)
	draw_arc(highlight, 11.0 * scale, PI * 1.07, PI * 1.61, 16, Color("#82c489"), 1.5, true)


func _course_pines() -> Array:
	match current_level:
		2: return RIVER_PINES
		3: return FOREST_PINES
		4: return ORCHARD_TREES
		5:
			var trees: Array[Vector2] = []
			for pine: Vector2 in [Vector2(68, 0.70), Vector2(331, 0.55), Vector2(536, 0.74),
				Vector2(857, 0.63), Vector2(1008, 0.75), Vector2(1220, 0.58)]:
				trees.append(Vector2(pine.x * course_width / 1280.0, pine.y))
			return trees
		6:
			var trees: Array[Vector2] = []
			for pine: Vector2 in CLIFF_PINES:
				trees.append(Vector2(pine.x * course_width / 1280.0, pine.y))
			return trees
		7:
			return [Vector2(72, 0.57), Vector2(352, 0.48),
				Vector2(course_width - 442.0, 0.56), Vector2(course_width - 58.0, 0.60)]
		8:
			if hole_index == 1:
				return [Vector2(89, 0.74), Vector2(308, 0.62), Vector2(469, 0.74),
					Vector2(639, 0.55), Vector2(838, 0.70), Vector2(1191, 0.81)]
			if hole_index == 2:
				return [Vector2(82, 0.81), Vector2(326, 0.67), Vector2(1275, 0.72), Vector2(1586, 0.85)]
		9:
			return [Vector2(47, 0.68), Vector2(371, 0.49), Vector2(1287, 0.77)]
	return PINES


func _draw_wind_birch(base: Vector2, size: float) -> void:
	var lean := float(wind) * 7.0 + sin(animation_time * 2.1 + base.x * 0.02) * 4.0
	draw_set_transform_matrix(Transform2D(Vector2(size, 0.0), Vector2(-lean * size / 100.0, size), base))
	draw_line(Vector2(1.0, 1.0), Vector2(-1.0, -99.0), Color("#f7efd3"), 9.0, true)
	draw_line(Vector2(3.0, 0.0), Vector2(1.0, -93.0), Color("#d0bc93"), 2.4, true)
	for height: float in [14.0, 30.0, 46.0, 63.0]:
		draw_line(Vector2(-3.0, -height), Vector2(2.0, -height + 1.0), Color("#706d50"), 1.9, true)
	for branch: Vector2 in [Vector2(-21.0, -76.0), Vector2(21.0, -89.0)]:
		draw_line(Vector2(0.0, branch.y + 27.0), branch, Color("#f1e5c9"), 3.5, true)
	draw_circle(Vector2(-17.0, -82.0), 23.0, Color("#5b9861"), true, -1.0, true)
	draw_circle(Vector2(16.0, -87.0), 26.0, Color("#73a85c"), true, -1.0, true)
	draw_circle(Vector2(-2.0, -113.0), 26.0, Color("#83b765"), true, -1.0, true)
	draw_circle(Vector2(-10.0, -121.0), 16.0, Color("#a1cc7a"), true, -1.0, true)
	draw_arc(Vector2(-9.0, -120.0), 12.5, PI * 1.12, PI * 1.69, 12, Color("#bedb8f"), 1.8, true)
	draw_set_transform(Vector2.ZERO)


func _draw_vegetation_back() -> void:
	for pine: Vector2 in _course_pines():
		if _over_water(pine.x) or _over_void(pine.x):
			continue
		var base := Vector2(pine.x, _ground_height(pine.x))
		if current_level == 4:
			_draw_apple_tree(base, pine.y)
		elif current_level == 8 and hole_index > 0:
			_draw_wind_birch(base, pine.y)
		else:
			_draw_pine(base.x, base.y, pine.y)

	if current_level == 2:
		_draw_bush(243, _ground_height(243), 0.68)
		_draw_bush(1015, _ground_height(1015), 0.62)
	elif current_level == 3:
		_draw_bush(226, _ground_height(226), 0.58)
		_draw_bush(956, _ground_height(956), 0.59)
	elif current_level == 4:
		_draw_bush(372, _ground_height(372), 0.54)
		_draw_bush(978, _ground_height(978), 0.62)
	elif current_level == 5:
		for fraction: float in [0.18, 0.49, 0.76, 0.95]:
			var x := course_width * fraction
			_draw_bush(x, _ground_height(x), 0.64)
	elif current_level == 6:
		for fraction: float in [0.16, 0.31, 0.83, 0.93]:
			var x := course_width * fraction
			_draw_bush(x, _ground_height(x), 0.56)
	else:
		for x: float in [388.0, 871.0]:
			if not _over_water(x):
				_draw_bush(x, _ground_height(x), 0.75 if x < 500.0 else 0.65)


# -----------------------------------
# TERRAIN
# -----------------------------------

func _draw_terrain() -> void:
	var earth := [Color("#bc8a58"), Color("#b7885d"), Color("#ae805a"),
		Color("#b8895b"), Color("#b48a5e"), Color("#a9987b"), Color("#a19378"), Color("#b68e65"),
		Color("#af835b")]
	var soil: Color = earth[current_level - 1]
	_draw_gradient_band(soil_surface, soil_mid, 0.0, 1.0, soil.lightened(0.06), soil.darkened(0.05))
	_draw_gradient_band(soil_mid, soil_deep, 0.0, 1.0, soil.darkened(0.05), soil.darkened(0.18))
	_draw_gradient_band(soil_deep, soil_bottom, 0.0, 1.0, soil.darkened(0.18), soil.darkened(0.30))
	draw_polyline(soil_mid, soil.darkened(0.13), 1.8, true)
	draw_polyline(soil_deep, soil.lightened(0.005), 1.6, true)

	for i in range(ceili(course_width / 43.0)):
		var x := 24.0 + float(i) * 43.0
		var y := _ground_height(x) + 29.0 + float((i * 43) % 142)
		if y > 714.0 or _over_water(x):
			continue
		_draw_soil_pebble(Vector2(x, y), 0.65 + float((i * 13) % 7) * 0.115, soil)
		if i % 3 == 1:
			draw_line(Vector2(x + 11, y + 5), Vector2(x + 15, y + 4), soil.lightened(0.20), 1.4, true)

	# La lèvre supérieure est dessinée sur les mêmes points que la collision.
	_draw_gradient_band(ground_top, grass_base_edge, 0.0, 1.0, Color("#90cf68"), Color("#55a65f"))
	draw_polyline(grass_base_edge, Color("#477e50"), 1.65, true)
	draw_polyline(ground_top, Color("#497f54"), 2.4, true)
	draw_polyline(grass_light_edge, Color("#c1e284", 0.85), 2.1, true)


func _prepare_terrain_art() -> void:
	soil_surface.clear()
	soil_mid.clear()
	soil_deep.clear()
	soil_bottom.clear()
	for i in range(ground_top.size() - 1):
		var left := ground_top[i]
		var right := ground_top[i + 1]
		var steps := ceili((right.x - left.x) / 16.0)
		for step in range(steps):
			soil_surface.append(left.lerp(right, float(step) / steps))
	soil_surface.append(ground_top[-1])
	for point in soil_surface:
		var available := 800.0 - point.y
		soil_mid.append(point + Vector2(0.0, minf(53.0 + sin(point.x * 0.012) * 8.0, available * 0.31)))
		soil_deep.append(point + Vector2(0.0, minf(145.0 + sin(point.x * 0.010 + 1.0) * 15.0, available * 0.77)))
		soil_bottom.append(Vector2(point.x, 800.0))
	grass_base_edge = _lower_ground_edge(19.0, 2.5)
	grass_light_edge = _lower_ground_edge(5.0, 0.0)


func _lower_ground_edge(depth: float, variation: float) -> PackedVector2Array:
	var edge := PackedVector2Array()
	for point in ground_top:
		edge.append(point + Vector2(0.0, depth + sin(point.x * 0.017) * variation))
	return edge


func _draw_soil_pebble(center: Vector2, size: float, soil: Color) -> void:
	draw_set_transform(center, 0.11, Vector2(1.50, 0.73) * size)
	draw_circle(Vector2.ZERO, 5.6, soil.darkened(0.23), true, -1.0, true)
	draw_circle(Vector2(0.0, -0.55), 4.5, soil.lightened(0.11), true, -1.0, true)
	draw_arc(Vector2.ZERO, 3.7, 3.5, 5.0, 10, soil.lightened(0.29), 0.85, true)
	draw_set_transform(Vector2.ZERO)


# -----------------------------------
# FLEURS ET HERBES
# -----------------------------------

func _draw_flower(
	x: float,
	y: float,
	color: Color
) -> void:
	var sway = sin(
		animation_time * 2.0 + x * 0.06
	) * 3.5

	var center = Vector2(x + sway, y - 14)

	draw_line(
		Vector2(x, y),
		center,
		Color("#3b9160"),
		2
	)

	for offset in [
		Vector2(-5, 0),
		Vector2(5, 0),
		Vector2(0, -5),
		Vector2(0, 5)
	]:
		var petal: Vector2 = center + offset
		draw_circle(petal, 4.8, Color("#67886b"), true, -1.0, true)
		draw_circle(petal + Vector2(0, -0.3), 3.9, color, true, -1.0, true)

	draw_circle(
		center, 3, Color("#ffe39b")
	)


func _draw_grass_and_flowers() -> void:
	for i in range(floori(course_width / 19.4) - 1):
		var x = 16.0 + float(i) * 19.4
		if _over_water(x) or _over_void(x, 10.0) or _under_forest_obstacle(x, 10.0):
			continue
		var y = _ground_height(x) - 7
		var h = 6.0 + float(i % 4) * 2.0

		var wind = sin(
			animation_time * 2.1 + x * 0.047
		) * 4.5

		draw_line(
			Vector2(x, y),
			Vector2(x - 3 + wind, y - h),
			Color("#367d56"),
			2
		)

		draw_line(
			Vector2(x, y),
			Vector2(x + 4 + wind, y - h * 0.8),
			Color("#428f5e"),
			2
		)

	for flower: Vector2 in [Vector2(112, 0), Vector2(413, 1), Vector2(646, 0), Vector2(890, 1), Vector2(1140, 0)]:
		if flower.x == 1140.0 and current_level != 5:
			continue
		var x := flower.x * course_width / 1280.0
		if not _over_water(x) and not _over_void(x, 14.0) and not _under_forest_obstacle(x, 14.0):
			_draw_flower(x, _ground_height(x) - 5,
				Color("#ffe9f0") if flower.y == 0.0 else Color("#fff0be"))


func _under_forest_obstacle(x: float, clearance: float) -> bool:
	if rock_span.y > rock_span.x and x >= rock_span.x - clearance and x <= rock_span.y + clearance:
		return true
	var cover: Rect2 = hole.get("tunnel", Rect2())
	return cover.size.x > 0.0 and x >= cover.position.x - clearance and x <= cover.end.x + clearance


func _over_water(x: float) -> bool:
	var water: Vector3 = hole.get("water", Vector3.ZERO)
	return x >= water.x and x <= water.y and _ground_height(x) >= water.z


func _over_void(x: float, margin: float = 0.0) -> bool:
	var gap: Vector2 = hole.get("void", Vector2.ZERO)
	return gap.y > gap.x and x >= gap.x - margin and x <= gap.y + margin


func _draw_foreground() -> void:
	for i in range(ceili(course_width / 41.0)):
		var x = 12.0 + float(i) * 41.0
		if _over_water(x) or _over_void(x, 14.0):
			continue
		var h = 11.0 + float((i * 7) % 19)
		var bend = sin(
			animation_time * 1.65 + x * 0.05
		) * 5.0

		var foot = Vector2(x, 725)

		draw_line(
			foot,
			Vector2(x - 8 + bend, 725 - h),
			Color("#477c54", 0.6),
			3
		)
		draw_line(
			foot,
			Vector2(x + 6 + bend, 725 - h * 0.8),
			Color("#6d9b62", 0.6),
			3
		)


# -----------------------------------
# DRAPEAU ANIME
# -----------------------------------

func _draw_flag_and_hole() -> void:
	var mouth := _cup_mouth()
	var open := _cup_open()
	draw_set_transform(mouth)
	_draw_cup_cover()
	var flag_direction := -1.0 if wind < 0 else 1.0
	if flag_direction < 0.0:
		draw_set_transform(mouth, 0.0, Vector2(flag_direction, 1.0))
	draw_line(Vector2.ZERO, Vector2(0.0, -106.0), Color("#fff9e8"), 5.0, true)
	var flutter := sin(animation_time * (9.0 if won else 4.2)) * (13.0 if won else 7.0)
	var tip := Vector2(68.0 + flutter * 0.55, -86.0 + flutter)
	var flag := Color("#ed775c") if open else Color("#ae9a76")
	var shine := Color("#ffb284") if open else Color("#dfc79a")
	var cloth := PackedVector2Array([Vector2(2.0, -106.0), Vector2(19.0, -102.0),
		Vector2(34.0, -95.0 + flutter * 0.35), tip,
		Vector2(31.0, -74.0 + flutter * 0.35), Vector2(3.0, -68.0)])
	draw_colored_polygon(cloth, flag)
	cloth.append(cloth[0])
	draw_polyline(cloth, flag.darkened(0.28), 1.7, true)
	draw_colored_polygon(PackedVector2Array([
		Vector2(2.0, -106.0), Vector2(30.0, -97.0 + flutter * 0.35),
		tip, Vector2(2.0, -86.0)
	]), shine)
	draw_set_transform(Vector2.ZERO)


func _draw_coins() -> void:
	for i in range(coins.size()):
		if collected.has(i):
			continue
		var center := coins[i]
		var turn := 0.65 + 0.35 * absf(cos(animation_time * 3.2 + i))
		draw_set_transform(center, 0.0, Vector2(turn, 1.0))
		draw_circle(Vector2.ZERO, COIN_RADIUS + 2.0, Color("#ad6b24"), true, -1.0, true)
		draw_circle(Vector2(0.0, -1.0), COIN_RADIUS, Color("#ffcd56"), true, -1.0, true)
		draw_arc(Vector2(0.0, -1.0), COIN_RADIUS - 3.0, 0.0, TAU, 24, Color("#ffe9a6"), 2.0, true)
		draw_line(Vector2(0.0, -6.0), Vector2(0.0, 4.0), Color("#c88a32"), 2.0, true)
		draw_set_transform(Vector2.ZERO)


# -----------------------------------
# OISEAUX
# -----------------------------------

func _bird_screen_edges() -> Vector2:
	var rect := get_viewport_rect()
	var inverse := get_canvas_transform().affine_inverse()
	return Vector2((inverse * rect.position).x, (inverse * Vector2(rect.end.x, rect.position.y)).x)


func _update_birds(delta: float) -> void:
	var edges := _bird_screen_edges()
	bird_timer -= delta

	if bird_timer <= 0.0:
		bird_timer = rng.randf_range(13.0, 19.0)
		if birds.size() < SKY_BIRD_LIMIT - 1:
			var direction := 1.0 if rng.randf() > 0.5 else -1.0
			birds.append({
				"pos": Vector2(edges.x - 32.0 if direction > 0.0 else edges.y + 32.0, rng.randf_range(115.0, 240.0)),
				"speed": rng.randf_range(62.0, 76.0) * direction,
				"phase": rng.randf_range(0.0, TAU),
				"size": rng.randf_range(0.58, 0.75)
			})

	for i in range(birds.size() - 1, -1, -1):
		var bird = birds[i]
		var pos: Vector2 = bird["pos"]

		pos.x += float(bird["speed"]) * delta
		pos.y += sin(
			animation_time * 1.8 + float(bird["phase"])
		) * delta * 3.0

		if bird.has("rise"):
			var rise := float(bird["rise"])
			pos.y -= rise * delta
			bird["rise"] = maxf(0.0, rise - 95.0 * delta)
		bird["pos"] = pos

		if pos.x < edges.x - 48.0 or pos.x > edges.y + 48.0:
			birds.remove_at(i)
		else:
			birds[i] = bird


func _draw_birds() -> void:
	for bird in birds:
		var p: Vector2 = bird["pos"]
		var scale: float = bird["size"]

		var flap = sin(
			animation_time * 10.0 + float(bird["phase"])
		) * 8.0 * scale

		draw_polyline(PackedVector2Array([
			p + Vector2(-16, -3 - flap) * scale,
			p + Vector2(-8, -7 - flap * 0.35) * scale,
			p,
			p + Vector2(8, -7 - flap * 0.35) * scale,
			p + Vector2(16, -3 - flap) * scale
		]), Color("#597e83", 0.85), 2.3, true)


# -----------------------------------
# PARTICULES DE TIR ET D'ATTERRISSAGE
# -----------------------------------

func _on_ball_body_entered(body: Node) -> void:
	if not (body is StaticBody2D) or shots == 0 or won:
		return

	if animation_time - last_impact_time < 0.20:
		return

	var speed = ball.linear_velocity.length()

	if speed < 75.0:
		return

	last_impact_time = animation_time

	_emit_landing_particles(
		Vector2(
			ball.position.x,
			_ground_height(ball.position.x) - 7
		),
		speed
	)


func _emit_shot_particles() -> void:
	for i in range(7):
		var p = ball.position + Vector2(
			rng.randf_range(-8, 8),
			rng.randf_range(5, 14)
		)
		var v = Vector2(
			rng.randf_range(-90, 90),
			rng.randf_range(-115, -40)
		)

		_add_particle(
			p, v,
			Color("#e4e8c4"),
			rng.randf_range(0.35, 0.65),
			3.0, 270.0
		)


func _emit_landing_particles(
	at: Vector2,
	speed: float
) -> void:
	var amount = clampi(
		roundi(speed / 35.0),
		5, 14
	)

	for i in range(amount):
		var p = at + Vector2(
			rng.randf_range(-12, 12), 0
		)
		var v = Vector2(
			rng.randf_range(-115, 115),
			rng.randf_range(-140, -35)
		)

		var c = Color("#b9c878") if i % 3 == 0 else Color("#86bd6b")

		_add_particle(
			p, v, c,
			rng.randf_range(0.3, 0.7),
			rng.randf_range(2.0, 4.0),
			330.0
		)


func _add_particle(
	pos: Vector2,
	velocity: Vector2,
	color: Color,
	life: float,
	radius: float,
	gravity: float
) -> void:
	particles.append({
		"pos": pos,
		"vel": velocity,
		"color": color,
		"life": life,
		"total": life,
		"radius": radius,
		"gravity": gravity
	})

	if particles.size() > 90:
		particles.remove_at(0)


func _update_particles(delta: float) -> void:
	for i in range(particles.size() - 1, -1, -1):
		var p = particles[i]
		var life: float = p["life"]
		life -= delta

		if life <= 0.0:
			particles.remove_at(i)
			continue

		var velocity: Vector2 = p["vel"]
		velocity.y += float(p["gravity"]) * delta

		var pos: Vector2 = p["pos"]
		pos += velocity * delta

		p["pos"] = pos
		p["vel"] = velocity
		p["life"] = life
		particles[i] = p


func _draw_particles() -> void:
	for p in particles:
		var color: Color = p["color"]

		var alpha = clampf(
			float(p["life"]) / float(p["total"]),
			0.0, 1.0
		)

		color.a = alpha * 0.95

		draw_circle(
			p["pos"],
			float(p["radius"]) * (0.4 + alpha * 0.6),
			color
		)


# -----------------------------------
# TRAINEE DE BALLE EN VOL
# -----------------------------------

func _update_trail(delta: float) -> void:
	for i in range(ball_trail.size() - 1, -1, -1):
		var dot = ball_trail[i]
		var remaining: float = dot["life"]
		remaining -= delta

		if remaining <= 0.0:
			ball_trail.remove_at(i)
		else:
			dot["life"] = remaining
			ball_trail[i] = dot

	if won or shots <= 0 or ball == null:
		return

	var airborne = (
		ball.position.y <
		_ground_height(ball.position.x) - BALL_RADIUS - 9.0
	)

	if airborne and ball.linear_velocity.length() > 120.0:
		trail_timer += delta

		if trail_timer >= 0.029:
			trail_timer = 0.0

			ball_trail.append({
				"pos": ball.position,
				"life": 0.34
			})

			if ball_trail.size() > 24:
				ball_trail.remove_at(0)
	else:
		trail_timer = 0.0


func _draw_ball_trail() -> void:
	for dot in ball_trail:
		var alpha = clampf(
			float(dot["life"]) / 0.34,
			0.0, 1.0
		)

		draw_circle(
			dot["pos"],
			3.0 + alpha * 5.0,
			Color(1, 1, 1, alpha * 0.50)
		)


# -----------------------------------
# BALLE
# -----------------------------------

func _draw_ball() -> void:
	if ball == null or sink_progress >= 1.0:
		return

	var center := ball.position
	var ball_scale := 1.0
	if won:
		var mouth := _cup_mouth()
		center = sink_from.lerp(mouth + Vector2(0.0, 5.0), sink_progress)
		ball_scale = 1.0 - sink_progress
	else:
		draw_circle(ball.position + Vector2(4, 9), 15, Color("#264d40", 0.28))

	draw_circle(center, (BALL_RADIUS + 1.0) * ball_scale, Color("#779a8f"), true, -1.0, true)
	draw_circle(center, (BALL_RADIUS - 0.4) * ball_scale, Color("#e4f0e8"), true, -1.0, true)
	draw_circle(center + Vector2(-1.7, -1.8) * ball_scale, (BALL_RADIUS - 2.7) * ball_scale,
		Color("#fffdf4"), true, -1.0, true)
	var dimple := Vector2(-5, -5).rotated(ball.rotation) * ball_scale
	draw_circle(center + dimple, 4.0 * ball_scale, Color("#e0eced"), true, -1.0, true)


# -----------------------------------
# GUIDE DE VISEE
# -----------------------------------

func _draw_aiming_guide() -> void:
	var pull = _pull_vector()

	if pull.length() < 1:
		return

	var direction = pull.normalized()
	var ratio = _power_ratio()

	var pull_end = ball.position - direction * minf(
		pull.length(),
		MAX_DRAG
	)

	draw_line(
		ball.position,
		pull_end,
		Color("#f2b55e"),
		4,
		true
	)

	var length = 60.0 + ratio * 150.0

	for i in range(10):
		var distance_start = 22.0 + float(i) * 19.0

		if distance_start >= length:
			break

		var distance_end = minf(
			distance_start + 10.0,
			length
		)

		draw_line(
			ball.position + direction * distance_start,
			ball.position + direction * distance_end,
			Color("#fff7de"),
			3,
			true
		)

	var tip = ball.position + direction * length
	var sideways = Vector2(
		-direction.y,
		direction.x
	)

	draw_colored_polygon(PackedVector2Array([
		tip,
		tip - direction * 16 + sideways * 8,
		tip - direction * 16 - sideways * 8
	]), Color("#fff7de"))
