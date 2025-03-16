win_id=$(xdotool getwindowfocus)
pid=$(xprop -id "$win_id" -NET_WM_PID | awk '{print $3}')
if [ -n "$pid" ]; then
	kill -9 "$pid"
fi
