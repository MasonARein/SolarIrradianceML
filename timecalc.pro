Pro timeCalc

restore,'/Users/lokidog/idl/data/flare_15Feb2011.sav'

temp = data.Tem
ind = where(temp lt 100)
tempClean = temp[ind]
time = data.Tarray[ind]
emission = data.Em[ind]
date_collected = data.utbase
print, data.utbase

shortBand = data.Yclean[ind,1]
longBand = data.Yclean[ind,0]
timeBand = data.Tarray[ind]


plot, timeBand, longBand, title='pick start', charSize = 1.8

threshold = timeBand

threshold[*] = 1e-5

oplot, timeBand, threshold, linestyle = 2

cursor, t1, y1,/up

plot, timeBand, longBand, title='pick stop', charSize = 1.8

oplot, timeBand, threshold, linestyle = 2

cursor, t2, y2,/up

selectedData = where(timeBand[where(timeBand lt t2)] gt t1)

tempSelected = tempClean[selectedData]

timeSelected = timeBand[selectedData]

maxEm = MAX(emission[selectedData])

shortBandMax = MAX(shortBand[selectedData])

longBandMax = MAX(longBand[selectedData], location)

maxTemp = MAX(tempSelected)

maxIrradiance = timeSelected[location]

plot, timeSelected, tempSelected, title='pick intial point'

cursor, t3, y3,/up

plot, timeSelected, tempSelected, title='pick second point'

cursor, t4, y4,/up

  selectedDecay = where(time[where(time lt t4)] gt t3)

  decayTempSelected = tempClean[selectedDecay]

  firstTemp = decayTempSelected[0]

  secondTemp = decayTempSelected[-1]


  CoolingConstant = -(t4-t3)/alog(secondTemp/firstTemp)

  print, CoolingConstant

  densityPeak = (3*1.380649e-16*(maxTemp*1e6)^(5./3.)*10^(17.73))/(2.*CoolingConstant)

  print, densityPeak


End