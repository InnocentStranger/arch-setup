-- modules/programs.lua

return {
  terminal = "uwsm app -- kitty",
  app_launcher = "nc -U /run/user/1000/walker/walker.sock",
  clipboard = "walker -m clipboard",
  lock_screen = "loginctl lock-session",
}
