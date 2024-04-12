# Analysis of Ireland's monthly Inflation Rate

Litvinova Olga

m: litvinova2404@gmail.com

## Overview

To analyze Ireland's inflation I downloaded monthly inflation data ( All-items HICP (CP00), Energy (NRG), Overall index excluding energy (TOT X NRG)) from table PRC HICP MIDX of the Eurostat database for periods from 2012.01 to 2022.12. 
Then after dowloading the data following steps were made:
1. Calculated inflation rates (month-on-month, annualized month-on-month, year-on-year per month)
2. For year-on-year inflation per month I used the Hodrick-Prescott filter for computing the inflation gap and trend inflation 
3. Showed time series plots of inflation rates (HICP, energy, non-energy). Plot also trend inflation to each inflation measure. Added the respective average inflation over all periods.
4. Ploted the cyclical component 
5. Calculated the standard deviations of all monthly year-on-year inflation measures.
