This repository is for materials and codes related to the course 
"Basics of Mathematics in Machine Learning I" 
given in January-March 2021 at University of Helsinki, Finland. 

The lecturers are Prof. Samuli Siltanen and Dr. Fernando Silva de Moura. 
Teaching assistants are Salla Latva-Äijö and Siiri Rautio. 

(1) How to use the Matlab codes in folder ./Weather_examples/

First run "WeatherData_from_Excel_to_mat.m". It will read in Excel files from subfolder ./Weather_examples/data/ and save selected weather measuerements as several .mat Matlab data files. (*Of course, you can examine the Excel files and study the weather measurements. The Excel files whose name ends with Long.xlsx contain three tabs with information about the type of measurements. They are in the format provided by the open data service of Finnish Meteorological Institute available on page https://en.ilmatieteenlaitos.fi/download-observations. The Excel files whose name ends with Long2.xlsx have only one tab, identical to the third tab in the file with the same name apart from the "2". This two-file system is for making reading the data into Matlab more straightforwards.)

Second, run "NeuralNet_manual_plots.m" to examine the simple classifications of days based on either just the average temperature, or on temperature and air pressure data together. Here the two-neuron networks are not really trained; their weights and biases are simply chosen explicitly. 

Third, examine the classification with an automatically trained network. For the two-data case (temperature and air pressure) run "NeuralNet_twodata_learned_plots.m". This classifies April and July days almost perfectly. The routine "NeuralNet_twodata_learned_plots.m" takes the weights and biases from the file /data/NN_parameters.mat. Where does that file come from? It was computed by training the network with the code available in the subfolder ./Weather_examples/ML_Higham_applied2weather/. In that folder, you can train the network yourself using Matlab, possibly changing the network architecture, learning rate, and other parameters. The machine learning code is adapted from the excellent article [HH2019].

Finally, you can run "NeuralNet_threedata_learned_plots.m".

References: 
[HH2019] Higham, C. F., & Higham, D. J. (2019). Deep learning: An introduction for applied mathematicians. SIAM Review, 61(4), 860-891.
