class_name BattleWorld
extends RefCounted
## Geometry of the 3-screen battlefield (view only: the simulation lane never changes). World px are the
## coordinates of everything drawn on the lane; the camera (BattleCamera) shifts the world node on screen.
## sim x -> world px is linear: sim 0 at LANE_X0 (player side), sim `lane` at LANE_X1 (enemy side).

const SCREEN_W := 540.0
const SCREEN_H := 960.0
const WORLD_W := 1620.0              ## 3 screens wide
const MAX_CAM := WORLD_W - SCREEN_W  ## camera x (left edge of the view, world px) ranges over [0, MAX_CAM]
const SCALE := 1.5                   ## drawing scale of units, bases, numbers and effects (was 1.0)
const LANE_X0 := 190.0               ## world x of sim x = 0
const LANE_X1 := 1430.0              ## world x of sim x = lane
const PLAYER_BASE_X := 136.0         ## base centres (art overlaps the lane ends like the old layout did)
const ENEMY_BASE_X := 1484.0

## Height of the lane's foot line as a fraction of the screen, per era (cards sit below 72%, bars above 20%).
const FOOT_FRAC := {1: 0.58, 2: 0.58, 3: 0.58, 4: 0.58, 5: 0.58}


static func foot_y(era: int) -> float:
	return float(FOOT_FRAC.get(era, 0.58)) * SCREEN_H


## World px per sim px for a lane of `lane` sim px.
static func px_per_sim(lane: float) -> float:
	return (LANE_X1 - LANE_X0) / maxf(1.0, lane)


static func sim_to_world(sim_x: float, lane: float) -> float:
	return LANE_X0 + sim_x * px_per_sim(lane)


static func world_to_sim(world_x: float, lane: float) -> float:
	return (world_x - LANE_X0) / px_per_sim(lane)


static func world_to_screen(world_x: float, cam_x: float) -> float:
	return world_x - cam_x


static func screen_to_world(screen_x: float, cam_x: float) -> float:
	return screen_x + cam_x
