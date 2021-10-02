% CODE DESCRIPTION 
% Pitch Estimation using LPC analysis 
% Input : file.wav (in current directory)
% Output : Graphs - (Speech Frame,Reconstructed Speech Frame,LP Residual , Autocorellated LP Residual)
function pitch=pitch_estimation(fileName)
% Read the file ,and output details of the file . 
[data,fs]=audioread(fileName);
info=audioinfo(fileName)
flag=1;
% Extracting one channel . 
data=data(:,1);

% Length of file is extremly small , hence no framing required .
sigLen=length(data);
orderLPC=24;
window=hanning(sigLen);

% Multiply the signal with hanning window .
data=window.*data;
% Perform Autocorellation 
sig_auto=xcorr(data);
%Normalise the data . 
sig_auto=sig_auto./abs(max(sig_auto));
% Now, we to create R matrix , we take LPC order number of last elements. 
% Past samples
A=sig_auto(1:orderLPC);
% Output signal values for each of the combinations of timestamps. 
r=sig_auto(2:orderLPC+1);
% Toeplitz Matrix of coloumn vector-A
A=toeplitz(A);
r_t=transpose(r);
A=(-1).*(inv(A));
% Computing L 
L=r_t*A ; 
L=transpose(L);
%Extracting the LP Coefficients .
lpcoeffs=[1;L];
% Performing Filtering Operation .
G=1 ; 
filtered_sig=filter([0-1*lpcoeffs(2:end)],G,data);
% Error Computation (Residual)
lp_res=data-filtered_sig;
% Autocorrelation of signal . 
auto_lp_res=xcorr(lp_res);

% Compute the Pitch . 
[pks,loc]=findpeaks(auto_lp_res);
[pks,ind]=sort(pks,'descend');
loc=loc(ind);
[~,mind]=max(pks);
pitch_period=abs(loc(mind+1)-loc(mind));
%Time conversion .
pitch_ms=pitch_period*1000/fs;
% Estimated Pitch 
disp('Pitch in Hz : ')
pitch=1000/pitch_ms 


% Plotting (Entire Signal)
 if(flag)
      figure; 
      time=linspace(0,sigLen,sigLen);
      subplot(4,1,1)
      plot(time,data)
      xlabel('Time');
      ylabel('Speech Frame'); 
      grid on;
      
      time=linspace(0,sigLen,sigLen);
      subplot(4,1,2)
      plot(time,filtered_sig)
      xlabel('Time');
      ylabel('Predicted Speech Frame'); 
      grid on;
      
      
      subplot(4,1,3)
      plot(time,lp_res)
      xlabel('Time');
      ylabel('LP Residual Frame'); 
      grid on;
        
      subplot(4,1,4)
      stime=linspace(0,length(auto_lp_res),length(auto_lp_res));
      plot(stime,auto_lp_res)
      xlabel('Time');
      ylabel('Autocorellated LP Residual Frame'); 
      grid on;
  end

end