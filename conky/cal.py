import icalendar
from datetime import datetime
import pytz
from sys import argv
verbose=0
def help():
    if verbose==1:
        print("running start info")
    print(f"USAGE: \"{__file__}\" [OPTIONS]")
    print(" --ics     -c <str>   | set iCal file")
    print(" --index   -i <int>   | set event depth eg index=1 means it will show you the closest event and index=2 shows you the second closest event")
    print(" --text    -t <str>   | set the text thats showen at the start of the output")
    print(" --verbose -v         | enable verbose debug logs")
    print(" --format  -f <str>   | set the format of the final string. by default this is:\n\"{location} in {time_till_hours}\"")
    print("FORMAT CODES:")
    print("time_till_start       | time until event (:mm)")
    print("time_till_start_hours | time until event (hh:mm)")
    print("time_duration         | length of event (:mm)")
    print("time_duration_hours   | length of event (hh:mm)")
    print("index                 | index given in --index or -i argument")
    print("text                  | text given in --text or -t  argument")
    print("any of the ics files information can be referenced")
    print("eg: using \"location\" will get the events LOCATION var this works for all keys")
    print("GENERIC KEYS:")
    print("location              | event.LOCATION")
    print("description           | event.DESCRIPTION")
    print("summary               | event.SUMMARY")
    print("sequence              | event.SEQUENCE")
    print("uid                   | event.UID")
    print("created               | event.CREATED")
    exit(1)


if len(argv)==1:
    help()

text="Next Event: "
format_string=""
file = ""
index=1;
format_list=""
try:
    for argc in range(len(argv)):
        arg = argv[argc]
        if arg == "--ics" or arg == "-c":
            file = argv[argc+1]
        elif arg == "--index" or arg == "-i":
            index = int(argv[argc+1])
        elif arg == "--text" or arg == "-t":
            text = argv[argc+1]
        elif arg == "--verbose" or arg == "-v":
            print("verbose enabled!")
            verbose=1
        elif arg == "--format" or arg == "-f":
            format_string = argv[argc+1]
except:
    help()

# format the string into a list of arguments
for item in format_string.split("{"):
    if item.replace("}","") != item:format_list.append(item.split("}")[0]);

for item in format_list:
    format_string = format_string.replace("{"+item+"}","{}")

format_string_final = f"format({str(format_list).replace('[','').replace(']','').replace('\'','')})"
format_string_final = f"\"{format_string}\".{format_string}"
def get_string_final():
    return eval(format_string_final)

if file=="":
    help()


def min_to_hours(value):
    hours  = value//60
    minutes = value%60
    if hours>0:
        return f'{int(hours)}:{int(minutes):02}'
    return f'{int(minutes):02} mins'


def compare_time(date1,date2):
    date_format = "%Y-%m-%d %H:%M:%S%z"
    datetime1 = datetime.strptime(date1, date_format)
    datetime2 = datetime.strptime(date2, date_format)
    time_difference = datetime2 - datetime1
    minutes_difference = time_difference.total_seconds() / 60
    return minutes_difference

next_vevent = {}
lowest_tmp = 1000*10000
now = datetime.now(pytz.UTC)
formatted_time = now.strftime('%Y-%m-%d %H:%M:%S%z')
formatted_time_with_offset = formatted_time[:-2] + ":" + formatted_time[-2:]
e=""
try:
    e = open(file,'rb')
except Exception as err:
    print(str(err))
now = formatted_time_with_offset
ecal = icalendar.Calendar.from_ical(e.read())
ecal_list = []
for component in ecal.walk():
    ecal_list.append(component);
    
#ecal_list.reverse()
for component in ecal_list:
    if component.name == "VEVENT":
        time_start = component.decoded("dtstart")
        time_till = compare_time(str(now),str(time_start))
        if not str(time_till).startswith("-"):
            if time_till < lowest_tmp:
                if verbose==1:
                    print("Time matches all prams: "+ str(time_till) + "RAW_DATA:",str(component))
                if index==1:
                    lowest_tmp = time_till
                    next_vevent["transit"]  = time_till
                    next_vevent["end"] = component.decoded("dtend")
                    next_vevent["length"]   = compare_time(str(time_start),str(next_vevent["end"]))
                    next_vevent["location"] = component.get("location")
                    next_vevent["teacher"]  = component.get("description")
                    next_vevent["course"]   = component.get("summary")
                    #find the class that has the SECOND lowest ct
                    #that does not include negative numbers
                    """
                    for item in format_list:
                        if not str(item) in ["time_till_start",
                                             "time_till_start_hours",
                                             "time_duration",
                                             "time_duration_hours",
                                             "time_start",
                                             "time_end",
                                             "arg_index",
                                             "arg_text",
                                             ]:
                            next_vevent[str(item)] = component.get(str(item))

                    break
                    """
                else:
                    index=index-1
                    if verbose==1:
                        print("skipped: ",component.get("location"),". Index now: ",index)
    elif verbose==1:
        print("Ignored component: " + component.name)
# next_vevent is the dict use whatever format you want this one is compact basic
print(f"{text}{next_vevent["course"].split(" ")[0]} @ {next_vevent["location"]}, With {next_vevent["teacher"]} in {min_to_hours(next_vevent["transit"])}, for {min_to_hours(next_vevent["length"])}")
e.close()
