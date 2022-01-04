# Create a file

guests_name = ['Bob','Andrea','Manuel','Polly',"Khalid"]

guests = open('guests.txt','w')
for i in guests_name:
    guests.write(i + '\n')
guests.close()
guests = open('guests.txt','r')
#print(guests.read())
guests.close()



check_in = ['sam','Danielle','Jacob']

with open('guests.txt','a') as guests:
    for i in check_in:
        guests.write(i + '\n')
#with open('guests.txt','r') as guests:
    #   print(guests.read())

check_out = ['Andrea','Manuel','Khalid']

tmp_list = []

with open('guests.txt','r') as guests:
    for i in guests.readlines():
        tmp_list.append(i.strip())

with open('guests.txt','w') as guests:
    for i in tmp_list:
        if i not in check_in:
            guests.write(i + '\n')


with open('guests.txt','r') as guests:
    print(guests.read())

name = input("name: ")
not_check = ''
with open('guests.txt','r') as guests:
    for i in guests:
        if name == i.strip():
           print("{} is checked in.".format(name))
           not_check = False
           break
        else:
            not_check = True
    if not_check:
        print("{} is not checked in.".format(name))

