//Unité en charge des recettes pour la cuisine
unit UnitRecette;
{$codepage utf8}
{$mode ObjFPC}{$H+}
interface
uses
  UnitObjet;

//------------------------------- TYPES ----------------------------------------
Type
  //Ingredient pour une recette;
  TIngredient = record
    objet : TObjet;   //Type d'ingrédient
    quantite : integer;   //Quantité nécessaire
  end;

  //Tahleau d'au plus 3 ingredients (mettre l'objet "VIDE" si pas d'ingrédient)
  TTableauIngredient = array[1..3] of TIngredient;

  //Recette de cuisine
  TRecette = record
    nom:string;       //Nom de la recette
    stamina:integer;      //Quantité de stamina rendu
    ingredients:TTableauIngredient;
  end;

  //Un tableau de 3 recettes
  TTableauDeRecettes = array[1..3] of TRecette;
//-------------------------- SOUS PROGRAMMES -----------------------------------
//Initialisation des recettes
procedure InitRecettes();

//Renvoie le nom de la recette du numéro donné
//entrée : le numéro de la recette
function GetNomRecette(numRecette : integer) : string;

                  
//Renvoie l'affichage de l'ingrédient de la recette de numéro donné
//entrée : le numéro de la recette, le numéro de l'ingrédient
function GetNomIngredient(numRecette : integer; numIngredient : integer) : string;
   
//Renvoie le nombre de recettes existantes
function GetNombreRecettes() : integer;

implementation

uses SysUtils,UnitInventaire,UnitPersonnage;

var
  //Le tableau des recettes
  listeRecettes : TTableauDeRecettes;


//Crée un nouvel ingrédient à partir de l'objet de la quantité donnés en entrée
//entrée : l'objet de la quantité
//sortie : un nouvel ingredient
function NouveauIngredient(objet : TObjet; quantite : integer) : TIngredient;
begin
  NouveauIngredient.objet:=objet;
  NouveauIngredient.quantite:=quantite;
end;

//Crée une nouvelle recette à partir du nom de la quantité de stamina donnés en entrée
//entrée : le nom de la quantité de stamina
//sortie : une nouvelle recette
function NouvelleRecette(nom : string; stamina : integer) : TRecette;
var
  i:integer; //variable de boucle
begin
  //Initialisation du nom et de la quantité de stamina rendue
  NouvelleRecette.nom:=nom;
  NouvelleRecette.stamina:=stamina;

  //Initialisation des ingrédients à vide
  for i:= 1 to 3 do NouvelleRecette.ingredients[i] := NouveauIngredient(VIDE,0);
end;

//Initialisation des recettes
procedure InitRecettes();
begin
  listeRecettes[1] := NouvelleRecette('Saute de Panais',10);
  listeRecettes[1].ingredients[1] := NouveauIngredient(PANAIS,1);

  listeRecettes[2] := NouvelleRecette('Mijote de Tomate et Choux fleur',30);
  listeRecettes[2].ingredients[1] := NouveauIngredient(TOMATE,2);
  listeRecettes[2].ingredients[2] := NouveauIngredient(CHOUXFLEUR,1);

  listeRecettes[3] := NouvelleRecette('Salade de Carottes et Celeri',40);
  listeRecettes[3].ingredients[1] := NouveauIngredient(CAROTTE,2);
  listeRecettes[3].ingredients[2] := NouveauIngredient(CELERI,2);
end;

// Renvoie le nombre de recettes existantes
function GetNombreRecettes() : integer;
begin
  GetNombreRecettes := Length(listeRecettes);
end;

//Renvoie le nom de la recette du numéro donné
//entrée : le numéro de la recette
function GetNomRecette(numRecette : integer) : string;
begin
   GetNomRecette := listeRecettes[numRecette].nom;
end;

//Renvoie l'affichage de l'ingrédient de la recette de numéro donné
//entrée : le numéro de la recette, le numéro de l'ingrédient
function GetNomIngredient(numRecette : integer; numIngredient : integer) : string;
begin
  GetNomIngredient := '';
  if (listeRecettes[numRecette].ingredients[numIngredient].objet <> VIDE) AND (listeRecettes[numRecette].ingredients[numIngredient].quantite>0) then
     GetNomIngredient :=  IntToStr(listeRecettes[numRecette].ingredients[numIngredient].quantite) + 'x ' + ObjetToString(listeRecettes[numRecette].ingredients[numIngredient].objet);
end;


//Détermine si la recette de numéro donné est faisable ou non
//entrée : le numéro de la recette
function EstFaisable(numRecette : integer) : boolean;  
var
  i : integer; //Variable de boucle
begin
  //Initailisation
  EstFaisable := true;

  //On teste si le joueur possède les ingrédients
  for i := 1 to 3 do
  begin
    //Si il y a un ingredient numéro i
    if(listeRecettes[numRecette].ingredients[i].objet <> VIDE) then
    begin
       //On vérifie que le joueur possède assez d'exemplaires de l'ingrédient
       EstFaisable := (EstFaisable) AND (UnitInventaire.QuantitePossedeeDe(listeRecettes[numRecette].ingredients[i].objet) >= listeRecettes[numRecette].ingredients[i].quantite);
    end;
  end;
end;
   
//Réalisaela recette de numéro donné si elle est faisable
//entrée : le numéro de la recette
//sortie : la recette a-t-elle été faite ?
function FaireRecette(numRecette : integer) :  boolean;  
var
  i : integer; //Variable de boucle
begin
  //On teste si la recette est faisable
  FaireRecette := EstFaisable(numRecette);

  //Si la recette est faisable on la fait
  if(FaireRecette) then
  begin
     //On supprimet les ingrédients
     for i := 1 to 3 do
       if(listeRecettes[numRecette].ingredients[i].objet <> VIDE) then
          UnitInventaire.EnleverObjet(listeRecettes[numRecette].ingredients[i].objet,listeRecettes[numRecette].ingredients[i].quantite);
     //On rajoute la stamia
     UnitPersonnage.AjouterStamina(listeRecettes[numRecette].stamina);
  end;
end;

end.
