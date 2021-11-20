Pro find_date, c, d, f, sho=sho, g, tot

c = SYSTIME(/SECONDS)
c += d * 86400.
f = SYSTIME(ELAPSED=c)
if keyword_set(sho) then g = BIN_DATE(f)
if keyword_set(g) then tot = STRTRIM(g[1], 2) + '/' + STRTRIM(g[2], 2) + '/' + STRTRIM(g[0], 2)
Stop
End
