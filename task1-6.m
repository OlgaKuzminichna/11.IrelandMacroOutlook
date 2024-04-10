##############################
##############################
############################## 
#Download the following monthly inflation data from table PRC HICP MIDX of the Eurostat database for Ireland

#install needed packages
# pkg install io;               #The IO package provides a collection of functions for input and output of data in various formats, including Excel, CSV, and HDF5, among others.
# pkg install dataframe-1.2.0;  #The dataframe package is an Octave package that provides functionality for working with tabular data.

# load the packages
pkg load io;
pkg load dataframe;

# erase temp files in memory,  freeing up system resources and preventing any potential conflicts or errors
clear all;

# Load data from a CSV file Ireland.csv into a dataframe object (octxmpl3_2)
# -------------------------------The `dataframe` function is used to create a new dataframe object
data = dataframe(strcat(pwd,"/Ireland.csv")); # pwd points to the octave working directory
                                              # strcat concatenates the current working directory path (pwd) with a forward slash and the file name "Ireland.csv". Thus creates a full file path to the Ireland.csv file in the current working directory.
                                              # then we store it as a dataframe in the variable named "data"
# Set subsample for each coicop  (octxmpl3_2)
# combination of cellstr and strcmp - converts the table cell to string  and then compares the cell value with a given value
cp00 = data(strcmp(cellstr(data.geo),'IE') & strcmp(cellstr(data.coicop), 'CP00') & strcmp(cellstr(data.unit), 'I15') & strcmp(cellstr(data.freq),'M'), :);
nrg = data(strcmp(cellstr(data.geo),'IE') & strcmp(cellstr(data.coicop), 'NRG') & strcmp(cellstr(data.unit), 'I15') & strcmp(cellstr(data.freq),'M'), :);
totxnrg = data(strcmp(cellstr(data.geo),'IE') & strcmp(cellstr(data.coicop), 'TOT_X_NRG') & strcmp(cellstr(data.unit), 'I15') & strcmp(cellstr(data.freq),'M'), :);

# Specify what is to be done (octxmpl3_2). Define variables
DefineMacroVars = 1;

if DefineMacroVars,
  %CP00
  cp00_value=cp00.OBS_VALUE
  %NRG
  nrg_value=nrg.OBS_VALUE
  %TOT_X_NRG
  totxnrg_value=totxnrg.OBS_VALUE
  %Time
  Time=cp00.TIME_PERIOD

##############################
##############################
############################## 
#Calculate inflation rates for all three variables:

##############################  CP00


##### Calculate MoM inflation for CP00 (formula for MoM is similar to Plot_FRED_Data.m line 58)
#length is a built-in function, returns the number of elements in a vector.
  TT = length(cp00_value);                                        #TT represents the number of elements in the cp00_value array

#for-loop is used to repeat a block of code a specified number of times.The variable is updated on each iteration of the loop, and the code block is executed until the value of the variable exceeds end_value.
  for ii = 2:TT,                                                  #The loop starts from ii = 2 and goes up to the end of the series (TT).
    cp00_inflation_MoM(ii) = 100*(cp00_value(ii)./cp00_value(ii-1)) - 100; % t1 will be filled with a zero
  end


##### Calculate Annualized MOM inflation rate for each year for CP00

# Divide the number of months by 12 to get the number of years
n_years = TT / 12;

# Create a vector to store the annualized inflation rate for each year
cp00_annualized_rate = zeros(n_years, 1);

# Calculate the cumulative product of the monthly inflation rates
cp00_cumulative_product = cumprod(1 + cp00_inflation_MoM/100);
# Calculate the annualized month-on-month inflation rate for each year
for i = 1:n_years                                                 #calculates the number of years in the set.
  start_index = (i - 1) * 12 + 1;                                 #calculates the starting index of the data set for the i-th year.
  end_index = i * 12;                                             #calculates the ending index for a given year i. The value 12 is used because each year has 12 months.
  cp00_cumulative_product_year = cp00_cumulative_product(start_index:end_index);    # calculates the cumulative product of the monthly inflation rates for one year, by selecting start_index and end_index for that year
  cp00_annualized_rate(i) = (cp00_cumulative_product_year(end) ^ (12 / length(cp00_cumulative_product_year)) - 1) * 100;  #This line calculates the annualized month-on-month inflation rate for each year
