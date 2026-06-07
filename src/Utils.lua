function GenerateQuads(atlas)
	local sW, sH = atlas:getWidth() / 32, atlas:getHeight() / 32
	local quads = {}
	for y = 0, sH - 1 do
		for x = 0, sW - 1 do
			quads[#quads + 1] = love.graphics.newQuad(x * 32, y * 32, 32, 32, atlas)
		end
	end
	return quads
end
