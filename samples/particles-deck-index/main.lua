----------------------------------------------------------------
-- Copyright (c) 2010-2017 Zipline Games, Inc. 
-- All Rights Reserved. 
-- http://getmoai.com
----------------------------------------------------------------

MOAIDebugLinesMgr.setStyle ( MOAIProp.DEBUG_DRAW_MODEL_BOUNDS, 2, 1, 1, 1 )
MOAIDebugLinesMgr.setStyle ( MOAIProp.DEBUG_DRAW_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75 )

print ( "hello, moai!" )

viewport = MOAIViewport.new ()
viewport:setSize ( 640, 480 )
viewport:setScale ( 640, 480 )

layer = MOAIPartitionViewLayer.new ()
layer:setViewport ( viewport )
layer:pushRenderPass ()

MOAISim.openWindow ( "cathead", 640, 480 )

CONST = MOAIParticleScript.packConst

local r1 = MOAIParticleScript.packReg ( 1 )
local r2 = MOAIParticleScript.packReg ( 2 )

----------------------------------------------------------------
local init = MOAIParticleScript.new ()

init:vecAngle			( r1, MOAIParticleScript.PARTICLE_DX, MOAIParticleScript.PARTICLE_DY )
init:sub				( r1, CONST ( 180.0 ), r1 )
init:randInt			( r2, CONST ( 1 ), CONST ( 4 ))

local render = MOAIParticleScript.new ()

render:add				( MOAIParticleScript.PARTICLE_X, MOAIParticleScript.PARTICLE_X, MOAIParticleScript.PARTICLE_DX )
render:add				( MOAIParticleScript.PARTICLE_Y, MOAIParticleScript.PARTICLE_Y, MOAIParticleScript.PARTICLE_DY )

render:sprite			()
render:set				( MOAIParticleScript.SPRITE_ROT, r1 )
render:set				( MOAIParticleScript.SPRITE_IDX, r2 )
render:ease				( MOAIParticleScript.SPRITE_X_SCL, CONST ( 0.5 ), CONST ( 3 ), MOAIEaseType.SHARP_EASE_IN )
render:ease				( MOAIParticleScript.SPRITE_OPACITY, CONST ( 1 ), CONST ( 0 ), MOAIEaseType.EASE_OUT )

----------------------------------------------------------------
tileDeck = MOAITileDeck2D.new ()
tileDeck:setTexture ( '../resources/test.png' )
tileDeck:setSize ( 2, 2 )
tileDeck:setRect ( -16, -16, 16, 16 )

system = MOAIParticleSystem.new ()
system:reserveParticles ( 256, 2 )
system:reserveSprites ( 256 )
system:reserveStates ( 2 )
system:setDeck ( tileDeck )
system:setComputeBounds ( true )
system:start ()
system:setPartition ( layer )

state = MOAIParticleState.new ()
state:setTerm ( 3, 3 )
state:setInitScript ( init )
state:setRenderScript ( render )
system:setState ( 1, state )

emitter = MOAIParticleDistanceEmitter.new ()
emitter:setLoc ( 0, 0 )
emitter:setSystem ( system )
emitter:setMagnitude ( 0.125 )
emitter:setAngle ( 260, 280 )
emitter:setDistance ( 16 )
emitter:start ()

function pointerCallback ( x, y )
	
	mouseX, mouseY = layer:wndToWorld ( x, y )
	
	emitter:setLoc ( mouseX, mouseY )
	
	if MOAIInputMgr.device.mouseLeft:isUp () then
		emitter:reset ()
	end
end

MOAIInputMgr.device.pointer:setCallback ( pointerCallback )