end


##### Calculate YoY inflation for CP00

# expression 1:end-12, : is called slicing or indexing. It is used to extract a portion of a matrix or array, specifically rows 1 through the end (excluding the last 12 rows)
cp00_inflation_YoY = (cp00_value(13:end, :) - cp00_value(1:end-12, :)) ./ cp00_value(1:end-12, :) * 100;




##############################  NRG(same as CP00, but for nrg_value)


##### Calculate MoM inflation for NRG
   TT = length(nrg_value);                                         #TT represents the number of elements in the nrg_value array
  for ii = 2:TT,
    nrg_inflation_MoM(ii) = 100*(nrg_value(ii)./nrg_value(ii-1)) - 100; % t1 will be filled with a zero
  end


##### Calculate Annualized MoM inflation for NRG
# Create a vector to store the annualized inflation rate for each year
nrg_annualized_rate = zeros(n_years, 1);

# Calculate the cumulative product of the monthly inflation rates
nrg_cumulative_product = cumprod(1 + nrg_inflation_MoM/100);
# Calculate the annualized month-on-month inflation rate for each year
for i = 1:n_years                                                 #calculates the number of years in the set.
   start_index = (i - 1) * 12 + 1;                                #calculates the starting index of the data set for the i-th year.
  end_index = i * 12;                                             #calculates the ending index for a given year i. The value 12 is used because each year has 12 months.
 nrg_cumulative_product_year = nrg_cumulative_product(start_index:end_index);    # calculates the cumulative product of the monthly inflation rates for one year, by selecting start_index and end_index for that year
  nrg_annualized_rate(i) = (nrg_cumulative_product_year(end) ^ (12 / length(nrg_cumulative_product_year)) - 1) * 100;  #This line calculates the annualized month-on-month inflation rate for each year
end


##### Calculate YoY inflation for NRG
  nrg_inflation_YoY = (nrg_value(13:end, :) - nrg_value(1:end-12, :)) ./ nrg_value(1:end-12, :) * 100;



############################## TOR_X_NRG(same as CP00, but for totxnrg_value)


##### Calculate MoM inflation for TOT_X_NRG

#  totxnrg_inflation_MoM = (totxnrg_value(2:end, :) - totxnrg_value(1:end-1, :)) ./ totxnrg_value(1:end-1, :) * 100;

 TT = length(totxnrg_value);                                    #TT represents the number of elements in the totxnrg_value array
  for ii = 2:TT,
    totxnrg_inflation_MoM(ii) = 100*(totxnrg_value(ii)./totxnrg_value(ii-1)) - 100; % t1 will be filled with a zero
  end


##### Calculate Annualized MoM inflation for TOT_X_NRG
# Create a vector to store the annualized inflation rate for each year
totxnrg_annualized_rate = zeros(n_years, 1);

# Calculate the cumulative product of the monthly inflation rates
totxnrg_cumulative_product = cumprod(1 +  totxnrg_inflation_MoM/100);
# Calculate the annualized month-on-month inflation rate for each year
for i = 1:n_years                                                 #calculates the number of years in the set.
   start_index = (i - 1) * 12 + 1;                                 #calculates the starting index of the data set for the i-th year.
   end_index = i * 12;                                             #calculates the ending index for a given year i. The value 12 is used because each year has 12 months.
   totxnrg_cumulative_product_year =  totxnrg_cumulative_product(start_index:end_index);    # calculates the cumulative product of the monthly inflation rates for one year, by selecting start_index and end_index for that year
   totxnrg_annualized_rate(i) = ( totxnrg_cumulative_product_year(end) ^ (12 / length( totxnrg_cumulative_product_year)) - 1) * 100;  #This line calculates the annualized month-on-month inflation rate for each year
