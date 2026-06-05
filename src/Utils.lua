function GenerateQuads(atlas, tW, tH, oX, oY, max)
	local sW, sH = atlas:getWidth() / tW, atlas:getHeight() / tH
	oX, oY = (oX or 0) / tW, (oY or 0) / tW
	max = max or sW * sH
	local quads = {}
	local counter = 0
	for y = oY, sH - 1 do
		for x = oX, sW - 1 do
			table.insert(quads, love.graphics.newQuad(x * tW, y * tH, tW, tH, atlas))
			counter = counter + 1
			if counter > max then
				return quads
			end
		end
	end
	return quads
end
