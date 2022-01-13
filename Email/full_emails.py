def full_emails(people): # people = [("john@example.com","John Smith"),("..","..")]
    emails_list = []
    for email,name in people:
        emails_list.append("{} <{}>".format(name,email))
    return emails_list


# Usage:
# print(full_emails([("john@example.com","John Smith")]))
# ['John Smith <john@example.com>']