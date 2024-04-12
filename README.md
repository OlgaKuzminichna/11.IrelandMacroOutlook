# Analysis of Ireland's monthly Inflation Rate

Litvinova Olga

m: litvinova2404@gmail.com

## Overview

To analyze Ireland's inflation I downloaded monthly inflation data ( All-items HICP (CP00), Energy (NRG), Overall index excluding energy (TOT X NRG)) from table PRC HICP MIDX of the Eurostat database for periods from 2012.01 to 2022.12. 
Then after dowloading the data following steps were made:
## 1. Calculated inflation rates (month-on-month, annualized month-on-month, year-on-year per month)
  ### month-on-month
The cp00_inflation_MoM variable is defined as an array with ‘TT’ elements, where ‘TT’ is the length of the cp00_value vector. A for-loop is used to iterate over the cp00_value vector, starting from the second element, and calculate the MoM inflation rate for the 'CP00' variable. The resulting MoM inflation rate is stored in the corresponding element of the cp00_inflation_MoM array. The first element of the cp00_inflation_MoM array is left as zero. The same steps are done for Energy and Overall index excluding energy values.


  ### annualized month-on-month 
* The ‘n_years’ variable is defined as the total number of years in the data set, which is equal to the length of the ‘cp00_value’ vector divided by 12 month of the year.
* The ‘cp00_annualized_rate’ represents the annualized inflation rate for a given year.
* The ‘cp00_cumulative_product’ variable is defined as the cumulative product of the monthly inflation rates in the cp00_inflation_MoM vector. A for-loop is used to iterate over the ‘n_years’ variable, calculate the starting and ending indices for each year, and extract the corresponding annualized cumulative product. Similarly, the same done for Energy and Overall index excluding energy values.


### year-on-year per month
It is calculated as the percentage change in the price level from the same month of the previous year to the current year. 

## 2. For year-on-year inflation per month I used the Hodrick-Prescott filter for computing the inflation gap and trend inflation

   The Hodrick-Prescott (HP) filter is a mathematical tool used to separate a time series into a trend component and a cyclical component. The filter is used to decompose a time series into a trend and a cyclical component by minimizing the difference between the original time series and its trend. The HP filter has one parameter, lambda, that controls the smoothness of the trend . 
The inputs to the function are :
*	x: the time-series data that needs to be filtered
*	HP_LAMBDA: a smoothing parameter that determines the trade-off between the cyclical component and the trend component.
The outputs of the function are:
*	hpcycle: the short-term cyclical component of the time-series
*	hptrend: the long-term trend component of the time-series.

  The code first defines the length of the time-series and creates a square matrix, HP_mat, that is used to perform the filtering. Then, using a for loop, it populates HP_mat with elements based on HP_LAMBDA. Finally, it solves for the hptrend by multiplying the inverse of HP_mat and x. The hpcycle is then calculated as the difference between the original time-series data and the trend component.
### lambda parameter 
The value of lambda is usually set based on the frequency of the data and the desired smoothness of the trend. 
For example, 129600 corresponds to a monthly frequency, with a relatively smooth trend. In practice, the value of lambda is often chosen through trial and error to obtain a satisfactory balance between the smoothness of the trend and the fidelity of the original data. A higher value of lambda will result in a smoother trend but may filter out too much of the cyclical component, while a lower value of lambda will result in a less smooth trend but may preserve more of the cyclical component. 

## 3. Showed time series plots of inflation rates (HICP, energy, non-energy). Plot also trend inflation to each inflation measure. Added the respective average inflation over all periods.
For the first graph, I chose to display all three inflation rates (HICP, energy, non-energy) in a single time-series graph. This allows for a clear comparison of the percentage ratio between them. (see Figure 1). 
![image](https://github.com/olga-litvinova/11.IrelandMacroOutlook/assets/120052171/93e09258-a2ba-485e-97e3-9ae85732b8ea)
Overall, these numbers indicate that inflation rates can be highly variable and are influenced by a variety of factors, including energy prices, non-energy factors, and other external economic factors.	 It is also important to mention that inflation rates drastically increased across all categories in 2022, with the highest increases in Energy. CP00 and Non-energy inflation also increased but to a lesser extent.

For my next three graphs, I decided to create separate plots for each inflation rate. In these plots, I included the YoY rate, the trend, and the average YoY rate for all periods (dotted line)
![image](https://github.com/olga-litvinova/11.IrelandMacroOutlook/assets/120052171/c8cf85b1-887f-45c4-82be-5f3760a47d2e)

![image](https://github.com/olga-litvinova/11.IrelandMacroOutlook/assets/120052171/73243be4-c127-414c-a159-a3f99e05cc84)
![image](https://github.com/olga-litvinova/11.IrelandMacroOutlook/assets/120052171/81e9ffe9-b990-4893-a7a1-ca571cc2c881)

## 5. Ploted the cyclical component 
For this task, I opted to keep the previous three graphs and replace the average value with the cyclical component. The brown line is now representing cyclical component. (See graphs 5,6 and 7)
![image](https://github.com/olga-litvinova/11.IrelandMacroOutlook/assets/120052171/97a89652-f775-421f-bee4-66ac24b34927)
![image](https://github.com/olga-litvinova/11.IrelandMacroOutlook/assets/120052171/cf3a499f-3548-4545-a8e7-963c4eb6c44b)
![image](https://github.com/olga-litvinova/11.IrelandMacroOutlook/assets/120052171/04c8ef58-a13d-4f1d-9d7e-bdb354c853a2)

## 6. Calculated the standard deviations of all monthly year-on-year inflation measures.
