//Unité en charge de l'inventaire
unit UnitInventaire; 
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface
uses UnitObjet;
              
//------------------------------- TYPES ----------------------------------------
Type
  //Inventaire = 15 stacks (au max)
  TInventaire = array[1..15] of TStack;
                       
//-------------------------- SOUS PROGRAMMES -----------------------------------
//Initialise l'inventaire du joueur
procedure InitInventaire();
        
//Tente d'acheter un objet
//entrée : l'objet à ajouter
//sortie : raison de l'impossibilité ('' si possible)
function AcheterObjet(objet : TObjet) : string;

//Vend un slot de l'inventaire
//entrée : numéro du slot à vendre
procedure VendreSlot(n : integer);

//Renvoie le contenu du slot n de l'inventaire en chaine de caractères
//entrée : le numéro du slot
//sortie : la chaine de caractère
function InventaireToString(n : integer) : string;

//Calcul le prix de vente d'un slot de l'inventaire
//entrée : le numéro du slot
//sortie : son prix de vente
function PrixInventaire(n : integer) : integer;

//Le slot contient-il des graines ?
//entrée : le numéro du slot
//sortie : est-ce des graines
function EstGraine(n : integer): boolean;
            
//Renvoie l'objet à la position n de l'inventaire
//entree : numéro du slot
//sortie : l'objet
function GetInventaire(n : integer) : TObjet;
    
//Enlève 1 objet au slot
//entrée : le numéro du slot
procedure EnleverUn(n : integer);

//Essaye d'ajouter un objet à l'inventaire
function AjouterUnObjet(objet : TObjet; qualite : TQualite) : boolean;

//Améliore le sac
//sortie : le message
function AmeliorerSac() : string;

//Renvoie le prix de la prochaine amélioration du sac
function PrixAmeliorationSac() : integer;

//Retire un certains nombre d'exemplaires d'un objet du type demandé de qualité minimale
//entree : le type de l'objet et le nombre d'exemplaires
procedure EnleverObjet(objet : TObjet;quantite : integer);

//Renvoie la quantité possédée d'objets du type donné
//entree : le type de l'objet cherché
function QuantitePossedeeDe(objet : TObjet) : integer;

// ajouter une graine
procedure AjouterObjet(objet : TObjet; qualite : TQualite);

implementation
uses
    UnitPersonnage,SysUtils;
const
  NUMSLOTSINVENTAIRERANG1 = 5;         //Nombre de slots dans l'inventaire de base
  NUMSLOTSINVENTAIRERANG2 = 10;        //Nombre de slots dans l'inventaire amélioré
  NUMSLOTSINVENTAIRERANG3 = 15;        //Nombre de slots dans l'inventaire maximum
var
  //inventaire du joueur
  inventaire : TInventaire;
  //nombre de slots disponibles dans l'inventaire
  numSlotsInventaire : integer;

//Initialise l'inventaire du joueur
procedure InitInventaire();
var
  i:integer; //variable de boucle
begin
  //Vide l'inventaire
  for i:= Low(inventaire) to High(inventaire) do
     inventaire[i] := UnitObjet.CreerStackVide();

  //Fixe le nombre de slot au min
  numSlotsInventaire := NUMSLOTSINVENTAIRERANG1;
end;

//Est-il possible d'ajouter un objet au stack donné
//entrée : l'objet et le stack
//sortie : l'ajout est-il possible
function CanAddToStack(objet : TObjet; stack : TStack; qualite : TQualite) : boolean;
begin
    CanAddToStack := false;
    if(stack.objet = VIDE) then CanAddToStack:=true
    else if (stack.objet = objet) AND (stack.num <5) AND (stack.qualite = qualite) then CanAddToStack:=true;
end;

//Ajoute l'objet à l'inventaire
//entrée : objet à ajouter et sa qualite
procedure AjouterObjet(objet : TObjet; qualite : TQualite);
var
  i:integer;    //variable de boucle
  ajoutFait:boolean; //L'ajout a-t-il déjà été fait ?
