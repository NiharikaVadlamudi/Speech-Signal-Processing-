% File for Prosody Extraction .
% Input : Audio File , Contour Pitch Listing (Praat/Wavesurfer)


function prosody(fileName)
    % Read file 
    close all;
    flag=1;
    [data, fs] = audioread(fileName);
    info=audioinfo(fileName);
    
    data=data(:,1);
    
    % Generate F0 --pitch contour 
    f0 = pitch(data,fs);
    pitchLen=length(f0);
    [Fp,I] = max(f0);
    Fs=f0(2);
    Fe=f0(pitchLen-1);
   
    % Intonations   
    % Amplitude Tilt Calcualtions 
    Ar=abs(Fp-Fs);
    Af=abs(Fp+Fe);
    A=(Ar-Af/Ar+Af);
    
    % Duration Tilt 
    % Between the start and peak 
    Dr=abs(I+1);
    Df=abs(pitchLen-I);
    D=Dr-Df/Dr+Df;
    
    %Distance of F0 Peak wrt VOP
    Distance_F0_VOP=Dr;
  
    %Change in F0
    F0_delta=Fp-Fe;
    
    % Rhytm
    duration_voice=info.Duration;
    %  Stress
    log_energy=20*log(data.^2);
    change_log_energy=max(log_energy)-min(log_energy);    
    % Plots
    
    if(flag)
      t=linspace(0,length(data),length(data));
      
      subplot(2,1,1)
      plot(t,data);
      xlabel('Time');
      ylabel('Speech Frame'); 
      grid on;
         
      subplot(2,1,2)
      plot(f0);
      xlabel('Time');
      ylabel('Pitch of Speech Frame'); 
      grid on
      
    end
  
    % Print Out 
    fprintf('\n')
    fprintf('Intonation Features : \n')
    
    fprintf('Amplitude Tilt (A): %f\n',A)
    fprintf('Duration Tilt (D) : %f\n',D)
    fprintf('Distance of F0 wrt VOP: %f\n',Distance_F0_VOP)
    fprintf('Change in F0 : %f\n',F0_delta)
    
    fprintf('\n')
    
    fprintf('Rhytm Features : \n')
   
    fprintf('Duration of Region : %f\n',duration_voice)
    fprintf('Change in FO : %f\n',F0_delta)
    
    fprintf('\n')
    
    fprintf('Stress Features : \n')
    
    fprintf('Change in Log-Energy : %f\n',change_log_energy)
    fprintf('Duration of Region : %f\n',duration_voice)    
    
end
