# Project: LDAP_Sort
## What does this achieve

- Sort LDAP file by uid in ascending or descending order(ASCII)
- Does not encounter memory leak error if file is too big

## Getting start

- Put Powershell(.ps1) script and original ldif file into the same folder
- Open command prompt or Powershell prompt on the same folder
- In command prompt run command below to generate an ascending sorted ldif file
```cmd
Powershell.exe ".\LDAP_Sort.ps1" -srcLDAPFile ".\example.ldif" -resultLDAPFile ".\sorted.ldif" -order "0"
```
- In command prompt run command below to generate a descending sorted ldif file
```cmd
Powershell.exe ".\LDAP_Sort.ps1" -srcLDAPFile ".\example.ldif" -resultLDAPFile ".\sorted.ldif" -order "1"
```

## Notes

- Can only sort when uid is contained in dn attribute like this
```cmd
dn: uid=jsmith1,ou=People,dc=example,dc=com
```