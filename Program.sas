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