Pro flare_data_exponent_loop

  fnames=file_search('/Users/lokidog/idl/data/flare_data/flare_data_*')

  flare_param_path='/Users/lokidog/idl/data/flare_params.sav'

  for nn=0,n_elements(fnames)-1 do begin

    if nn eq 0 then begin

      store_name=file_search(flare_param_path,count=count_val)
      if count_val ne 0 then begin 
        restore, store_name[0]
        print,'FOUND EXISTING FILE. APPENDING NEW VALUES TO IT.'
      endif
        max_temp_array=[]
        max_irr_array=[]
        max_em_array=[]
        time_constant_array=[]
        density_peak_array=[]
        flare_date_array=['']
        ;add others that you might need


    end

    restore,fnames[nn]
    sz=size(data)
    if sz[0] eq 0 then continue

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
    
    if t4 gt t3 then begin
    
    selectedDecay = where(time[where(time lt t4)] gt t3)
    
    decayTempSelected = tempClean[selectedDecay]
    
    firstTemp = decayTempSelected[0]
    
    secondTemp = decayTempSelected[-1]


      CoolingConstant = -(t4-t3)/alog(secondTemp/firstTemp)
      
      print, CoolingConstant
      
      densityPeak = (3*1.380649e-16*(maxTemp*1e6)^(5./3.)*10^(17.73))/(2.*CoolingConstant)
      
      print, densityPeak

      new_time_constant=CoolingConstant
      new_max_temp=maxTemp
      new_max_irr=longBandMax
      new_max_em=maxEm
      new_density_peak = densityPeak
      new_date = date_collected
      ;expand as needed to include additional variables you want to keep
      ;track off

      max_temp_array=[max_temp_array,new_max_temp]
      max_irr_array=[max_irr_array,new_max_irr]
      max_em_array=[max_em_array,new_max_em]
      time_constant_array=[time_constant_array,new_time_constant]
      density_peak_array=[density_peak_array, new_density_peak]
      flare_date_array=[flare_date_array, new_date]
      print, "collected"

      ;save work every iteration to allow you to stop and
      ;restart, or protect you from IDL crashing.
      save,max_temp_array,max_irr_array,max_em_array,time_constant_array,density_peak_array,$ ;dollar sign allows you to continue to next line
        filename=flare_param_path
        
      end

    stop
  endfor

End