/* Import */
PROC IMPORT
	out=ASM.Housing
	datafile='/home/u64002637/ASM/Project_Housing.csv'
	dbms=csv
	replace;
RUN;

/* Q1 */
data _null_;
	put 'Question 1';
run;
PROC SQL OUTOBS=20;
	select * from ASM.Housing ORDER BY monotonic() desc;
QUIT;
RUN;

/* Q2 */
data _null_;
	put 'Question 2';
run;
PROC SQL outobs=1;
	select avg(TotalReceptions) as TotalReceptionsByType, 
		FlatType from ASM.Housing
	group by FlatType
	order by TotalReceptionsByType desc;
QUIT;
RUN;

/* Q3 */
data _null_;
	put 'Question 3';
run;
PROC SQL;
	create table FlatTypeFreq as 
	select count(VAR1) as freq, FlatType from ASM.Housing group by FlatType order by freq desc;
QUIT;

proc sgpie data=FlatTypeFreq;
	title "FlatType Count in Pie version";
		pie FlatType / response=freq;
run;

/* Q4 */
data _null_;
	put 'Question 4';
run;
PROC SQL;
    create table BathDistribution as
    select FlatType, 
           TotalBaths
    from ASM.Housing
    where FlatType in ('flat', 'terraced house')
    group by FlatType;
QUIT;
proc sgplot data=BathDistribution;
    title "Distribution of Total Bathrooms by Flat Type";
    vbox TotalBaths / category=FlatType;
    xaxis label="Flat Type";
    yaxis label="Total Bathrooms";
run;


/* Q5 */
data _null_;
	put 'Question 5';
run;
PROC SQL outobs=2;
	select count(VAR1) as volumn, FlatType 
	from ASM.Housing group by FlatType order by volumn desc;
QUIT;
RUN;

/* Q6 */
data _null_;
	put 'Question 6';
run;
PROC SQL;
	create table TypeRelevent as
	select avg(price) as avg_price, 
		avg(TotalBeds) as avg_beds, 
		avg(TotalBaths) as avg_baths, FlatType from ASM.Housing
	group by FlatType order by avg_price;
QUIT;
run;

proc sgplot data=TypeRelevent;
    scatter x=avg_beds y=avg_price / markerattrs=(symbol=circlefilled);
    title "Average Price vs. Average Number of Bedrooms";
    xaxis label="Average Number of Bedrooms";
    yaxis label="Average Price";
run;

proc sgplot data=TypeRelevent;
    scatter x=avg_baths y=avg_price / markerattrs=(symbol=circlefilled);
    title "Average Price vs. Average Number of Bathrooms";
    xaxis label="Average Number of Bathrooms";
    yaxis label="Average Price";
run;