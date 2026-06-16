-- lua/config/autocmds.lua – Autocommands and user commands

local fold_group = vim.api.nvim_create_augroup("TreesitterFolding", { clear = true })
vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufNewFile" }, {
	group = fold_group,
	callback = function()
		if vim.bo.buftype == "" and vim.bo.filetype ~= "" and vim.bo.filetype ~= "NvimTree" then
			vim.schedule(function()
				vim.opt_local.foldmethod = "expr"
				vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end)
		end
	end,
})

-- ProjectSwitch: safely switch CWD, reset LSP, open Telescope
vim.api.nvim_create_user_command("ProjectSwitch", function(opts)
	local path = vim.fn.fnamemodify(opts.args, ":p")

	if vim.fn.isdirectory(path) == 0 then
		print("󱇼 Error: Path is not a directory")
		return
	end

	-- Block if unsaved files exist (unless ! is used)
	if not opts.bang then
		local modified_files = {}
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if
				vim.api.nvim_get_option_value("modified", { buf = bufnr })
				and vim.api.nvim_buf_get_name(bufnr) ~= ""
			then
				table.insert(modified_files, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t"))
			end
		end

		if #modified_files > 0 then
			print(" Unsaved changes in: " .. table.concat(modified_files, ", ") .. " (Use ! to force)")
			return
		end
	end

	vim.cmd("silent! %bd")
	vim.api.nvim_set_current_dir(path)

	-- Hard reset all LSP clients so new project config is picked up
	for _, client in pairs(vim.lsp.get_clients()) do
		vim.lsp.stop_client(client.id, true)
	end

	vim.schedule(function()
		require("telescope.builtin").find_files()
	end)

	print(" Switched to: " .. path)
end, {
	nargs = 1,
	complete = "dir",
	bang = true,
})
