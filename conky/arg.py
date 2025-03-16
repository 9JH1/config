summary = "1"
time = "2"
example = "3"
arg="Next Event {summary}, at {time}, with {example}"
format_list = [] 
for item in arg.split("{"):
    if item.replace("}","") != item:format_list.append(item.split("}")[0]);

for item in format_list:
    arg = arg.replace("{"+item+"}","{}")

# reconstruct list
format_string = f"format({str(format_list).replace('[','').replace(']','').replace('\'','')})"
format_string = f"\"{arg}\".{format_string}"
print(eval(format_string))
