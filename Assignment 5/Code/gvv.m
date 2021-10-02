% This code is for computing the GVV of a signal . 
% Input : FileName 
% Output : plots-- Speech Frame , LP Residual , GVV Waveform . 

function gvv(file)
    
    close all ;

    flag=1;

    [data, Fs] = audioread(file);
    
    sig=data(:,1);
    egg=data(:,2);
    
    % Pre-emphasis of signal 
    a=1;
    pre_sig=filter([1, -a], 1, sig);

    Lsig = length(sig);
    OrderLPC =24;   %order of LPC
    out = zeros(size(sig)); % initialization

    Win = hanning(Lsig);  % analysis windo
    sigLPC = Win.*pre_sig;
    en = sum(sigLPC.^2); % get the short - term energy of the input

    % LPC analysis
    r =  xcorr(sigLPC); % correlation
    r = r./max(abs(r));
    [a,g]=lpc(sigLPC,OrderLPC);% LPC coef.
    G = 1 ;% gain
    ex = filter([0 -1*a(2:end)],1,sigLPC); % inverse filter
    % LP Residual Part 
    lp_res=sigLPC-ex;

    % GVV Computation 
    gvv_sig=cumtrapz(lp_res);
    
    if(flag)
         figure; 
          t=linspace(0,length(sig),length(sig));
          subplot(5,1,1)
          plot(t,sig);
          xlabel('Time');
          ylabel('Speech Frame'); 
          grid on;
          
          subplot(5,1,2)
          plot(t,pre_sig);
          xlabel('Time');
          ylabel('Pre - Emphaisis of Speech Frame'); 
          grid on;

          subplot(5,1,3)
          plot(t,lp_res);
          xlabel('Time');
          ylabel('LP Residual'); 
          grid on;

          subplot(5,1,4)
          plot(t,gvv_sig);
          xlabel('Time');
          ylabel('GVV of Speech Frame'); 
          grid on;
          
          
          subplot(5,1,5)
          plot(t,egg);
          xlabel('Time');
          ylabel('Ground Truth - EGG'); 
          grid on;
          

    end


end