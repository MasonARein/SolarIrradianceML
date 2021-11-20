Pro selection_by_date_flare_collection, selectedIndex
    restore, '/Users/lokidog/idl/data/flare_event_list.sav'
    fnames=file_search('/Users/lokidog/idl/data/flare_data/flare_data_*')
    selectedStartFrame = gev[selectedIndex].gstart
    indexPoint = 0
    for nn=0,n_elements(fnames)-1 do begin
      restore, fnames[nn]
      sz=size(data)
      if sz[0] eq 0 then continue
      convertedFileStart = date_conv(data.utbase, 'R')
      convertedFlareStart = date_conv(selectedStartFrame, 'R')
      
      if convertedFileStart le convertedFlareStart and convertedFileStart+data.tarray[-1]/8.64e4 ge convertedFlareStart then begin
        indexPoint = nn
      end
    end
    restore, fnames[indexPoint]
    selectedEndFrame = gev[selectedIndex].gend
    print, nn
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
    
    if ((date_conv(selectedEndFrame, 'R')-date_conv(date_collected, 'R'))*8.64e4) lt timeband[-1] then begin
    
    timeBand = timeBand[where(timeBand lt (date_conv(selectedEndFrame, 'R')-date_conv(date_collected, 'R'))*8.64e4)]
    
    end

    selectedData = where(timeBand gt (date_conv(selectedStartFrame, 'R')-date_conv(date_collected, 'R'))*8.64e4)

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

    if t4 gt t3 then begin

      selectedDecay = where(time[where(time lt t4)] gt t3)

      decayTempSelected = tempClean[selectedDecay]

      firstTemp = decayTempSelected[0]

      secondTemp = decayTempSelected[-1]


      CoolingConstant = -(t4-t3)/alog(secondTemp/firstTemp)

      print, CoolingConstant

      densityPeak = (3*1.380649e-16*(maxTemp*1e6)^(5./3.)*10^(17.73))/(2.*CoolingConstant)

      print, densityPeak
      end
End
