-- modules/programs.lua

return {
  terminal = "uwsm app -- kitty",
  files = "uwsm app -- nautilus",
  app_launcher = "nc -U /run/user/1000/walker/walker.sock",
  clipboard = "walker -m clipboard",
  lock_screen = "loginctl lock-session",
  -- logout = 'loginctl terminate-user ""'
  -- or 'loginctl terminate-session "$XDG_SESSION_ID"', -- kills all session, good reset
  logout = 'zenity --question --title="Log Out" --window-icon="system-log-out" --text="Are you sure you want to log out of your session?" --default-cancel && uwsm stop',
}
