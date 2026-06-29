local wezterm = require('wezterm')

return {
  update = function(window, opts)
    local agent_deck = opts.agent_deck
    if not agent_deck or not agent_deck.update_right_status then
      return nil
    end

    local ok, items = pcall(agent_deck.update_right_status, window, window:active_pane())
    if not ok then
      wezterm.log_warn('Failed to update agent deck status: ' .. tostring(items))
      return nil
    end

    if not items or #items == 0 then
      return nil
    end

    return wezterm.format(items)
  end,
}