end


##### Calculate YoY inflation for TOT_X_NRG
  totxnrg_inflation_YoY = (totxnrg_value(13:end, :) - totxnrg_value(1:end-12, :)) ./ totxnrg_value(1:end-12, :) * 100;
end



##############################
##############################
############################## 
# Using the Hodrick-Prescott filter I am computing the inflation gap and trend inflation (HICP, energy, nonenergy).


% Define the Hodrick-Prescott lambda parameter
HP_LAMBDA = 129600; # LAMBDA_monthly =1600 * 3^4 = 129600

############ CP00
% Use the hpfilter function to compute the inflation gap and trend inflation
[hicp, hicp_trend] = hpfilter(cp00_inflation_YoY, HP_LAMBDA);
% The inflation gap is given by hpcycle
cp00_inflation_gap = hicp;
cp00_inflation_trend= hicp_trend;

############ NRG
% Use the hpfilter function to compute the inflation gap and trend inflation
[energy, energy_trend] = hpfilter(nrg_inflation_YoY, HP_LAMBDA);
% The inflation gap is given by hpcycle
nrg_inflation_gap = energy;
nrg_inflation_trend= energy_trend;


############ totxnrg
% Use the hpfilter function to compute the inflation gap and trend inflation
[nonenergy, nonenergy_trend] = hpfilter(totxnrg_inflation_YoY, HP_LAMBDA);
% The inflation gap is given by hpcycle
totxnrg_inflation_gap = nonenergy;
totxnrg_inflation_trend= nonenergy_trend;


##############################
##############################
############################## 
#ploting time series of inflation rates

#Prepare data for ploting

# Calculate the average inflation over all periods for each data set
cp00_avg = mean(cp00_inflation_YoY);    # the mean function is used to calculate the arithmetic mean of an array
nrg_avg = mean(nrg_inflation_YoY);
totxnrg_avg = mean(totxnrg_inflation_YoY);

# Generate Time Variable (from tutorial 3:Plot_FRED_Data.m)
COICOP_TIME = (2013 : 1/12 : 2013 + 1/12*(TT-13) )';


############################## Plotting

########## One Time Series Plot for all inflation rates
figure('Name','Task4. Time series plots of inflation rates');        #This is a command to create a new figure window with the given name

plot(COICOP_TIME, cp00_inflation_YoY,'-b', 'LineWidth', 2);         #Function 'plot' creates a plot, , with the x-axis representing time and the y-axis representing the YoY inflation rate
#The '-b' option specifies the color and style of the line (in this case, a blue solid line), and the 'LineWidth' option sets the width of the line to 2.
hold on;                                                             # allows to add new plots to an existing figure without overwriting the previous ones.
plot(COICOP_TIME, nrg_inflation_YoY, '-g', 'LineWidth', 2);          # plot yoy nrg
plot(COICOP_TIME, totxnrg_inflation_YoY , '-r', 'LineWidth', 2);     # plot yoy totxnrg
hold off;                                                            #used to turn off the "hold" feature after all the desired plots have been added to the graph
# Add labels and legend
grid on;                                                             #display a grid on a plot or graph
xlabel('Time');                                                       #sets the label of the x-axis of a plot to "Time"
ylabel('YoY per month, %');                                           #used to label the y-axis of a plot, with the text "YoY per month, %"
title('Time series plots of inflation rates');                        #sets the title of the plot to "Time series plots of inflation rates"
# the next command creates a legend for the plot with three entries, each corresponding to one of the three lines in the plot
#The 'Location' option specifies that the legend should be placed in the northwest corner of the plot, meaning ion the top-left corner
legend('All-items HICP (CP00)', 'Energy (NRG)', 'Overall index excluding energy (TOT X NRG)', 'Location','northwest');
xlim([COICOP_TIME(1), COICOP_TIME(end)]);                             # limit the size of x axis
set(gca, 'FontSize',18);                                              # set the font and other styling

