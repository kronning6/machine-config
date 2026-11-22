local prefix = 'ctrl+space>'

rex.bind(prefix .. 'ctrl+space', 'pane.send_key', { key = 'ctrl+space' })
rex.bind(prefix .. 'ctrl+k', 'pane.send_key', { key = 'ctrl+k' })
rex.bind(prefix .. 'ctrl+l', 'pane.send_key', { key = 'ctrl+l' })

rex.bind(prefix .. '-', 'pane.split', { direction = 'down' })
rex.bind(prefix .. 'shift+\\', 'pane.split', { direction = 'right' }) -- | on a US layout
rex.bind(prefix .. 'z', 'pane.zoom')

-- Quick resize with the prefix, or enter an explicit mode for several steps.
-- Rex measures each step as a percentage of the split, not terminal cells.
rex.mode('resize', { exclusive = true })
rex.bind(prefix .. 'r', 'client.mode.enter', { name = 'resize' })
rex.bind('resize/enter', 'client.mode.exit') -- Esc also exits
for key, direction in pairs { h = 'left', j = 'down', k = 'up', l = 'right' } do
  local args = { direction = direction, amount = 5 }
  rex.bind(prefix .. key, 'pane.resize', args)
  rex.bind('resize/' .. key, 'pane.resize', args)
end

-- A tmux window corresponds to a Rex tab, not a macOS window.
rex.bind('alt+h', 'client.tab.previous')
rex.bind('alt+l', 'client.tab.next')
for index = 1, 9 do
  rex.bind(prefix .. ('[Digit%d]'):format(index), 'client.tab.goto', { index = index })
end
rex.bind(prefix .. 'shift+s', 'session.switch')

-- Load the Rex half of the plugin installed by lazy.nvim.
local data = os.getenv 'XDG_DATA_HOME' or (os.getenv 'HOME' .. '/.local/share')
local ok, err = pcall(function()
  dofile(data .. '/nvim/lazy/rex-navigator.nvim/rex/navigator.lua').setup()
end)
if not ok then
  rex.log('warn', 'rex-navigator not loaded: ' .. tostring(err))
end
