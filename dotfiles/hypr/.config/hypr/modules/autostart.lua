hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- /usr/bin/elephant")
  hl.exec_cmd("uwsm app -- /usr/bin/walker --gapplication-service")
end)
