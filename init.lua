local image = {
	' #    ###  #### #### ### # # ### ### ### ## ## ### ',
	' #     #   # #  ##   ### ##  ##   #   #  # # # ##  ',
	' ###  ###  #### #    # # # # ###  #  ### #   # ### ',
	'                                                   ',
	' ### ### ### #     ### ### ### #   ### ### ### # # ',
	' #   # # # # #      #  # # # # #   ### ### #   ##  ',
	' ### ### ### ###    #  ### ### ### #   # # ### # # ',
}

-- To align image, we start at Jan 4 1970 12:00:00 PM
local start = 302400

-- Number of commits in one day
local commits = 5

-- File to write changes
local file = 'faketime-is-the-best'

--- Commands we'll run
local add = { 'git', 'add', file }
local commit = { 'faketime', '<date>', 'git', 'commit', '-m', '<msg>' }

-- Going throught the whole image
for i = 0, #image * #image[1] - 1 do
	-- This is timestamp of start of the day
	-- (86400 is seconds in one day)
	local day = start + i * 86400

	-- Location of point
	local row = i % #image + 1
	local col = math.floor(i / #image) + 1

	-- Do we have this point colored
	local is_colored = image[row]:sub(col, col) == '#'

	if is_colored then
		-- Creating commits in this day
		for j = 0, commits - 1 do
			-- We have to change time by one second
			local time = day + j

			-- To have 'pretty' file, we have to reopen file
			local fp = io.open(file, 'w')
			fp:write(time)
			fp:close()

			--- Now, we need to add and commit changes.
			-- Adding file to staged
			os.execute(table.concat(add, ' '))

			-- Committing changes
			local date = os.date('%Y-%m-%d %H:%M:%S', time)
			commit[2] = '"' .. date .. '"'
			commit[6] = '"' .. date .. '"'
			os.execute(table.concat(commit, ' '))
		end
	end
end
