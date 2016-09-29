
mux = visa('ni','GPIB0::9::INSTR');  % multi switch

fopen(mux)

ScanInterval = 0;% ? Delay (in secs) between scans
numberScans = 1;% ? Number of scan sweeps to measure 
channelDelay = 0.2;% ? Delay (in secs) between relay closure and measurement
scanList = '(@101,102,103,104,105,106,107)';%List of channels to scan in each scan

%set the channel list to scan
str=sprintf('ROUTE:SCAN %s',scanList);
fprintf(mux,str);

%query number of channels to scan
j=query(mux,'ROUTE:SCAN:SIZE?');
ncanales=str2double(j);

fprintf(mux,'FORMAT:READING:CHAN ON');%" ? Return channel number with each reading
fprintf(mux,'FORMAT:READING:TIME ON');%"? Return time stamp with each reading
fprintf(mux,'FORMAT:READING:TIME:TYPE REL');% Return time stamp im seconds since scanstart
%fprintf(mux,'FORMAT:READING:TIME:TYPE ABS');%"? Return time stamp absolute



%? Set the delay (in seconds) between relay closure and measurement
str=sprintf('ROUT:CHAN:DELAY %2.1f , %s',channelDelay,scanList);
fprintf(mux,str);

% ? Number of scan sweeps to measure 
str=sprintf('TRIG:COUNT %d',numberScans);%
fprintf(mux,str);

%??
fprintf(mux,'TRIG:SOUR TIMER');

% Delay (in secs) between scans
str=sprintf('TRIG:TIMER %1.1f',ScanInterval);
fprintf(mux,str);

cmed= 600;
Ndata=7;
DATA=nan(Ndata,cmed);
TIME=nan(Ndata,cmed);
CHAN=nan(Ndata,cmed);
for medicion = 1:cmed
%START OF ONE SCAN LOOP

%start scan
j=query(mux,'INIT;:SYSTEM:TIME:SCAN?');

%wait to the end of the scan 
%pause(.5+(channelDelay+0.1)*ncanales);
pause(2);

%query number of datapoints per scan
strNdata=query(mux,'DATA:POINTS?');
Ndata=str2double(strNdata);


%query the values of all the scanned channels


       for inddata=1:Ndata
        %query one data value
        str=query(mux,'DATA:REMOVE? 1');
    %     data=sscanf(str,%f C,%f,%f');
        data=sscanf(str,'%f, %f, %f')
        %data(1) contains the measurement 
        %data(2) contains the time from the scan start
        %data(3) contains the number of channel

        DATA(inddata, medicion)=data(1);        
        TIME(inddata, medicion)=data(2);        
        CHAN(inddata, medicion)=data(3);        
       end
       
       plot(CHAN(:, medicion),DATA(:, medicion))
       xlabel('Canal')
       ylabel('Medida')
    pause (10)
    print(medicion)
end
savename = input('Como me llamo entre comillas?')
save(savename, 'CHAN', 'DATA', 'TIME')
%close connection
fclose(mux)