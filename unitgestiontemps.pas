//Unité en charge de la gestion de la date et du temps
unit UnitGestionTemps;   
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface 
//------------------------------- TYPES ----------------------------------------
Type
    //Jours de la semaine
    TJour = (LUNDI,MARDI,MERCREDI,JEUDI,VENDREDI,SAMEDI,DIMANCHE);
    //Saisons
    TSaison = (PRINTEMPS,ETE,AUTOMNE,HIVERS);
    //Météo
    TMeteo = (ENSOLEILLE,VENTEUX,PLUIE,TEMPETE,NEIGE);
    //Date
    TDate = record
      minutes : integer;     //Minutes (00->59)
      heures : integer;      //Heures (0->23)
      jour : TJour;          //Jour de la semaine
      num : integer;         //Numéro du jour (1-> 28)
      saison : TSaison;      //Saison
      annee : integer;       //Numéro de l'année
    end;

//-------------------------- SOUS PROGRAMMES -----------------------------------
//Récupère la date actuelle dans la partie
function GetDate() : TDate;

//Ajoute un nombre de minutes à la date actuelle
//entrée : nombre de minutes à ajouter (positif)
procedure AddMinuteToDate(numMinutes : integer);

//Transforme un jour en chaine de caractère
//entrée : le jour
function JourToString(jour : TJour) : string;

//Transforme une saison en chaine de caractère
//entrée : la saison
function SaisonToString(saison : TSaison) : string;

//Initialisation de la date
procedure InitDate();

// initialise la date donnée en entrée:
procedure SetDate(min, heu, numero, ann: integer; jou: TJour; sai: TSaison);

//Passe au jour suivant 06h00 lors d'un passage de jours
procedure JourSuivant();

//Renvoie la date en chaine de caractère
function DateToString() : string;    
//Renvoie l'heure en chaine de caractère
function HeureToString() : string;

    
//Renvoie la météo du jour
function GetMeteoJour() : TMeteo;
//Renvoie la météo du jour
function GetMeteoDemain() : TMeteo;

//Renvoie la météo du jour (en string)
function GetMeteoJourString() : string;
  
//La météo est-elle humide
function FaitHumide() : boolean;
              
//Renvoie si le joueur doit s'évanoïr (trop tard)
function HeureEvanouir() : boolean;




implementation
uses
    SysUtils;
var
   date : TDate;         //Date dans la partie
   meteoDuJour : TMeteo; //Météo du jour
   meteoDemain : TMeteo; //Météo de demain

//Renvoie la date en chaine de caractère
function DateToString() : string;
var
   strHeures : string; //L'heure en chaine de caractères
   strMinutes : string;//Les minutes en chaine de caractères
begin
     DateToString := JourToString(date.jour)+' '+IntToStr(date.num) + ' ' + SaisonToString(date.saison);
end;

//Renvoie l'heure en chaine de caractère
function HeureToString() : string;
var
   strHeures : string; //L'heure en chaine de caractères
   strMinutes : string;//Les minutes en chaine de caractères
begin
     //Gestion de l'affichage des heures et minutes sur 2 chiffres
     strHeures := IntToStr(date.heures);
     if(date.heures < 10) then strHeures := '0' + strHeures;
     strMinutes := IntToStr(date.minutes);
     if(date.minutes < 10) then strMinutes := '0' + strMinutes;

     HeureToString := strHeures+':'+strMinutes;

end;

//Renvoie la météo du jour
function GetMeteoJour() : TMeteo;
begin
   GetMeteoJour:=meteoDuJour;
end;

//Renvoie la météo du jour
function GetMeteoDemain() : TMeteo;
begin
   GetMeteoDemain:=meteoDemain;
end;

//Récupère la date actuelle dans la partie
function GetDate() : TDate;
begin
  GetDate := date;
end;

//Détermine le jour suivant
//entrée : le jour dont on veut le suivant
//sortie : le jour suivant celui donné en entrée
function JourSuivant(jour : TJour) : TJour;
begin
  if(jour <> DIMANCHE) then JourSuivant := succ(jour)
  else JourSuivant := LUNDI;
end;


procedure SetDate(min, heu, numero, ann: integer; jou: TJour; sai: TSaison);
begin

      date.minutes := min;     //Minutes (00->59)
      date.heures := heu;      //Heures (0->23)
      date.jour := jou;          //Jour de la semaine
      date.num := numero;         //Numéro du jour (1-> 28)
      date.saison := sai;      //Saison
      date.annee := ann;       //Numéro de l'année

end;



//Détermine la saison suivante
//entrée : la saison dont on veut la suivante
//sortie : la saison suivant celle donnée en entrée
function SaisonSuivante(saison : TSaison) : TSaison;
begin
  if(saison <> HIVERS) then SaisonSuivante := succ(saison)
  else SaisonSuivante := PRINTEMPS;
end;