begin
  ajoutFait := false;

  //On cherche si un stack contient déjà ce type d'objet et n'est pas plein
  for i:=1 to numSlotsInventaire do
  begin
    if(inventaire[i].objet = objet) and (inventaire[i].num<5) and (inventaire[i].qualite = qualite) and (not ajoutFait) then
    begin
        inventaire[i].num += 1;
        ajoutFait := true;
    end;
  end;

  //Si ce n'est pas le cas, on cherche un slot vide
  if(not ajoutFait) then
  begin
    for i:=1 to numSlotsInventaire do
    begin
      if(inventaire[i].objet = VIDE) and (not ajoutFait) then
      begin
          inventaire[i].objet := objet;
          inventaire[i].num := 1;
          inventaire[i].qualite := qualite;
          ajoutFait := true;
      end;
    end;
  end;
end;  


//Peut on ajouter l'objet à l'inventaire
//entrée : l'objet que l'on souhaite ajouter et sa qualité
function PeutAjouterObjet(objet : TObjet; qualite : TQualite) : boolean;
var
  i:integer; //variable de boucle
begin
  PeutAjouterObjet:=false;
  for i:=1 to numSlotsInventaire do
      if(CanAddToStack(objet,inventaire[i],qualite)) then PeutAjouterObjet:= true;
end;

//Essaye d'ajouter un objet à l'inventaire  
//entrée : l'objet que l'on souhaite ajouter et sa qualité
function AjouterUnObjet(objet : TObjet; qualite : TQualite) : boolean;
var
  ajoutPossible : boolean; //l'ajout est-il possible ?
  i:integer; //variable de boucle
begin
     ajoutPossible := true;

     //Vérifie que le joueur a la place dans son inventaire
     if(not PeutAjouterObjet(objet,qualite)) then
     begin
          ajoutPossible := false;
     end;

     //Effectue l'achat s'il est possible
     if(ajoutPossible) then AjouterObjet(objet,qualite);

     AjouterUnObjet:=ajoutPossible;
end;

//Tente d'acheter un objet
//entrée : l'objet à ajouter
//sortie : raison de l'impossibilité ('' si possible)
function AcheterObjet(objet : TObjet) : string;
var
  achatPossible : boolean; //l'achat est-il possible ?
  i:integer; //variable de boucle
begin
     AcheterObjet := '';
     achatPossible := true;

     //Vérifie que le joueur a assez d'argent
     if(GetArgent()<PrixAchat(objet)) then
     begin
          achatPossible := false;
          AcheterObjet := 'Vous n''avez pas assez d''argent';
     end;
      
     //Vérifie que le joueur a la place dans son inventaire
     if (achatPossible) then
     begin
       if(not PeutAjouterObjet(objet,BASE)) then
       begin
            achatPossible := false;
            AcheterObjet := 'Votre inventaire est plein';
       end;
     end;

     //Effectue l'achat s'il est possible
     if(achatPossible) then
     begin
       AddArgent(-PrixAchat(objet));
       AjouterObjet(objet,BASE);
     end;
end;
     
//Vend un slot de l'inventaire
//entrée : numéro du slot à vendre
procedure VendreSlot(n : integer);
var
  i:integer;  //variable de boucle
begin
  //Ajoute l'argent
  AddArgent(PrixInventaire(n));
  //Décale l'inventaire
  for i:=n to High(inventaire)-1 do
  begin
    inventaire[i] := inventaire[i+1];
  end;
  //Supprime le dernier slot
  inventaire[High(inventaire)] := CreerStackVide();
end;

//Enlève 1 objet au slot
//entrée : le numéro du slot
procedure EnleverUn(n : integer);
var
  i:integer;  //variable de boucle
begin
  //Enlève 1 au slot
  inventaire[n].num -= 1;

  //Décale l'inventaire si le slot est vide
  if(inventaire[n].num = 0) then
  begin
    for i:=n to High(inventaire)-1 do
    begin
      inventaire[i] := inventaire[i+1];
    end;
    //Supprime le dernier slot
    inventaire[High(inventaire)] := CreerStackVide();
  end;
end;

//Renvoie la quantité possédée d'objets du type donné
//entree : le type de l'objet cherché
function QuantitePossedeeDe(objet : TObjet) : integer;
var
  i : integer; //Variable de boucle
