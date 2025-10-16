%% METADATA_PROCESSOR.M - Photogrammetry Metadata Correction
%
% PURPOSE: This script reads photogrammetry metadata from a CSV file,
% corrects specific Gimbal angle fields (Pitch, Roll, and Yaw), adds
% estimated accuracy columns (X, Y, Z), and saves the modified table
% to a new CSV file for processing in tools like Pix4D.
%
% INPUT:
%   - 'metadataFile.csv' (path defined in Section 1)
%
% OUTPUT:
%   - 'metadataFile_Pix4D_MATLAB.csv'
%
% Dependencies: Standard MATLAB functions (readtable, writetable).
%
% Author: AcCapelli (Original python script)
% Refactored by: Gemini
%--------------------------------------------------------------------------

% --- 1. Define File Paths and Constants ---
% Metadata file name
name = 'metadataPerchMergedGeoRef.csv';
% Path to the data directory
path = 'G:/My Drive/myISOSP2/2025March_ISOPS2_LEM/data/Photogrammetry/metadata';
% suffix to add to process metadata file
SuffixNew='_Pix4D_MATLAB';

% Combine path and name
file = fullfile(path, name);

% Define accuracy estimates
AccX = 0.2;  % Accuracy in x direction estimate
AccY = 0.2;  % Accuracy in y direction estimate
AccZ = 0.2;  % Accuracy in z direction estimate


%% --- 2. Read File ---
disp(['Reading file: ', file]);
try
    % Read the CSV into a MATLAB table
    metadata = readtable(file);
catch ME
    warning(['Could not read file: ', file]);
    rethrow(ME);
end


%% --- 3. Apply Data Corrections ---

% Correct pitch: GimbalPitchDegree = Pitch + 90
metadata.GimbalPitchDegree = metadata.GimbalPitchDegree + 90;
disp('GimbalPitchDegree corrected (+90).');


% Conditional correction for roll and yaw (for values > 90 degrees)
ind = abs(metadata.GimbalRollDegree) > 90;

% Apply the correction (-180) using logical indexing
metadata.GimbalRollDegree(ind) = metadata.GimbalRollDegree(ind) - 180;
metadata.GimbalYawDegree(ind) = metadata.GimbalYawDegree(ind) - 180;

disp(['Conditional Roll/Yaw correction applied to ', num2str(sum(ind)), ' row(s).']);


%% --- 4. Add Accuracy Columns (Estimates) ---

% Create column vectors matching the table height to avoid dimension errors.
numRows = height(metadata);

metadata.AccuracyX = AccX * ones(numRows, 1);
metadata.AccuracyY = AccY * ones(numRows, 1);
metadata.AccuracyZ = AccZ * ones(numRows, 1);

disp('Accuracy columns added.');


%% --- 5. Save Data to New File ---

% Construct the new file path with the specified suffix
[filepath, name_only, ext] = fileparts(file);
new_filename = [name_only, SuffixNew, ext];
new_file = fullfile(filepath, new_filename);

% Save the modified table back to a CSV file
writetable(metadata, new_file, 'Delimiter', ',');

% Use 'warning' to make the final status message stand out
warning('off', 'MATLAB:warn:SuppressThisWarning');
disp('--- Process Complete ---');
warning(['Saved modified data to: ', new_file]);
