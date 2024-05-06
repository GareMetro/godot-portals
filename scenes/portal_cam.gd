extends MeshInstance3D

@onready var teleport_zone : Area3D = $Area3D
@onready var portal_cam : Camera3D = $SubViewport/Camera3D
@onready var portal_viewport : SubViewport = $SubViewport
@export var portal_destination : Node3D
@export var player_cam : Camera3D

#Portal layer
@export var cull_layer = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	#Display the portal on the given layer
	for layer in range(1, 21):
		self.set_layer_mask_value(layer, false)
	self.set_layer_mask_value(cull_layer, true)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	#Move the camera
	var player_to_portal_transform = self.global_transform.affine_inverse() * player_cam.global_transform
	var portal_cam_new_transform = portal_destination.global_transform.rotated_local(Vector3.UP, deg_to_rad(180)) * player_to_portal_transform
	
	portal_cam.global_transform = portal_cam_new_transform
	portal_cam.fov = player_cam.fov
	portal_cam.cull_mask = player_cam.cull_mask
	
	if portal_destination.cull_layer:
		portal_cam.set_cull_mask_value(portal_destination.cull_layer, false)
	
	var player_viewport = get_viewport()
	portal_viewport.size = player_viewport.get_visible_rect().size
	portal_viewport.msaa_3d = player_viewport.msaa_3d
	portal_viewport.screen_space_aa = player_viewport.screen_space_aa
	portal_viewport.use_taa = player_viewport.use_taa
	portal_viewport.use_debanding = player_viewport.use_debanding
	portal_viewport.use_occlusion_culling = player_viewport.use_occlusion_culling
	portal_viewport.mesh_lod_threshold = player_viewport.mesh_lod_threshold
	
	
