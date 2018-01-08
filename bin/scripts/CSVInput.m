function [uOutput] = CSVInput(nFunction,sFilename);

% function [uOutput] = PRSNInput(nFunction,sFilename)
% Import filter for PRSN into Zmap format
%

% Filter function switchyard

if nFunction == 0     % Return info about filter
    uOutput = 'PRSN data format -  PRSNInput.m';
    
elseif nFunction == 1 % Import and return catalog
    % Read formated data
    mData = csvread(sFilename);
    % Create empty catalog
    uOutput = zeros(length(mData), 15);
    % Loop thru all lines of catalog and convert them
    for i = 1:length(mData)
          uOutput(i,1)  = mData(i,8);  % Longitude
          uOutput(i,2)  = mData(i,7);  % Latitude
          uOutput(i,3)  = mData(i,1);  % Year
          uOutput(i,4)  = mData(i,2);  % Month
          uOutput(i,5)  = mData(i,3);  % Day
          uOutput(i,6)  = mData(i,10); % Magnitude
          uOutput(i,7)  = mData(i,9);  % Depth
          uOutput(i,8)  = mData(i,4);  % Hour
          uOutput(i,9)  = mData(i,5);  % Minute
          uOutput(i,10) = mData(i,6); % Second
          % Create decimal year
          uOutput(i,3) = decyear([uOutput(i,3), uOutput(i,4), uOutput(i,5), uOutput(i,8) uOutput(i,9), uOutput(i,10) ]);
    end;
    
end;  

