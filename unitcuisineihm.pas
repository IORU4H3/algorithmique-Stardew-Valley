unit UnitCuisineIHM;

{$mode objfpc}{$H+}

interface
uses
  UnitDeplacement;

function EcranCuisine(): TLieu;
procedure AfficherRecette(numRecette: integer; position: integer);


implementation
uses GestionEcran, UnitIHM;


procedure AfficherRecette(numRecette: integer; position: integer);
var
  i : integer;
begin
  if (numRecette <= GetNombreRecettes()) and (numRecette>0) then
  begin
    EcrireDescription(' '+IntToStr(position)+GetNomRectte());
  end;
end;

function EcranCuisine(): TLieu;
begin
  PageRecettes(1);
  EcranCuisine := MAISON;
end;

Procedure PageRecettes(num: integer);
var
  choix: integer;
  i: integer;
begin
  choix := -1;
  while (choix <> 0) then
  begin
    BaseIHM('Lieu : La cuisine');
    AffichageMeteo();

    EcrireDescriptionAlert('Liste des recettes');


    for i := 1 to 4 do
    begin
      EcrireDescription('');
      AfficherRecette(num+i-1,i);
    end;

    EcrireMenu(' 2- page suivante');
    EcrireMenu(' 1- page précédente');
    EcrireMenu(' 0- maison');

    EcrireDescriptionAlert('Que voulez vous faire ?');

    SaisirChoix(choix);

    case choix of
    1: PageRecette(num-4);
    2: PageRecette(num+4);
    end;


  end;

end;

end.

