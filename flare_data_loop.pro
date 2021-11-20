Pro flare_data_loop

fnames=file_search('/Users/lokidog/idl/data/flare_data/flare_data_*')

flare_param_path='/Users/lokidog/idl/data/flare_params.sav'

for nn=0,n_elements(fnames)-1 do begin
  
  if nn eq 0 then begin 

    store_name=file_search(flare_param_path,count=count_val)
    if count_val ne 0 then begin
      restore, store_name[0]
      print,'FOUND EXISTING FILE. APPENDING NEW VALUES TO IT.'
    endif else begin
      max_temp_array=[]
      max_irr_array=[]
      max_em_array=[]
      time_constant_array=[]
      ;add others that you might need

    end

  end

  restore,fnames[nn] 

  print, nn
  temp = data.Tem;
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

  selectedData = where(time[where(time lt t2)] gt t1)

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

  selectedCoolPoint = where(time[where(time lt t4)] gt t3)

  coolTempSelected = tempClean[selectedCoolPoint]

  coolTimeSelected = time[selectedCoolPoint]
  
  if Min(coolTempSelected) lt coolTemp then begin

  aboveCoolingConstant = where(coolTempSelected ge coolTemp)

  aCCTime = coolTimeSelected[aboveCoolingConstant]

  aCCTemp = coolTempSelected[aboveCoolingConstant]

  CoolingConstantTime = aCCTime[-1]

  CoolingConstant = CoolingConstantTime-maxTime
  
  new_time_constant=CoolingConstant
 
  

  new_max_temp=maxTemp
  new_max_irr=longBandMax
  new_max_em=maxEm
  ;expand as needed to include additional variables you want to keep
  ;track off

  max_temp_array=[max_temp_array,new_max_temp]
  max_irr_array=[max_irr_array,new_max_irr]
  max_em_array=[max_em_array,new_max_em]
  time_constant_array=[time_constant_array,new_time_constant]
  print, "collected"


  ;save work every iteration to allow you to stop and
  ;restart, or protect you from IDL crashing.
  save,max_temp_array,max_irr_array,max_em_array,time_constant_array,$ ;dollar sign allows you to continue to next line
    filename=flare_param_path
    
  end

  stop
endfor

End