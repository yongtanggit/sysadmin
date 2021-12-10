def change_domain(email,old_domain,new_domain):
    if '@'+old_domain in email:
        index = email.index('@')
        email = email[:index]+'@' + new_domain
        return email

email = change_domain('yong@abc.com','abc.com','new.com' )
print(email)
