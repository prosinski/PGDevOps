data suv_upto_30000;
	*wczytanie zbioru;
	set sashelp.cars;
	*wybor typu w cenie mniejszej badz rownej 30000;
	where type = "SUV" and msrp <=30000;



run;

/*Uzycie formatow Datastep/procedura*/
data class_bd;
	set PG1.class_birthdate;
	*liczba znakow daty, d-myslniki format;
	format Birthdate ddmmyyd10.;
	*d-zmiana formatu danych dla warunku;
	where Birthdate >= "01sep2005"d;

run;

/*Sortowanie danych*/
	proc sort data=class_bd out=class_bd_srt;
	by Birthdate ;
run;

/*Sortowanie danych rosnaco po wieku i wzroscie*/
	proc sort data=class_bd out=class_bd_srt;
	by Age Height ;
run;

/*Sortowanie danych rosnaco po wieku i malejaco wzroscie*/
	proc sort data=class_bd out=class_bd_srt;
	by Age DESCENDING Height ;
run;

/*usuwanie duplikatow (nodupkey usuwanie, dupout wyrzucenie do pliku usunietego duplikatu*/
proc sort data=pg1.class_test3 out=class_test3_clean nodupkey dupout=class_test3_dups;
	/*by name subject testscore*/
	by _all_;
run;

/*Przetwarzanie danych w data step*/
data class_bd;
	set PG1.class_birthdate;
	format Birthdate ddmmyyd10.;
	where Birthdate >= "01sep2005"d;
	drop age;
run;

/*Drop jako opcja zbioru*/
data class_bd;
	set PG1.class_birthdate(drop=Age);
	format Birthdate ddmmyyd10.;
	where Birthdate >= "01sep2005"d;
run;

data cars_avg;
format mpg_mean 5.2;
	set sashelp.cars;
	mpg_mean = mean(mpg_city, mpg_highway);
run;

data sotm_avg;
	set pg1.storm_range;
	windAvg = mean(of wind1-wind4);
run;


data sotm_avg;
	set pg1.storm_range;
	windAvg = mean(of wind:);
/*	drop wind:;*/
run;

data eu_occ_total;
	set pg1.eu_occ;
/*	konwersja z tekstu na liczbe: funkcja input w odwrotna strone put*/
/*	continue konwertuje i w jaki sposób, informat*/
	Year= input(substr(YearMon,1,4), 4.);
	Month=input(substr(YearMon,6,2), 2.);
	ReportDate = MDY (Month,1,Year);
	Total = sum(Hotel, ShortStay, Camp);
	Format Hotel ShortStay Camp Total comma17.
			ReportDate monyy7.;
	Keep Country Hotel ShortStay Camp ReportFate Total;
run;

data np_summary2;
	set pg1.np_summary;
	ParkType = SCAN(ParkName,-1);
	Keep Reg Type ParkName ParkType;
run;

/*Wyrazenia warunkowe*/
data cars_categories;
	set sashelp.cars;
	Length car_category $12;
	if MSRP <= 30000 then do;
		num_category = 1;
		car_category = "Basic" ;
	end;
	else if MSRP <= 60000 then do;
		num_category = 2;
		car_category = "Luxury";
	end;
	else do 
		num_category = 3;
		car_category = "Extra Luxury";	
	end;
run;





data Basic Luxury Extra_Luxury;
	set sashelp.cars;
	Length car_category $12;
	if MSRP <= 30000 then do;
		num_category = 1;
		car_category = "Basic";
		output Basic;
	end;
	else if MSRP <= 60000 then do;
		num_category = 2;
		car_category = "Luxury";
		output Luxury;
	end;
	else do 
		num_category = 3;
		car_category = "Extra Luxury";	
		output Extra_Luxury;
	end;
run;

data parks monuments;
	set pg1.np_summary;
	where type in ("NM", "NP");
	Campers = sum(BackcountryCampers, OtherCamping, RVCampers, TentCampers);
	format Campers comma15.;
	length ParkType $ 8;
	if type = "NP" then do;
		ParkType = "Park";
		output parks;
	end;
	else do;
		ParkType = "Monument";
		output monuments;
	end;
	Keep Reg ParkName DayVisits OtherLodging Campers ParkType;
run;

data parks monuments;
	set pg1.np_summary;
	where type in ("NM", "NP");
	Campers = sum(BackcountryCampers, OtherCamping, RVCampers, TentCampers);
	format Campers comma15.;
	length ParkType $ 8;
	select;
		when (type = "NP") do;
		ParkType = "Park";
		output parks;
	end;
	otherwise do;
		ParkType = "Monument";
		output monuments;
	end;
	end;
	Keep Reg ParkName DayVisits OtherLodging Campers ParkType;
run;

/*zlaczenie danych w sql*/
proc sql;
	create table class_grades as
	select t.name, sex, age, teacher, grade
		from pg1.class_teachers as t
		inner join pg1.class_update as c
		on t.name = c.name;

quit;

proc sql;
/* coalesce jesli posiada pusty wierszto bierze z nastepnej kolumny*/
	select coalesce(t.name, c.name)as name, sex, age, teacher, grade
		from pg1.class_teachers as t
		full join pg1.class_update as c
		on t.name = c.name;

quit;