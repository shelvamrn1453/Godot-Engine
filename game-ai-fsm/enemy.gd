extends CharacterBody2D

# ================================
# FSM - STATE MUSUH
# ================================
enum State {IDLE, CHASE, ATTACK}
var current_state = State.IDLE

# ================================
# VARIABEL
# ================================
const SPEED = 100.0
const CHASE_RADIUS = 300.0   # jarak mulai kejar
const ATTACK_RADIUS = 60.0   # jarak serang (lebih kecil)

var player = null  # referensi ke node pemain

# ================================
# SAAT SCENE PERTAMA DIMUAT
# ================================
func _ready():
	player = get_tree().get_first_node_in_group("player")

# ================================
# DIPANGGIL SETIAP FRAME
# ================================
func _physics_process(delta):
	if player == null:
		return
	
	var distance = global_position.distance_to(player.global_position)
	
	# --- TRANSISI STATE ---
	if distance <= ATTACK_RADIUS:
		current_state = State.ATTACK
	elif distance <= CHASE_RADIUS:
		current_state = State.CHASE
	else:
		current_state = State.IDLE
	
	# --- AKSI PER STATE ---
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO  # diam
		State.CHASE:
			# bergerak ke arah pemain
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * SPEED
		State.ATTACK:
			velocity = Vector2.ZERO  # berhenti, serang
			print("ATTACKING!")  # nanti bisa diganti animasi/damage
	
	move_and_slide()
