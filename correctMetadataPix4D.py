# -*- coding: utf-8 -*-
"""
Created on Mon Mar 31 17:55:13 2025

@author: AcCapelli
"""
import numpy as np
import pandas as pd


name=r'metadataPerchMergedGeoRef.csv'
path=r'G:\My Drive\myISOSP2\2025March_ISOPS2_LEM\data\Photogrammetry'
file=path+'\\'+name


AccX=0.2  # accuracy in x direction estimate
AccY=0.2  # accuracy in y direction estimate
AccZ=0.2  # accuracy in z direction estimate


# read file
metadata=pd.read_csv(file)

# correct pitch
metadata.GimbalPitchDegree+=90

# correct roll and yaw when necessary
ind=np.abs(metadata.GimbalRollDegree)>90
metadata.loc[ind,'GimbalRollDegree']-=180
metadata.loc[ind,'GimbalYawDegree']-=180


# add accuracies (estimates)
metadata['AccuracyX'] = np.ones_like(metadata.GPSAltitude)*AccX
metadata['AccuracyY'] = np.ones_like(metadata.GPSAltitude)*AccY
metadata['AccuracyZ'] = np.ones_like(metadata.GPSAltitude)*AccZ

# save data to new file addding '_Pix4D.csv' to file name
metadata.to_csv(file[:-4]+'_Pix4D.csv',index=False)
