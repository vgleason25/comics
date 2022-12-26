value = "No. 5"

if value == None: #if nothing is entered in issue 
    print(None)
    #return value

elif value.isdecimal(): #will only work if there is a single number, no commas or letters
    print(value)
    #return value

elif "N" in value[:1] or "n" in value[:1]: #will work if the seller wrote something that starts with a letter in the issue section 
    if "," not in value and "-" not in value and "&" not in value and "/" not in value: #this means a lot is being listed with more than one issue
        result = ''
        for char in value:
            if char in '1234567890':
                result += char
        print(result)
        
    else:
        print(8888)

elif value[:1].isalpha(): #will work if the seller wrote something that starts with a letter in the issue section 
    print("is alpha")
    #return None

elif "," in value or "-" in value or "&" in value or " " in value or "/" in value: #this means a lot is being listed with more than one issue
    print(9999)
    #return "9999"
else: #this will strip out any letters or symbols
    result = ''
    for char in value:
        if char in '1234567890':
            result += char
    print(result)
    #return result 