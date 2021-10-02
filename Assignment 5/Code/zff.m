%% ZFF


function zff(file)

close all;
Horizon=5;
flag=1;
[data, Fs] = audioread(file);

% Split the spech file --into signal and EGG.
sig=data(:,1);
egg=data(:,2);
egg=filter([1 -1],1,egg);
Lsig=length(sig);

% Mean-Frame length 
Horizon = Horizon*Fs/1000;

% Pre-Emphasis  of the signal 
a=1;
pre_emp_sig= filter([1, -a], 1, sig);

% Passing through cascaded Resonator.
x=cumtrapz(pre_emp_sig);
x=cumtrapz(x);
x=cumtrapz(x);
x=cumtrapz(x);

% Mean Trend Removal 

slice = 1:Horizon;
Nfr = floor(Lsig/Horizon);
out = zeros(size(sig));

for l=1:Nfr
    frame=sig(slice);
    out(slice)=frame-mean(frame);
    slice = slice+Horizon;
end

% Plotting .
if(flag)
    figure; 
      t=linspace(0,length(sig),length(sig));
      
      subplot(5,1,1)
      plot(t,sig);
      xlabel('Time');
      ylabel('Speech Frame'); 
      grid on;
      
      subplot(5,1,2)
      plot(t,pre_emp_sig);
      xlabel('Time');
      ylabel('Pre-Emphasis Speech Frame'); 
      grid on
    
           
      subplot(5,1,3)
      plot(t,x);
      xlabel('Time');
      ylabel('Integrated Signal(4)'); 
      grid on;
      
      
      subplot(5,1,4)
      plot(t,out);
      xlabel('Time');
      ylabel('Epoch Locations'); 
      grid on;
      
      subplot(5,1,5)
      plot(t,egg,'-');
      xlabel('Time');
      ylabel('EGG'); 
      grid on
      
      
end













