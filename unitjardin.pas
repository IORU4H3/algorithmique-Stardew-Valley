//Unité en charge du jardin
unit UnitJardin;
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface

//-------------------------- SOUS PROGRAMMES -----------------------------------
//Initialisation du jardin
procedure InitJardin();

//Renvoie l'état du slot n du jardin
//entrée : numéro du slot
//sortie : son étant en chaine de caractères
function GetSlotAtString(n : integer) : string;      

//Essaye de planter l'objet en position n de votre inventaire
//entrée : numéro du slot de l'inventaire
//sortie : message
function Planter(n : integer) : string;

//Arrose une plante du jardin
//entrée : numéro du slot à arroser, l'arrosage est-il manuel
procedure Arroser(n : integer;manuel : boolean = true);

//Arracher une plante du jardin
//entrée : numéro du slot à arroser, l'arrachage est-il manuel
procedure Arracher(n : integer;manuel : boolean = true);

//Récolte un slot du jardin
//entrée : numéro du slot
//sortie : message
function Recolter(n : integer) : string;

//Fait passer le jour au jardin (le jour doit avoir été passé avant !)
procedure JourSuivantJardin();



implementation
uses UnitPlante,UnitInventaire,UnitGestionTemps,UnitObjet,UnitPersonnage;

Type
    //Un slot du jardin
    TSlotJardin = record
      plante : TPlante;         //Une plante
      maturation : integer;     //Maturation de la plante
      estArrose : boolean;      //Le slot est-il arrosé
      qualite : TQualite;       //Qualité de la plante
    end;

    //Un jardin = 40 slots
    TJardin = array[0..38] of TSlotJardin;

var
  //Le jardin du joueur
  jardin : TJardin;

//Crée un nouveau slot vide
function newSlotJardin() : TSlotJardin;
begin
   newSlotJardin.plante:=RIEN;
   newSlotJardin.maturation:=0;
   newSlotJardin.estArrose:=false;
   newSlotJardin.qualite:=BASE;
end;

//Initialisation du jardin
procedure InitJardin();
var
  i:integer; //variable de boucle
begin
   for i:=Low(jardin) to High(jardin) do jardin[i] := newSlotJardin();
end;

//Renvoie l'état du slot n du jardin
//entrée : numéro du slot
//sortie : son étant en chaine de caractères
function GetSlotAtString(n : integer) : string;
begin
   GetSlotAtString := 'Emplacement libre';
   if(jardin[n].plante <> RIEN) then
   begin
     //Nom de la plante
     GetSlotAtString := TypePlanteToString(jardin[n].plante) + ' - ';
     //Maturité
     if(jardin[n].maturation = 0) then GetSlotAtString += 'graine'
     else if(jardin[n].maturation < TempsMaturation(jardin[n].plante) div 2) then GetSlotAtString += 'jeune pousse'
     else if(jardin[n].maturation < TempsMaturation(jardin[n].plante)) then GetSlotAtString += 'presque mature'
     else GetSlotAtString += 'mature';
     //Arrosé ?
     if(jardin[n].estArrose) then GetSlotAtString += ' (arrosé)';
   end;
end;

//Tire une qualité aléatoire
function RandomQualite() : TQualite;
var
  alea : integer; //tirage aléatoire
begin
  alea := random(100);
  if(alea < 65) then RandomQualite:=BASE
  else if(alea < 85) then RandomQualite:=SILVER
  else if(alea < 95) then RandomQualite:=GOLD
  else RandomQualite := IRIDIUM;
end;

//Essaye de planter l'objet en position n de votre inventaire
//entrée : numéro du slot de l'inventaire
//sortie : message
function Planter(n : integer) : string;
var
  aPlante : boolean; //A-t-on déjà planté ?
  i:integer; //variable de boucle