procedure NormaliseDate();
begin
  //Normalisation des minutes
  date.heures += date.minutes div 60;
  date.minutes := date.minutes mod 60;

  //Normalisation des heures
  while(date.heures>=24) do
  begin
       date.heures -= 24;
       date.jour := JourSuivant(date.jour);
       date.num  += 1;
  end;

  //Normalisation des numéro de jour
  while(date.num > 28) do
  begin
       date.num -= 28;
       date.Saison := SaisonSuivante(date.Saison);
       if(date.Saison = PRINTEMPS) then date.annee += 1;
  end;
end;

//Ajoute un nombre de minutes à la date actuelle
//entrée : nombre de minutes à ajouter (positif)
procedure AddMinuteToDate(numMinutes : integer);
begin
  date.minutes += numMinutes;
  NormaliseDate();
end;
  
//Transforme un jour en chaine de caractère
//entrée : le jour
function JourToString(jour : TJour) : string;
begin
  case(jour) of
      LUNDI : JourToString := 'Lundi';
      MARDI : JourToString := 'Mardi';
      MERCREDI : JourToString := 'Mercredi';
      JEUDI : JourToString := 'Jeudi';
      VENDREDI : JourToString := 'Vendredi';
      SAMEDI : JourToString := 'Samedi';
      DIMANCHE : JourToString := 'Dimanche';
  end;
end;

//Transforme une saison en chaine de caractère
//entrée : la saison
function SaisonToString(saison : TSaison) : string;
begin
  case(saison) of
      PRINTEMPS : SaisonToString := 'Printemps';
      ETE : SaisonToString := 'Eté';
      AUTOMNE : SaisonToString := 'Automne';
      HIVERS : SaisonToString := 'Hivers';
  end;
end;


//Génère une météo aléatoire pour demain en prenant en compte la saison
procedure MeteoAleatoirePourDemain();
var
   saison : TSaison;  //La saison de demain
   alea : integer; //tirage aléatoire
begin
   //Détermine la saison de demain
   if(date.num = 28) then saison := SaisonSuivante(date.saison)
   else saison := date.saison;

   //On tire un D100 pour l'aléatoire
   alea := Random(100);

   case(saison) of
      PRINTEMPS:
      begin
           case(alea) of
              0..49: meteoDemain:=ENSOLEILLE;
              50..94: meteoDemain:=PLUIE;
              95..99: meteoDemain:=TEMPETE;
           end;
      end;

      ETE:
      begin
           case(alea) of
              0..69: meteoDemain:=ENSOLEILLE;
              70..94: meteoDemain:=PLUIE;
              95..99: meteoDemain:=TEMPETE;
           end;
      end;

      AUTOMNE:
      begin
           case(alea) of
              0..39: meteoDemain:=ENSOLEILLE;
              40..94: meteoDemain:=PLUIE;
              95..99: meteoDemain:=TEMPETE;
           end;
      end;

      HIVERS:
      begin
           case(alea) of
              0..69: meteoDemain:=ENSOLEILLE;
              70..99: meteoDemain:=NEIGE;
           end;
      end;
   end;

end;


//Renvoie la météo du jour (en string)
function GetMeteoJourString() : string;
begin
  case(meteoDuJour) of
     ENSOLEILLE: GetMeteoJourString := 'Grand soleil';
     VENTEUX: GetMeteoJourString := 'Le vent souffle';
     PLUIE: GetMeteoJourString := 'Il pleut abondamment';
     TEMPETE: GetMeteoJourString := 'Une tempête fait rage';
     NEIGE: GetMeteoJourString := 'Il neige !';
  end;
end;

//Passe au jour suivant 06h00 lors d'un passage de jours
procedure JourSuivant();
begin
  //Si l'heure actuelle est entre 06h00 et 23h59 on passe vraiment au jour suivant
  if(date.heures>=6) then
  begin
       date.heures := 24+6;
       //On change la météo (la météo du jour devient celle du jour)
       meteoDuJour:=meteoDemain;
       //La météo de demain est généré aléatoirement
       MeteoAleatoirePourDemain();
  end
  //Si l'heure actuelle est entre 00h00 et 07h59 on passe juste à 06h00
  else date.heures := 6;

  //Les minutes passent toujours à 0
  date.minutes := 0;
  //On normalise la date
  NormaliseDate();
end;

//Initialisation de la date
procedure InitDate();
begin
  date.minutes:=0;
  date.jour:=LUNDI;
  date.heures:=6;
  date.num:=1;
  date.annee:=1;
  date.saison:=PRINTEMPS;
  meteoDuJour:=ENSOLEILLE;
  MeteoAleatoirePourDemain();
end;

//La météo est-elle humide
function FaitHumide() : boolean;
begin
  FaitHumide:=false;
  case(meteoDuJour) of
     PLUIE,TEMPETE,NEIGE: FaitHumide := true;
  end;
end;

//Renvoie si le joueur doit s'évanoïr (trop tard)
function HeureEvanouir() : boolean;
begin
   HeureEvanouir := (date.heures>=2) AND (date.heures<=5);
end;

end.

