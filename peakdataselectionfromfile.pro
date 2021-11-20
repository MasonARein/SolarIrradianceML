Pro peakDataSelectionFromFile, numberOfFiles
    restore, '/Users/lokidog/idl/data/flare_event_list.sav'
    fnames=file_search('/Users/lokidog/idl/data/flare_data/flare_data_*')    
    flare_param_automation='/Users/lokidog/idl/data/flare_param_automation.sav'
    
    numOfFile = numberOfFiles
    
    max_temp_array=[]
    max_irr_array=[]
    max_em_array=[]
    time_constant_array=[]
    density_peak_array=[]
    flare_date_array=['']
    
    for fileNumber = 0, numOfFile-1 do begin
    restore, fnames[fileNumber]
    
    
    temp = data.Tem
    
    catch, error_status
    IF Error_status eq 0 THEN BEGIN
    ind = where(temp lt 100)
    tempClean = temp[ind]
    time = data.Tarray[ind]
    emission = data.Em[ind]
    date_collected = data.utbase
    print, data.utbase

    shortBand = data.Yclean[ind,1]
    longBand = data.Yclean[ind,0]
    timeBand = data.Tarray[ind]
    
    mClassPoints = []
    startInFile = []
    fileStart = date_conv(data.utbase, 'R')
    fileEnd = date_conv(data.utbase, 'R') + data.tarray[-1]/8.64e4
    
    for nd=0, n_elements(gev)-1 do begin
      currentStart = date_conv(gev[nd].gstart, 'R')
      currentVal = gev[nd].class
      if currentStart ge fileStart and currentStart le fileEnd and currentVal ge 1e-5 then begin
        startInFile = [startInFile, nd]
      end
    end
    
    for exd=0, n_elements(startInFile)-1 do begin
      
      maxTempPoint = []
      
      currentT2 = (date_conv(gev[startInFile[exd]].gend, 'R') - fileStart) * 8.64e4
      
      currentT1 = (date_conv(gev[startInFile[exd]].gstart, 'R') - fileStart) * 8.64e4
      
      currentGev = gev[startInFile[exd]]
      
      peakTime = (date_conv(currentGev.gpeak, 'R') - fileStart)* 8.64e4
       
      selectedData = where(timeBand[where(timeBand lt currentT2)] gt currentT1)
      
      irrSelected = longBand[selectedData]

      tempSelected = tempClean[selectedData]
      
      reverseTempSelected = smooth(reverse(tempSelected), 10)

      timeSelected = timeBand[selectedData]

      maxEm = MAX(emission[selectedData])

      shortBandMax = MAX(shortBand[selectedData])

      longBandMax = MAX(longBand[selectedData], location)

      maxTemp = MAX(tempSelected[selectedData], loca)
      
      maxTempTime = timeSelected[loca]

      maxIrradiance = timeSelected[location]
      
      maxRev = max(reverseTempSelected[*], revPoint)
      
      segmentForXPoly = timeSelected[-revPoint:-1]
      
      segmentForYPoly = tempSelected[-revPoint:-1]
      
      if revPoint ne 0 then begin
      
      result = POLY_FIT(segmentForXPoly, alog(segmentForYPoly), 1, MEASURE_ERRORS=measure_errors, $
      SIGMA=sigma)

        CoolingConstant = (-1./result[1])

        densityPeak = (3*1.380649e-16*(maxTemp*1e6)^(5./3.)*10^(17.73))/(2.*CoolingConstant)
        
        max_temp_array=[max_temp_array,maxTemp]
        max_irr_array=[max_irr_array,longBandMax]
        max_em_array=[max_em_array,maxEm]
        time_constant_array=[time_constant_array,CoolingConstant]
        density_peak_array=[density_peak_array, densityPeak]
        flare_date_array=[flare_date_array, date_collected]
        
        save,max_temp_array,max_irr_array,max_em_array,time_constant_array,density_peak_array,$
          filename=flare_param_automation
    end
    end
    end
    end

End