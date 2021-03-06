----------------------------------------------------------------
-- Copyright (c) 2010-2017 Zipline Games, Inc. 
-- All Rights Reserved. 
-- http://getmoai.com
----------------------------------------------------------------

MOAISim.openWindow ( "test", 320, 480 )

viewport = MOAIViewport.new ()
viewport:setSize ( 320, 480 )
viewport:setScale ( 320, 480 )

camera = MOAICamera.new ()
camera:setType ( MOAICamera.CAMERA_TYPE_3D )
camera:setLoc ( 0, 0, camera:getFocalLength ( 320 ))

layer = MOAIPartitionViewLayer.new ()
layer:setViewport ( viewport )
layer:setPartitionCull2D ( false )
layer:setClearDepth ( true )
layer:pushRenderPass ()
layer:setCamera ( camera )

local function pushPoint ( points, x, y, z )
	
	local point = {}
	point.x = x
	point.y = y
	point.z = z
	
	table.insert ( points, point )
end

local function writeTri ( vbo, p1, p2, p3, uv1, uv2, uv3 )
	
	vbo:writeFloat ( p1.x, p1.y, p1.z )
	vbo:writeFloat ( uv1.x, uv1.y )
	vbo:writeColor32 ( 1, 1, 1 )
	
	vbo:writeFloat ( p2.x, p2.y, p2.z )
	vbo:writeFloat ( uv2.x, uv2.y )
	vbo:writeColor32 ( 1, 1, 1 )

	vbo:writeFloat ( p3.x, p3.y, p3.z )
	vbo:writeFloat ( uv3.x, uv3.y  )
	vbo:writeColor32 ( 1, 1, 1 )
end

local function writeFace ( vbo, p1, p2, p3, p4, uv1, uv2, uv3, uv4 )

	writeTri ( vbo, p1, p2, p4, uv1, uv2, uv4 )
	writeTri ( vbo, p2, p3, p4, uv2, uv3, uv4 )
end

local function writeCube ( vbo, x, y, z, r )

	local xMin, yMin, zMin, xMax, yMax, zMax = -r + x, -r + y, -r + z, r + x, r + y, r + z

	local p = {}
	
	pushPoint ( p, xMin, yMax, zMax ) -- p1
	pushPoint ( p, xMin, yMin, zMax ) -- p2
	pushPoint ( p, xMax, yMin, zMax ) -- p3
	pushPoint ( p, xMax, yMax, zMax ) -- p4
	
	pushPoint ( p, xMin, yMax, zMin ) -- p5
	pushPoint ( p, xMin, yMin, zMin  ) -- p6
	pushPoint ( p, xMax, yMin, zMin  ) -- p7
	pushPoint ( p, xMax, yMax, zMin  ) -- p8

	local uv = {}
	
	pushPoint ( uv, 0, 0, 0 )
	pushPoint ( uv, 0, 1, 0 )
	pushPoint ( uv, 1, 1, 0 )
	pushPoint ( uv, 1, 0, 0 )

	writeFace ( vbo, p [ 1 ], p [ 2 ], p [ 3 ], p [ 4 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 4 ], p [ 3 ], p [ 7 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 8 ], p [ 7 ], p [ 6 ], p [ 5 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 5 ], p [ 6 ], p [ 2 ], p [ 1 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 5 ], p [ 1 ], p [ 4 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 2 ], p [ 6 ], p [ 7 ], p [ 3 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
end

function makeMesh ()
	
	local vertexFormat = MOAIVertexFormat.new ()
	vertexFormat:declareCoord ( 1, MOAIVertexFormat.GL_FLOAT, 3 )
	vertexFormat:declareUV ( 2, MOAIVertexFormat.GL_FLOAT, 2 )
	vertexFormat:declareColor ( 3, MOAIVertexFormat.GL_UNSIGNED_BYTE )

	local vbo = MOAIVertexBuffer.new ()
	vbo:reserve ( 4 * 36 * vertexFormat:getVertexSize ())
	
	writeCube ( vbo, -64, -64, 0, 32 )
	writeCube ( vbo, -64, 64, 0, 32 )
	writeCube ( vbo, 64, 64, 0, 32 )
	writeCube ( vbo, 64, -64, 0, 32 )

	local mesh = MOAIMesh.new ()
	mesh:setTexture ( '../resources/moai.png' )

	mesh:setVertexBuffer ( vbo, vertexFormat )
	mesh:setTotalElements ( vbo:countElements ( vertexFormat ))
	mesh:setBounds ( vbo:computeBounds ( vertexFormat ))
	
	mesh:setPrimType ( MOAIMesh.GL_TRIANGLES )
	mesh:setShader ( MOAIShaderMgr.getShader ( MOAIShaderMgr.MESH_SHADER ))
	
	return mesh
end

local mesh = MOAISelectionMesh.new ()
mesh:setMesh ( makeMesh ())

local printSelections = function ()
	mesh:printSelection ()
	mesh:printSelection ( 1 )
	mesh:printSelection ( 2 )
	print ()
end

mesh:reserveSelections ( 4 )

mesh:addSelection ( 1, 1, 37 )
mesh:addSelection ( 2, 37, 37 + 36 )
mesh:addSelection ( 3, 73, 73 + 36 )
mesh:addSelection ( 4, 109, 109 + 36 )

local function makeProp ( idx )

	local prop = MOAIProp.new ()
	prop:setDeck ( mesh )
	prop:setIndex ( idx )
	
	prop:setDepthTest ( MOAIProp.DEPTH_TEST_LESS )
	prop:setCullMode ( MOAIGraphicsProp.CULL_BACK )
	prop:setPartition ( layer )

	return prop
end

prop = makeProp ( 1 )
prop:moveRot ( 360, 360, 0, 6 )
prop:seekColor ( 1, 0, 0, 1, 6 )

prop = makeProp ( 2 )
prop:moveRot ( 360, 0, 360, 6 )
prop:seekColor ( 0, 1, 0, 1, 6 )

prop = makeProp ( 3 )
prop:moveRot ( 0, 360, 360, 6 )
prop:seekColor ( 0, 0, 1, 1, 6 )

prop = makeProp ( 4 )
prop:moveRot ( 360, 360, 0, 6 )
prop:seekColor ( 1, 1, 0, 1, 6 )
