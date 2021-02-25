data storm_summary;
	set pg2.storm_summary(obs=5);
	duration = endDate-startDate;
/*	wyliczenie wartosci w logu*/
	putlog "ERROR: duration=" duration;
	putlog "WARNING: " duration=;
/*	aktualne wartosci pdv*/
	putlog _all_;
run;


data camping(keep=ParkName Month DayVisits CampTotal)
	lodging (keep=ParkName Month DayVisits LodgingOther);
	set pg2.np_2017;
	CampTotal = sum (of Camping:);
	if CampTotal > 0 then 
		output camping;
	if LodgingOther > 0 then 
		output lodging;
	format CampTotal comma15.;

run;

data quiz;
	set pg2.class_quiz;
	avgQuiz = mean(of Q:);
/*	Korzysta z tego ze kolumny od q1-q5 maja takie same wartosci*/
/*	format Quiz1-Quiz5 3.1;*/
/*	maja wartosci numeryczne numeric/charakter/all */
/*	format _numeric_ 4.1;*/
/*	podwojny myslnik nie bierze nazwy kolumn lecz ich kolejnosc*/
	format Quiz1--avgQuiz 4.2;
run;


/*rutyny*/
data quiz;
	set pg2.class_quiz;
	putlog "NOTE: przed rutyna";
/*	Zapisanie wartosci z wektora pdw wszystkich zmiennych*/
	putlog _all_;
	call sortn(of Q:);
	putlog "NOTE: po rutyna";
	putlog _all_;
	if mean(of q:) < 7 then
		call missing(of _all_);
run;

data quiz;
	set pg2.class_quiz;
	quiz1st = largest(1, of quiz1-quiz5);
	quiz1st = largest(1, of quiz1-quiz5);
	avgBest = mean(quiz1st, quiz2nd);
	studentId = rand('integer',100,999);
	avg = round(mean (of quiz1-quiz5));
run;


/*Sprawdzenie dlugosci*/
data test;
	a="ala ";
/*	rutyna missing*/
	call missing(a);
/*	zwracaja wartosci po usunieciu spacji z konca*/
	l1=length(a);
/*	zwraca dlugosc zmiennej*/
	l2=lengthc(a);
/*	zwracaja wartosci po usunieciu spacji z konca*/
	l3=lengthn(a);

run;

/*	funkcja cat x skleja tekst*/
data test;
/*	ustawienie dlugosci*/
	length imie imie2 nazwisko $20;
	imie="Katarzyna";
	imie2="Barbara";
	nazwisko="Kowalska";
	fullname= cat(imie, imie2, nazwisko);
	fullname2= imie !! imie2 || nazwisko;
/*	usuniecie spacji  z odzieleniem 1 spacji slow*/
	fullname3= catx(" ", imie, imie2, nazwisko);
run;

data stocks2;
	set pg2.stocks2(rename= (date=date_old high=high_old volume=volume_old));
	Date = input(date_old, date9.);
	High = input(high_old, best.);
	Volume = input(volume_old, comma12.);
	format Date ddmmyy10. Volume nlnum12.;
	drop date_old high_old volume_old;
run;
data stocks3;
	set stocks2;
	value_zl = put(Volume, nlmny15.2);	


run;
   
/*mamy jedene zbior a potem dorzucamy mniejsze zbiory to uzywamy procedury app*/
/*1.Skopiuje dane z sashelp.class do work.class*/
/*2.Dolacze dane z pg2.clas_new do work.class*/

proc copy in=sashelp out=work;
	select class;
/*	opcjonalnie zamiast select mozna uzyc exclude,*/
/*czyli skopiuj wszystko poza wymienionymi*/
run;

data class;
	length name $9;
	set sashelp.class;
run;

proc append base=class data=pg2.class_new;

run;


proc append base=class data=pg2.class_new2(rename=(student=name));
run;


/*Przetwarzanie w petlach*/

data petlaDo;
	do i=1 to 10; /*by 2* - zwieksza o 2;*/
		los = rand("integer",1,100);
		output;
	end;
run;


/*petla dowhile*/

data doWhile;
	i=1;
	do while(i<=10);
		los = rand("integer",1,100);
		output;
		i=i+1;
	end;


run;

data doList;
	do miesiac ="Styczen", "Luty", "Marzec";
	lostcard = rand ("integer",1,100);
	output;
end; 
run;

data doList;
set sashelp.class;
	do miesiac ="Styczen", "Luty", "Marzec";
	lostcard = rand ("integer",1,100);
	output;
end; 
run;


/*Transpozycja kolumn*/
proc transpose data=sashelp.class out=classT;
	id name;
	var Height Weight sex;
	by Sexl;
run;

proc sort data=sashelp.class out=classS;
	by age;
run;

proc transpose data=classS out=classT;
	id name;
	var Height Weight ;
	by age;
run;