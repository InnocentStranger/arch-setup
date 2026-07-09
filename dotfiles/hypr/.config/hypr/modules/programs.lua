-- modules/programs.lua

return {
  terminal = "uwsm app -- kitty",
  app_launcher = "nc -U /run/user/1000/walker/walker.sock",
  clipboard = "walker -m clipboard",
  lock_screen = "loginctl lock-session",
  -- logout = 'loginctl terminate-user ""'
  -- or 'loginctl terminate-session "$XDG_SESSION_ID"', -- kills all session, good reset
  logout = "uwsm stop", -- good for clean shutdown
}