begin
  QuantitePossedeeDe:=0;
  for i:=1 to numSlotsInventaire do
    if(inventaire[i].objet = objet) then QuantitePossedeeDe += inventaire[i].num;
end;

//Retire 1 objet du type demandé de qualité minimale
//entree : le type de l'objet
procedure EnleverUnObjet(objet : TObjet);
var
  numSlot : integer; //Numéro du slot où l'objet se trouve
  valeurQualite : integer; //Valeur de la qualité minimale trouvée
  i : integer; //Variable de boucle
begin
  //Initialisation
  numSlot := Low(inventaire)-1;
  valeurQualite := ord(Low(TQualite)) - 1;

  //On parcourt l'inventaire pour trouver le slot ayant l'objet à supprimer de qualité min
  for i:=1 to numSlotsInventaire do
  begin
       //Si un slot contient le type d'objet
       if(inventaire[i].objet = objet) AND (inventaire[i].num>0) then
       begin
            if(valeurQualite < ord(Low(TQualite))) OR (valeurQualite>ord(inventaire[i].qualite)) then
            begin
               valeurQualite := ord(inventaire[i].qualite);
               numSlot := i;
            end;
       end;
  end;

  //Si on a trouvé un slot on enlève 1 à ce slot
  if(numSlot>=Low(inventaire)) then EnleverUn(numSlot);
end;

//Retire un certains nombre d'exemplaires d'un objet du type demandé de qualité minimale
//entree : le type de l'objet et le nombre d'exemplaires
procedure EnleverObjet(objet : TObjet;quantite : integer);
var
  i:integer; //Variable de boucle
begin
  for i:=1 to quantite do EnleverUnObjet(objet);
end;

//Renvoie le contenu du slot n de l'inventaire en chaine de caractères
//entrée : le numéro du slot
//sortie : la chaine de caractère
function InventaireToString(n : integer) : string;
begin
     InventaireToString := '';
     if(inventaire[n].objet <> VIDE) then InventaireToString := IntToStr(inventaire[n].num) + 'x ' + ObjetToString(inventaire[n].objet) + QualiteToString(inventaire[n].qualite);
end;

//Calcul le prix de vente d'un slot de l'inventaire
//entrée : le numéro du slot
//sortie : son prix de vente
function PrixInventaire(n : integer) : integer;
begin
  PrixInventaire := 0;
  if(inventaire[n].objet <> VIDE) then PrixInventaire:=inventaire[n].num * PrixVente(inventaire[n].objet,inventaire[n].qualite);
end;

//Le slot contient-il des graines ?
//entrée : le numéro du slot
//sortie : est-ce des graines
function EstGraine(n : integer): boolean;
begin
  EstGraine := EstGraineObjet(inventaire[n].objet);
end;

//Renvoie l'objet à la position n de l'inventaire
//entree : numéro du slot
//sortie : l'objet
function GetInventaire(n : integer) : TObjet;
begin
  GetInventaire := inventaire[n].objet;
end; 

//Améliore le sac
//sortie : le message
function AmeliorerSac() : string;
begin
  if(UnitPersonnage.GetArgent()<PrixAmeliorationSac()) then AmeliorerSac := 'Vous n''avez pas assez d''argent'
  else
  begin
    AmeliorerSac:='';
    UnitPersonnage.AddArgent(-PrixAmeliorationSac());
    case(numSlotsInventaire) of
      NUMSLOTSINVENTAIRERANG1: numSlotsInventaire:=NUMSLOTSINVENTAIRERANG2;
      NUMSLOTSINVENTAIRERANG2: numSlotsInventaire:=NUMSLOTSINVENTAIRERANG3;
    end;
  end;
end;

//Renvoie le prix de la prochaine amélioration du sac
function PrixAmeliorationSac() : integer;
begin
  PrixAmeliorationSac := 0;
  case(numSlotsInventaire) of
    NUMSLOTSINVENTAIRERANG1: PrixAmeliorationSac:=1000;
    NUMSLOTSINVENTAIRERANG2: PrixAmeliorationSac:=2000;
  end;
end;

end.

