
#!/bin/bash
background=$(cat ~/.fehbg | grep "feh" | awk '{print $4}')
echo $background
background=${background:1:-1}
echo $background
feh --bg-fill "$background"
wal -i "$background" -q $1 --saturate 1.0
