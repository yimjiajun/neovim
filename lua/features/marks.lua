local function all_marks(act)
	local skip_mark = { 'E', 'I', 'N', 'W' }
	local items = {}
	local item
	local mark
	local row, col, bufnr
	local filepath

	if act == nil then
		act = ''
	else
		act = string.lower(act)
	end

	for mark_to_insert = string.byte('A'), string.byte('Z'), 1 do
		mark = vim.api.nvim_get_mark(string.char(mark_to_insert), {})
		row, col, bufnr = mark[1], mark[2], mark[3]
		filepath = mark[4]
		local mark_empty = ((row or col or bufnr) == 0) and (filepath == '')

		if act == 'save' then
			if (mark_empty == false) and (string.char(mark_to_insert) ~= 'Z') then
				goto continue
			end

			if vim.tbl_contains(skip_mark, string.char(mark_to_insert)) then
				goto continue
			end

			row = vim.fn.line('.')
			vim.cmd(row .. 'mark ' .. string.char(mark_to_insert))

			break
		elseif act == 'remove' then
			if (mark_empty == true) or (string.char(mark_to_insert) == 'Z') then
				local delete_mark

				if (string.char(mark_to_insert) == 'A') or (string.char(mark_to_insert) == 'Z' and mark_empty == false) then
					delete_mark = string.char(mark_to_insert)
				else
					delete_mark = string.char(mark_to_insert-1)
				end

				if vim.tbl_contains(skip_mark, delete_mark) then
					goto continue
				end

				vim.cmd('delmarks ' .. delete_mark)

				break
			end
		elseif act == 'clear' then
			if mark_empty == false then
				if vim.tbl_contains(skip_mark, string.char(mark_to_insert)) then
					goto continue
				end

				vim.cmd('delmarks ' .. string.char(mark_to_insert))
			end
		else
			if mark_empty == true then
				goto continue
			end

			if vim.fn.match(vim.fn.fnamemodify(filepath, ':p'), vim.fn.getcwd()) == -1
				and act ~= 'universal' then
				goto continue
			end

			item = {
				filename = vim.fn.fnamemodify(filepath, ':p'),
				text =  vim.fn.getline(row),
				lnum = row,
				col = col,
				type = string.char(mark_to_insert),
				bufnr = nil,
			}

			table.insert(items, item)
		end

		::continue::
	end

	if #items > 0 then
		vim.fn.setqflist({}, ' ', { title = "universal marks", items = items })
		vim.cmd("silent! copen")
	end
end

local function buffer_marks(act)
	local skip_mark = { 'e', 'i', 'n', 'w' }
	local items = {}
	local item
	local mark
	local row, col
	local mark_empty
	local bufnr = vim.fn.bufnr('%')

	if act == nil then
		act = ''
	else
		act = string.lower(act)
	end

	for mark_to_insert = string.byte('a'), string.byte('z'), 1 do
		mark = vim.api.nvim_buf_get_mark(0, string.char(mark_to_insert))
		row, col = mark[1], mark[2]
		mark_empty = ((row or col) == 0)

		if string.match(act, 'save') then

			if (mark_empty == false) and (string.char(mark_to_insert) ~= 'z') then
				if string.match(act, 'sort') then
					table.insert(items, {
							filename = vim.fn.expand('%:p'),
							text = vim.fn.getline(row),
							lnum = row,
							col = col,
							type = string.char(mark_to_insert),
							bufnr = bufnr,
						}
					)
				end

				goto continue
			end

			if vim.tbl_contains(skip_mark, string.char(mark_to_insert)) then
				goto continue
			end

			row = vim.fn.line('.')
			col = vim.fn.col('.')

			vim.api.nvim_buf_set_mark(bufnr, string.char(mark_to_insert), row, col, {})

			if string.match(act, 'sort') then
				table.insert(items, {
						filename = vim.fn.expand('%:p'),
						text = vim.fn.getline(row),
						lnum = row,
						col = col,
						type = string.char(mark_to_insert),
						bufnr = bufnr,
					}
				)

				table.sort(items, function (a, b)
					return a.lnum < b.lnum
				end)

				local idx = 1
				for j = string.byte('a'), mark_to_insert, 1 do
					if not vim.tbl_contains(skip_mark, string.char(j)) then
						items[idx].type = string.char(j)
						vim.api.nvim_buf_set_mark(
							bufnr, string.char(j), items[idx].lnum, items[idx].col, {})
						idx = idx + 1
					end
				end
			end

			return
		elseif act == 'remove' then
			if (mark_empty == true) or (string.char(mark_to_insert) == 'z') then
				local delete_mark

				if (string.char(mark_to_insert) == 'a') or (string.char(mark_to_insert) == 'z' and mark_empty == false) then
					delete_mark = string.char(mark_to_insert)
				else
					delete_mark = string.char(mark_to_insert-1)
				end

				vim.api.nvim_buf_del_mark(bufnr, delete_mark)

				return
			end
		elseif act == 'clear' then
			if mark_empty == false then
				vim.api.nvim_buf_del_mark(bufnr, string.char(mark_to_insert))
			end
		else
			if mark_empty == true then
				goto continue
			end

			item = {
				filename = vim.fn.expand('%:p'),
				text = vim.fn.getline(row),
				lnum = row,
				col = col,
				type = string.char(mark_to_insert),
				bufnr = bufnr,
			}

			table.insert(items, item)
		end

		::continue::
	end

	if #items > 0 then
		if string.match(act, 'sort') then
			table.sort(items, function(a, b)
				return a.lnum < b.lnum
			end)
		end

		vim.fn.setqflist({}, ' ', { title = "buffer marks", items = items })
		vim.cmd("silent! copen")
	end
end

local function setup()
	return nil
end

return {
	Setup = setup,
	All = all_marks,
	Buffer = buffer_marks,
}
