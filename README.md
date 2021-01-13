This repository is for materials and codes related to the course 
"Basics of Mathematics in Machine Learning I" 
given in January-March 2021 at University of Helsinki, Finland. 

The lecturers are Prof. Samuli Siltanen and Dr. Fernando Silva de Moura. 
Teaching assistants are Salla Latva-Äijö and Siiri Rautio. 

(1) How to use the Matlab codes in folder Weather_examples?

First run "WeatherData_from_Excel_to_mat.m". It will read in Excel files and save the data as a Matlab data file. 

Then you can run "NeuralNet_manual_plots.m" to examine the simple classifications of days based on either just the average temperature, or on temperature and air pressure data together. Here the two-neuron networks are not trained really; their parameters are simply chosen explicitly. 

The next step is to examine the classifications from automatically trained networks. For the two-data case (temperature and air pressure) run "NeuralNet_twodata_learned_plots.m". This classifies April and July days almost perfectly. 

Finally, you can run "NeuralNet_threedata_learned_plots.m".
