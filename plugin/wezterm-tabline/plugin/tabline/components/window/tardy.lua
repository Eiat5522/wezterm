return {
  update = function(window)
    local meta = window:active_pane():get_metadata() or {}
    if not meta.is_tardy then
      return nil
    end

    local secs = (meta.since_last_response_ms or 0) / 1000.0
    return string.format('tardy: %5.1fs', secs)
  end,
}
