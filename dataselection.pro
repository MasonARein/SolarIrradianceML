Pro dataSelection

restore,'/Users/lokidog/idl/data/flare_data/flare_data_13.sav'

temp = data.Tem
ind = where(temp lt 100)
tempClean = temp[ind]
time = data.Tarray[ind]
emission = data.Em[ind]

shortBand = data.Yclean[ind,0]
longBand = data.Yclean[ind,1]
timeBand = data.Tarray[ind]


plot, time, tempClean, title='pick start'

cursor, t1, y1,/up

plot, time, tempClean, title='pick stop'

cursor, t2, y2,/up

lessT = where(time lt t2)

removePreData = time[lessT]

selectedData = where(removePreData gt t1)

tempSelected = tempClean[selectedData]

timeSelected = time[selectedData]

maxEm = MAX(emission[selectedData])

shortBandMax = MAX(shortBand[selectedData])

longBandMax = MAX(longBand[selectedData])

maxTemp = MAX(tempSelected, location)-tempSelected[0]

maxTime = timeSelected[location]

coolTemp = maxTemp/exp(1) + tempSelected[0]

print, coolTemp

plot, timeSelected, tempSelected, title='pick start of cool point'

cursor, t3, y3,/up

plot, timeSelected, tempSelected, title='pick stop of cool point'

cursor, t4, y4,/up

beforeCool = where(time lt t4)

removeOtherCool = time[beforeCool]

selectedCoolPoint = where(removeOtherCool gt t3)

coolTempSelected = tempClean[selectedCoolPoint]

coolTimeSelected = time[selectedCoolPoint]

aboveCoolingConstant = where(coolTempSelected ge coolTemp)

aCCTime = coolTimeSelected[aboveCoolingConstant]

aCCTemp = coolTempSelected[aboveCoolingConstant]

CoolingConstantTime = aCCTime[-1]

CoolingConstant = CoolingConstantTime-maxTime

print, CoolingConstant

print, maxTemp

print, shortBandMax

print, longBandMax

print, maxEm

e = PLOT(time, emission)

aCC = PLOT(aCCTime, aCCTemp)

select = PLOT(timeSelected, tempSelected)

s = PLOT(timeBand, shortBand)

l = PLOT(timeBand, longBand)

End