function GenerateQuads(atlas, tW, tH)
	local sW, sH = atlas:getWidth() / tW, atlas:getHeight() / tH
	local quads = {}
	for y = 0, sH - 1 do
		for x = 0, sW - 1 do
			quads[#quads + 1] = love.graphics.newQuad(x * tW, y * tH, tW, tH, atlas)
		end
	end
	return quads
end
