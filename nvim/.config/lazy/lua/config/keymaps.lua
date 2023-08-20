local function map(mode, lhs, rhs, opts) 
	-- local keys = require('lazy.core.handler').handlers.keys
	-- if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		if opts.remap and not vim.g.vscode then
			opts.remap = nil
		end
		vim.keymap.set(mode, lhs, rhs, opts)
	-- end
end

-- tabs
map('n', ']r', '<cmd>tabnext<cr>')
map('n', '[r', '<cmd>tabprev<cr>')
map('n', ']R', '<cmd>tablast<cr>')
map('n', '[R', '<cmd>tabfirst<cr>')
map('n', '<leader>R', '<cmd>tabnew<cr>')

map('n', '<leader>hs', '<cmd>split<space>')
map('n', '<leader>vs', '<cmd>vsplit<space>')

-- windows
map('n', '<tab>l', '<c-w><c-l>', { remap = true })
map('n', '<tab>h', '<c-w><c-h>', { remap = true })
map('n', '<tab>k', '<c-w><c-k>', { remap = true })
map('n', '<tab>j', '<c-w><c-j>', { remap = true })

-- buffers
map('n', '<tab>n', '<cmd>bnext<cr>')
map('n', '<tab>p', '<cmd>bprevious<cr>')
map('n', '<leader>bl', '<cmd>ls<cr><cmd>b<space>')

map('i', '<m-e>', '<end>', { desc = 'Go to end of word' })
map('n', 'Y', 'y$', { desc = 'Yank whole line' })

map('n', 'n', 'nzzzv', { desc = 'Keep jumps centered' })
map('n', 'N', 'Nzzzv', { desc = 'Keep jumps centered' })
map('n', 'J', 'mzJ`z', { desc = 'Keep jumps centered' })
map('n', '<leader>I', '<cmd>setlocal autoindent!<cr>', { desc = 'Toggle autoindent' })

map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
-- map('n', '<leader><Space>', '<cmd>noh <cr>', { desc = 'Toggle autoindent' })

-- Press * to search for the term under the cursor or a visual selection and
-- then press a key below to replace all instances of it in the current file. 
map('n', '<leader>r', ':%s///g<Left><Left>')
map('n', '<leader>rc', ':%s///gc<Left><Left><Left>')

 -- The same as above but instead of acting on the whole file it will be
 -- restricted to the previously visually selected range. You can do that by
 -- pressing *, visually selecting the range you want it to apply to and then
-- press a key below to replace all instances of it in the current selection. 
map('x', '<leader>r', ':s///g<Left><Left>')
map('x', '<leader>rc', ':s///gc<Left><Left><Left>')
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

map("v", "K", ":m '<-2<cr>gv=gv")
map("v", "J", ":m '>+1<cr>gv=gv")
