%% MATLAB Translation of Python Photogrammetry Metadata Correction Script
% This script reads a CSV file, applies conditional corrections to Gimbal
% angles, adds accuracy estimates, and saves the modified data to a new CSV.
%
% Original Python author: AcCapelli
% Translated by: Gemini

% --- 1. Define File Paths and Constants ---

name = 'metadataPerchMergedGeoRef.csv';
% NOTE: MATLAB uses fullfile() for cross-platform path construction, but 
% the original Windows path is kept for consistency with the user's environment.
path = 'G:/My Drive/myISOSP2/2025March_ISOPS2_LEM/data/Photogrammetry/metadata';
SuffixNew='_Pix4D_MATLAB';

% Combine path and name using fullfile for robustness
file = fullfile(path, name);

% Define accuracy estimates (same as Python constants)
AccX = 0.2;  % accuracy in x direction estimate
AccY = 0.2;  % accuracy in y direction estimate
AccZ = 0.2;  % accuracy in z direction estimate


%% --- 2. Read File ---
disp(['Reading file: ', file]);
try
    % Use readtable to read the CSV into a MATLAB table (similar to a pandas DataFrame)
    metadata = readtable(file);
catch ME
    warning(['Could not read file: ', file]);
    rethrow(ME);
end


%% --- 3. Apply Data Corrections ---

% Correct pitch: GimbalPitchDegree = metadata.GimbalPitchDegree + 90
metadata.GimbalPitchDegree = metadata.GimbalPitchDegree + 90;
disp('GimbalPitchDegree corrected (+90).');


% Conditional correction for roll and yaw
% Find logical indices where the absolute roll is greater than 90
ind = abs(metadata.GimbalRollDegree) > 90;

% Apply the correction (-180) to GimbalRollDegree only for the identified indices
% metadata.loc[ind,'GimbalRollDegree'] -= 180 in Python
metadata.GimbalRollDegree(ind) = metadata.GimbalRollDegree(ind) - 180;

% Apply the correction (-180) to GimbalYawDegree only for the identified indices
% metadata.loc[ind,'GimbalYawDegree'] -= 180 in Python
metadata.GimbalYawDegree(ind) = metadata.GimbalYawDegree(ind) - 180;

disp(['Conditional Roll/Yaw correction applied to ', num2str(sum(ind)), ' row(s).']);


%% --- 4. Add Accuracy Columns (Estimates) ---

% FIX: Explicitly create a column vector of the correct size using height(metadata) 
% and the ones() function to ensure it matches the table height, resolving the error.

numRows = height(metadata);

metadata.AccuracyX = AccX * ones(numRows, 1);
metadata.AccuracyY = AccY * ones(numRows, 1);
metadata.AccuracyZ = AccZ * ones(numRows, 1);

disp('Accuracy columns added.');


%% --- 5. Save Data to New File ---

% Construct the new file path (e.g., replace '.csv' with '_Pix4D.csv')
[filepath, name_only, ext] = fileparts(file);
new_filename = [name_only, SuffixNew, ext];
new_file = fullfile(filepath, new_filename);

% Save the modified table back to a CSV file
% 'Delimiter', ',' ensures standard CSV format
writetable(metadata, new_file, 'Delimiter', ',');

% Use 'warning' to make the final status message stand out with color
warning('off', 'MATLAB:warn:SuppressThisWarning'); % Suppress the standard warning ID
disp('--- Process Complete ---');
warning(['Saved modified data to: ', new_file]);