begin
     Planter:='';
     aPlante := false;

     //Vérification que l'objet est bien une graine
     if(not EstGraine(n)) then Planter := 'Vous n''avez pas sélectionné une graine !'
     //Vérification que la plante est bien de la saison en cours
     else if(SaisonDeTypePlante(GraineToPlante(GetInventaire(n))) <> GetDate().saison) then Planter := 'Cette plante ne peut pas être plantée durant cette saison !'
     else
     begin
          //Vérification qu'il existe un emplacement libre et plante si c'est le cas
          for i:= low(jardin) to high(jardin) do
          begin
            if(jardin[i].plante = RIEN) AND (not aPlante) then
            begin
               aPlante:=true;
               jardin[i].plante := GraineToPlante(GetInventaire(n));
               jardin[i].qualite:= RandomQualite();
               EnleverUn(n);
               UseStamina(2); 
               UnitGestionTemps.AddMinuteToDate(25);
            end;
          end;
          if(not aPlante) then Planter:='Aucun emplacement disponible dans votre jardin !';
     end;

end;

//Arrose une plante du jardin
//entrée : numéro du slot à arroser, l'arrosage est-il manuel
procedure Arroser(n : integer;manuel : boolean = true);
begin
   if(jardin[n].plante <> RIEN) then
   begin
      jardin[n].estArrose:=true;
      if(manuel) then
      begin
         UseStamina(1);
         UnitGestionTemps.AddMinuteToDate(5);
      end;
   end;
end;

//Arracher une plante du jardin
//entrée : numéro du slot à arroser, l'arrachage est-il manuel
procedure Arracher(n : integer;manuel : boolean = true);
begin
   if(jardin[n].plante <> RIEN) then
   begin
      jardin[n] := newSlotJardin();
      if(manuel) then
      begin
           UseStamina(1);
           UnitGestionTemps.AddMinuteToDate(5);
      end;
   end;
end;

//Renvoie la récolte associé au slot
//entrée numéro du slot
function GetRecolte(n : integer) : TObjet;
begin
    GetRecolte := VIDE;
    case(jardin[n].plante) of
      PPANAIS: GetRecolte:=PANAIS;
      PPOMMEDETERRE: GetRecolte:=POMMEDETERRE;
      PCHOUXFLEUR: GetRecolte:=CHOUXFLEUR;
      PTOMATE: GetRecolte:=TOMATE;
      PPIMENT: GetRecolte:=PIMENT;
      PMELON: GetRecolte:=MELON;
      PAUBERGINE: GetRecolte:=AUBERGINE;
      PCITROUILLE: GetRecolte:=CITROUILLE;
      PIGNAME: GetRecolte:=IGNAME;
      PCAROTTE: GetRecolte:=CAROTTE;
      PPOIREAU: GetRecolte:=POIREAU;
      PCELERI: GetRecolte:=CELERI;
    end;
end;

//Récolte un slot du jardin
//entrée : numéro du slot
//sortie : message
function Recolter(n : integer) : string;
begin
   if(GetRecolte(n) <> VIDE) then
   begin
     //vérifie la maturation de la plante
     if(jardin[n].maturation >= TempsMaturation(jardin[n].plante)) then
     begin
          //check de l'inventaire
          if(AjouterUnObjet(GetRecolte(n),jardin[n].qualite)) then
          begin
             Arracher(n,false);
             UseStamina(1);
             UnitGestionTemps.AddMinuteToDate(10);
          end
          else Recolter := 'Impossible de récolter cette plante, votre inventaire est plein';
     end
     else Recolter := 'Patience, la plante n''est pas arrivée à maturité !';
   end;
end;


//Fait passer le jour au jardin (le jour doit avoir été passé avant !)
procedure JourSuivantJardin();
var
  i:integer; //variable de boucle
begin
     //Changement de saison
     if(GetDate().num = 1) then 
       for i:= low(jardin) to high(jardin) do  jardin[i] := newSlotJardin();

     //On met à jour chaque plante
     for i:= low(jardin) to high(jardin) do
     begin
       if(jardin[i].estArrose) then
       begin
          jardin[i].maturation += 1;
          if(jardin[i].maturation > UnitPlante.TempsMaturation(jardin[i].plante)) then jardin[i].maturation := UnitPlante.TempsMaturation(jardin[i].plante);
          jardin[i].estArrose:=false;
       end;
     end;

     //Gestion de la météo
     if(FaitHumide()) then
     begin
        for i:= low(jardin) to high(jardin) do Arroser(i,false);
     end;
end;

end.

