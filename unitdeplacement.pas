//Unité en charge de tout ce qui concerne les déplacements entre les différents lieux
unit UnitDeplacement; 
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface
//------------------------------- TYPES ----------------------------------------
//Les principaux différents lieux
Type TLieu = (MENU,MAISON,JARDIN,MAGASIN,EVANOUIR,EXIT, CUISINE);


//-------------------------- SOUS PROGRAMMES -----------------------------------
//Hub de gestion du déplacement entre les lieux
procedure Hub();








implementation
uses
  UnitMaisonIHM,UnitMenuIHM,UnitFermeIHM,UnitMagasinIHM,UnitCuisineIHM;

//Fonction gérant le déplacement. En fonction du lieu donné en paramètre appelle la fonction principale du lieu associé
//entrée : le lieu où le joueur se rend
//sortie : le prochain lieu
function SeRendreA(lieu : TLieu) : TLieu;
begin
     case(lieu) of
          MENU: SeRendreA := UnitMenuIHM.EcranMenuDemarrage();
          MAISON: SeRendreA := UnitMaisonIHM.EcranMaison();
          JARDIN: SeRendreA := UnitFermeIHM.EcranFerme();
          MAGASIN: SeRendreA := UnitMagasinIHM.EcranMagasin();
          EVANOUIR: SeRendreA := UnitMaisonIHM.EcranEvanouir();
          CUISINE:  SeRendreA := UnitCuisineIHM.EcranCuisine();
          EXIT: SeRendreA := EXIT;
     end;
end;


//Hub de gestion du déplacement entre les lieux
procedure Hub();
var
  lieuEnCours : TLieu; //Lieu où le joueur se trouve actuellement
begin
  //On commence au menu principal
  lieuEnCours := MENU;
  //Tant que le joueur ne décide pas de s'arréter de joueur, on se rend au lieu suivant
  while lieuEnCours <> EXIT do lieuEnCours := SeRendreA(lieuEnCours);
end;

end.

