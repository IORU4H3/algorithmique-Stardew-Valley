//Unité en charge des plantes
unit UnitPlante; 
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface  
uses UnitGestionTemps,UnitObjet;
   
//------------------------------- TYPES ----------------------------------------
Type
  //Les différentes plantes
  TPlante = (RIEN,PPANAIS,PPOMMEDETERRE,PCHOUXFLEUR,PTOMATE,PPIMENT,PMELON,PAUBERGINE,PCITROUILLE,PIGNAME,PCAROTTE,PPOIREAU,PCELERI);
 
//-------------------------- SOUS PROGRAMMES -----------------------------------     
//Transforme un type plante en string
//entrée : le type plante
//sortie : la chaine de caractère
function TypePlanteToString(t : TPlante) : string;

//Renvoie la saison de culture du type de plante
//entrée : le type de plante
//sortie : la saison où ce type de plantes peut être cultivé
function SaisonDeTypePlante(t : TPlante) : TSaison;

//Renvoie le temps de maturation (en jours) du type de plantes
//entrée : le type de plantes
//sortie : le temps de maturation en jours
function TempsMaturation(t : TPlante) : integer;    

//Renvoie la plante associée à la graine
//entrée : la graine
//sortie : la plante associée
function GraineToPlante(objet : TObjet) : TPlante;

implementation
               
//Transforme un type plante en string
//entrée : le type plantes
//sortie : la chaine de caractère
function TypePlanteToString(t : TPlante) : string;
begin
  case(t) of
      PPANAIS: TypePlanteToString:='Panais';
      PPOMMEDETERRE: TypePlanteToString:='Pomme de terre';
      PCHOUXFLEUR: TypePlanteToString:='Choux-fleur';
      PTOMATE: TypePlanteToString:='Tomate';
      PPIMENT: TypePlanteToString:='Piment';
      PMELON: TypePlanteToString:='Melon';
      PAUBERGINE: TypePlanteToString:='Aubergine';
      PCITROUILLE: TypePlanteToString:='Citrouille';
      PIGNAME: TypePlanteToString:='Igname';
      PCAROTTE: TypePlanteToString:='Carotte';
      PPOIREAU: TypePlanteToString:='Poireau';
      PCELERI: TypePlanteToString:='Celeri';
  end;
end;

//Renvoie la plante associée à la graine
//entrée : la graine
//sortie : la plante associée
function GraineToPlante(objet : TObjet) : TPlante;
var
  TPlantePrintemps : array[1..3]of  TPlante;
begin
    TPlantePrintemps[1] := PPANAIS;
    TPlantePrintemps[2] := PPOMMEDETERRE;
    TPlantePrintemps[3] := PCHOUXFLEUR;

    GraineToPlante := RIEN;
    case(objet) of
      GRAINE_PANAIS : GraineToPlante := PPANAIS;
      GRAINE_POMMEDETERRE : GraineToPlante := PPOMMEDETERRE;
      GRAINE_CHOUXFLEUR : GraineToPlante := PCHOUXFLEUR;
      GRAINE_TOMATE : GraineToPlante := PTOMATE;
      GRAINE_PIMENT : GraineToPlante := PPIMENT;
      GRAINE_MELON : GraineToPlante := PMELON;
      GRAINE_AUBERGINE : GraineToPlante := PAUBERGINE;
      GRAINE_CITROUILLE : GraineToPlante := PCITROUILLE;
      GRAINE_IGNAME : GraineToPlante := PIGNAME;
      GRAINE_CAROTTE : GraineToPlante := PCAROTTE;
      GRAINE_POIREAU : GraineToPlante := PPOIREAU;
      GRAINE_CELERI : GraineToPlante := PCELERI;
      GRAINE_MYSTERE : GraineToPlante := TPlantePrintemps[random(3)]
    end;
end;

//Renvoie la saison de culture du type de plante
//entrée : le type de plantes
//sortie : la saison où ce type de plantes peut être cultivé
function SaisonDeTypePlante(t : TPlante) : TSaison;
begin
  case(t) of
      PPANAIS: SaisonDeTypePlante:=PRINTEMPS;
      PPOMMEDETERRE: SaisonDeTypePlante:=PRINTEMPS;
      PCHOUXFLEUR: SaisonDeTypePlante:=PRINTEMPS;
      PTOMATE: SaisonDeTypePlante:=ETE;
      PPIMENT: SaisonDeTypePlante:=ETE;
      PMELON: SaisonDeTypePlante:=ETE;
      PAUBERGINE: SaisonDeTypePlante:=AUTOMNE;
      PCITROUILLE: SaisonDeTypePlante:=AUTOMNE;
      PIGNAME: SaisonDeTypePlante:=AUTOMNE;
      PCAROTTE: SaisonDeTypePlante:=HIVERS;
      PPOIREAU: SaisonDeTypePlante:=HIVERS;
      PCELERI: SaisonDeTypePlante:=HIVERS;
  end;
end;

//Renvoie le temps de maturation (en jours) du type de plantes
//entrée : le type de plantes
//sortie : le temps de maturation en jours
function TempsMaturation(t : TPlante) : integer;
begin
  case(t) of
      PPANAIS: TempsMaturation:=4;
      PPOMMEDETERRE: TempsMaturation:=6;
      PCHOUXFLEUR: TempsMaturation:=12;
      PTOMATE: TempsMaturation:=11;
      PPIMENT: TempsMaturation:=5;
      PMELON: TempsMaturation:=12;
      PAUBERGINE: TempsMaturation:=5;
      PCITROUILLE: TempsMaturation:=13;
      PIGNAME: TempsMaturation:=10;
      PCAROTTE: TempsMaturation:=5;
      PPOIREAU: TempsMaturation:=7;
      PCELERI: TempsMaturation:=10;
  end;
end;

end.

