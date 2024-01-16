//Unité en charge de tout ce qui concerne le personnage
unit UnitPersonnage; 
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface
         uses UnitObjet, UnitInventaire;
            
//-------------------------- SOUS PROGRAMMES -----------------------------------
//Renvoie le nom du joueur
function GetNomPersonnage() : string;  
//Change le nom du joueur
//entrée : le nom du jouer
procedure SetNomPersonnage(nom : string);

//Renvoie le nom de la ferme
function GetNomFerme() : string;  
//Change le nom de la ferme
//entrée : le nouveau nom de la ferme
procedure SetNomFerme(nom : string);

//Renvoie l'endurance du joueur
function GetStamina() : integer;   
//Renvoie le maximum d'endurance possible pour le personnage
function GetStaminaMax() : integer;
//Retire une certaine quantité d'endurance au personnage
//entrée : la quantité d'endurance à enlever
procedure UseStamina(valeur : integer);
//Retrore l'intégralité de la stamina au joueur
procedure RestoreStamina();   
//Ajoute une certaine quantité de la stamina au joueur
//entrée : la quantité d'endurance à ajouter
procedure AjouterStamina(qte : integer);

//Renvoie l'argent du joueur
function GetArgent() : integer;
//Ajoute la quantité d'argent donnée
//entrée : quantité à ajouter
procedure AddArgent(value : integer);


//Initialise le personnage
procedure InitPersonnage();





implementation

const
  STAMINAMAX = 100;                       //Endurance maximum du personnage

var
   nomPersonnage : string;                //Nom du personnage
   nomFerme : string;                     //Nom de la ferme
   stamina : integer;                     //Endurance du personnage
   argent : integer;                      //Argent du personnage

//Renvoie le nom du joueur
function GetNomPersonnage() : string;
begin
  GetNomPersonnage := nomPersonnage;
end;

//Change le nom du joueur
//entrée : le nom du jouer
procedure SetNomPersonnage(nom : string);
begin
  if(nom = '') then nomPersonnage := 'Je ne sais pas écrire mon nom :('
  else nomPersonnage := nom;
end;

//Renvoie le nom de la ferme
function GetNomFerme() : string;
begin
  GetNomFerme := nomFerme;
end;

//Change le nom de la ferme
//entrée : le nouveau nom de la ferme
procedure SetNomFerme(nom : string);
var
   i : integer;
begin
  if(nom = '') then nomFerme := 'Département GEA'
  else if (nom = 'IUT') or (nom = 'iut') then
       begin

         for i := 1 to 5 do
           begin
               AjouterObjet(PANAIS, IRIDIUM);
               AjouterObjet(PANAIS, SILVER);
               AjouterObjet(TOMATE, IRIDIUM);
               AjouterObjet(CHOUXFLEUR, IRIDIUM);
               AjouterObjet(CAROTTE, IRIDIUM);
           end;

         argent := 10000;
         nomFerme := nom;
       end
  else nomFerme := nom;
end;

//Renvoie l'endurance du joueur
function GetStamina() : integer;
begin
  GetStamina := stamina;
end;

//Renvoie le maximum d'endurance possible pour le personnage
function GetStaminaMax() : integer;
begin
  GetStaminaMax := STAMINAMAX;
end;

//Retire une certaine quantité d'endurance au personnage
//entrée : la quantité d'endurance à enlever
procedure UseStamina(valeur : integer);
begin
  //Retire la valeur à l'endurance du joueur
  stamina := stamina - valeur;
  //Minore la stamina à 0
  if(stamina < 0) then stamina := 0;
end;

//Retrore l'intégralité de la stamina au joueur
procedure RestoreStamina();
begin
  stamina := STAMINAMAX;
end;

//Ajoute une certaine quantité de la stamina au joueur
//entrée : la quantité d'endurance à ajouter
procedure AjouterStamina(qte : integer);
begin
  //On ajoute la quantité de stamina données
  stamina += qte;
  //Majore la stamina au max
  if(stamina > STAMINAMAX) then stamina := STAMINAMAX;
end;
     
//Renvoie l'argent du joueur
function GetArgent() : integer;
begin
  GetArgent := argent;
end;

//Ajoute la quantité d'argent donnée
//entrée : quantité à ajouter
procedure AddArgent(value : integer);
begin
  argent += value;
end;

//Initialise le personnage
procedure InitPersonnage();
begin
     nomPersonnage := 'Pas de nom';
     nomFerme := 'La Ferme';
     stamina := STAMINAMAX;
     argent := 200;
end;

end.

