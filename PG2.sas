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