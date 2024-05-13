# Ants_DigilitePOS_2_DeepLabCutCSV
A matlab script to convert existing digilite .pos-files into a .csv-file that Deeplabcut can read. In this specific case it is for ant data from the Fleischmann-Group at Uni Oldenburg

This scripts are for converting existing positional data of ants marked with DIGILITE (.pos-files) into .csv-files Deeplabcut can read and use for training. 
I only accounted for the this specific case, where we marked two positions on the Ant (Mandibles and Thorax) aswell as the Nest and North.

The script needs 4 important informations of you:
source_path - is the DIGILITE-project directory, where your .pos-files and single frames are.
original_video - is the name of the original video. It should be in the source_path name, incase it is not, please change it.
dlc_project_path - is the DeepLabCut project directory, where the config.yaml is located. Make sure to change the config.yaml so to use those frames.
scorer - is who marked the ants. 
dlc_env_path - this is the path to the python environment of deeplabcut. 

Before you start learning, make sure to change the config.yaml to include your frames!!

Also make sure, you have 
