Pro  mason_sample_loop

  fnames=file_search('$idl_code/flare_thermal_study/mason_rein/data/flare_data_*') ;this will get an array of filenames to be analyzed

  
  flare_param_path='$idl_code/flare_thermal_study/mason_rein/data/flare_params.sav' ;this is where analyzed values will be stored

  for nn=0,n_elements(fnames)-1 do begin

     if nn eq 0 then begin ; for first iteration need to find place to store values

        ;check to see if file exists, if so, open and append values
        store_name=file_search(flare_param_path,count=count_val)
        if count_val ne 0 then begin
           restore, store_name[0]
           print,'FOUND EXISTING FILE. APPENDING NEW VALUES TO IT.'
        endif else begin
           ;if file does not exist, define new variables to store values
           max_temp_array=[]
           max_irr_array=[]
           max_em_array=[]
           time_constant_array=[]
           ;add others that you might need

        end

     end

     restore,fnames[nn] ;this opens flare data for a single day



     ;***********put your code here to use a gui to retrieve flare values**************



     new_max_temp=-1 ; replace with your result
     new_max_irr=-1 ; your result
     new_max_em=-1 ;replace with your result
     new_time_constant=-1 ;replace with your result
;expand as needed to include additional variables you want to keep
;track off


     ;store your values to an array of values
     max_temp_array=[max_temp_array,new_max_temp]
     max_irr_array=[max_irr_array,new_max_irr]
     max_em_array=[max_em_array,new_max_em]
     time_constant_array=[time_constant_array,new_time_constant]


;save work every iteration to allow you to stop and
;restart, or protect you from IDL crashing.
     save,max_temp_array,max_irr_array,max_em_array,time_constant_array,$ ;dollar sign allows you to continue to next line
          filename=flare_param_path

stop
  end


End
