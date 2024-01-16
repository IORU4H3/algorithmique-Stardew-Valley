unit UnitCuisineIHM;

{$mode objfpc}{$H+}
{$codepage utf8}

interface
uses
  UnitDeplacement;

function EcranCuisine(): TLieu; // écran général de la cuisine
procedure AfficherRecette(numRecette: integer; position: integer); // on affiche le nom et les ingredients des recettes
Procedure PageRecettes(num: integer); // correpond à une page de recette (3 recettes par pages)


implementation
uses UnitIHM, SysUtils, UnitRecette;


procedure AfficherRecette(numRecette: integer; position: integer);
var
  i : integer;
begin
  if (numRecette <= GetNombreRecettes()) and (numRecette>0) then // si la recette existe
  begin

    // on affiche la position et le nom de la recette
    EcrireDescription(' '+IntToStr(position)+'- '+GetNomRecette(numRecette));

    for i := 1 to 3 do // au max 3 ingredients
        if  GetNomIngredient(numRecette, i) <> '' then // s'il y a des ingredients, on les affiches
            EcrireDescription('   '+GetNomIngredient(numRecette, i));
  end;
end;

function EcranCuisine(): TLieu; // écran principal
begin
  PageRecettes(1);
  EcranCuisine := MAISON; // la cuisine est dans la maison
end;

Procedure PageRecettes(num: integer);
var
  choix: integer;
  i: integer;
begin
  choix := -1;
  while (choix <> 0) do // temps qu'il y a des recettes à afficher
  begin

    BaseIHM('Lieu : La cuisine');
    AffichageMeteo();

    EcrireDescriptionAlert('Liste des recettes');


    for i := 1 to 4 do  // on affiche les recettes
    begin
      EcrireDescription('');
      if num+i = GetNombreRecettes+2  then   // si on a plus de recettes, on arrête
         choix := 0
      else
          AfficherRecette(num+i-1,i);
    end;

    EcrireMenu(' 2- page suivante');
    EcrireMenu(' 1- page précédente');
    EcrireMenu(' 0- maison');

    EcrireDescriptionAlert('Que voulez vous faire ?');

    SaisirChoix(choix);

    // les pages suivantes / precedantes.
    case choix of
      1: PageRecettes(num-4);
      2: PageRecettes(num+4);
    end;

  end;

end;

end.

