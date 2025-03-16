string=$(cat ~/.fehbg | awk '{print $4}')
string2=${string//\'/}  # Remove any single quotes
echo $string2

