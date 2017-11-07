-- luacheck: read globals incAndWrap

return function(env)

	-- this function will return different closures for a few cases to improve performance
	function env.range(start, limit, step)
		step = step or 1
		local v = start - step

		-- having no limit can save on branches
		if not limit then
			return function()
				v = v + step
				return v
			end
		end

		-- use branchless incAndWrap if possible
		if type(v) == "number" and step == 1 then
			return function()
				v = incAndWrap(v, limit)
				return v
			end
		end

		return function()
			if v > limit then
				v = start
			else
				v = v + step
			end

			return v
		end
	end

	function env.randomRange(start, limit)
		return function()
			return math.random(start, limit)
		end
	end

	function env.list(tbl)
		local index, len = 0, #tbl

		return function()
			local v = tbl[index + 1]
			index = incAndWrap(index, len)
			return v
		end
	end

	function env.randomList(tbl)
		local len = #tbl
		return function()
			return tbl[math.random(len)]
		end
	end
end