########## CP00
########## CP00 Plot trend inflation to each inflation measure; Add the respective average inflation over all periods.
figure('Name','Task4. CP00 YoY,Trend inflation, together with average inflation');    #This is a command to create a new figure window with the given name

plot(COICOP_TIME, cp00_inflation_YoY,'-b', 'LineWidth', 2);                           # plot yoy cp00
hold on;
plot(COICOP_TIME, hicp_trend, 'color',  'black', 'Linewidth',2) ;                     # plot trend cp00, lambda = 129600, customize the color and line width a little bit
plot(COICOP_TIME, cp00_avg, 'LineWidth', 2);                                          # plot yoy average cp00

hold off;                                                                              #used to turn off the "hold" feature after all the desired plots have been added to the graph
# Add labels and legend
grid on;                                                                               #display a grid on a plot or graph
xlim([COICOP_TIME(1), COICOP_TIME(end)]);                                              # limit the size of x axis
xlabel('Time');
ylabel('CP00, %');
title('CP00: YoY, Trend inflation and respective average inflation over all periods');
legend('YoY per month','Trend for CP00-lambda=129600','CP00 YoY avearage over all periods','Location','northwest');
set(gca,'FontSize',14);


########## NRG (same as cp00)
########## NRG Plot trend inflation to each inflation measure; Add the respective average inflation over all periods.
figure('Name','Task4. NRG YoY,Trend inflation, together with average inflation');           #This is a command to create a new figure window with the given name
plot(COICOP_TIME, nrg_inflation_YoY, '-g', 'LineWidth', 2);                                 # plot yoy nrg
hold on;
plot(COICOP_TIME, energy_trend, 'color', 'black', 'Linewidth',2) ;                          # plot trend nrg, lambda = 129600, customize the color and line width a little bit
plot(COICOP_TIME, nrg_avg,  'LineWidth', 2);                                                # plot yoy average nrg

hold off;                                                                                   #used to turn off the "hold" feature after all the desired plots have been added to the graph
# Add labels and legend
grid on;                                                                                    #display a grid on a plot or graph
xlim([COICOP_TIME(1), COICOP_TIME(end)]);                                                   # limit the size of x axis
xlabel('Time');
ylabel('NRG,%');
title('NRG: YoY, Trend inflation and respective average inflation over all periods');
legend('YoY per month','Trend for NRG-lambda=129600','NRG YoY avearage over all periods','Location','northwest');
set(gca,'FontSize',14);

##########totxnrg (same as cp00)
##########totxnrg Plot trend inflation to each inflation measure; Add the respective average inflation over all periods.
figure('Name','Task4. TOT X NRG YoY,Trend inflation, together with average inflation');      #This is a command to create a new figure window with the given name
plot(COICOP_TIME, totxnrg_inflation_YoY , '-r', 'LineWidth', 2);                             # plot yoy totxnrg
hold on;
plot(COICOP_TIME, nonenergy_trend, 'color', 'black', 'Linewidth',2) ;                        #plot trend nonenergy, lambda = 129600, customize the color and line width a little bit
plot(COICOP_TIME, totxnrg_avg, 'LineWidth', 2);                                              # plot yoy average totxnrg

hold off;
# Add labels and legend
grid on;
xlim([COICOP_TIME(1), COICOP_TIME(end)]);                                                   # limit the size of x axis
xlabel('Time');
ylabel('TOT X NRG,%');
title('TOT X NRG: YoY, Trend inflation and respective average inflation over all periods');
legend('YoY per month','Trend for nonEnergy-lambda=129600','TOT X NRG YoY avearage over all periods', 'Location','northwest');
set(gca,'FontSize',14);

