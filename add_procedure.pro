Pro add_procedure, a, b, c,pr_val=pr_val, d=d

c=a+b


if keyword_set(d) then c=a+b+d
if keyword_set(pr_val) then print, c
d='A keyword can both pass data in and out'
End