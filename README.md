# Project: LDAP_Sort
## What does this achieve

- Sort LDAP file by uid in ascending or descending order
- Does not encounter memory leak error if file is too big

## Getting start

- Put powershell(.ps1) script and original ldif file into the same folder
- In command prompt run command below to generate a sorted ldif file
```cmd
$ powershell.exe LDAP_Sort.ps1 -1 "sss" -2 "sss" -3 "sss"
```

- In powershell prompt run command below to generate a sorted ldif file
```powershell
$ LDAP_Sort.ps1 -1 "sss" -2 "sss" -3 "sss"
```

## Notes

- Can only sort when uid is contained in dn attribute