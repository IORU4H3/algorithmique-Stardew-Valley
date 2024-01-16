//Unité IHM en charge de tout ce qui concerne la ferme (= le jardin)
unit UnitFermeIHM;
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface
uses
    UnitDeplacement;
//-------------------------- SOUS PROGRAMMES -----------------------------------
//Ecran principal de la ferme
//sortie : le prochain lieu
function EcranFerme() : TLieu;





implementation
uses
    SysUtils,UnitIHM,UnitPersonnage,UnitJardin,GestionEcran,UnitInventaire,UnitGestionTemps;


//Affiche les emplacements des plantes du jardins
procedure AffichagePlantes();
var
  i : integer;
  strI : string;
begin
     for i := 0 to 38 do
     begin
        deplacerCurseurXY(15+65*(i div 13),15+2*(i mod 13));
        strI := IntToStr(i+1);
        if(Length(strI)<2) then strI := ' '+strI;
        if(GetSlotAtString(i) = 'Emplacement libre') then couleurTexte(darkgray);
        write(strI,'. ',GetSlotAtString(i));
        couleurTexte(White);
     end;
end;

  
//Ecran pour planter les graines
Procedure PlanterGraine();
var
  choix : integer; //Choix fait par le joueur
  objetStr : string; //L'objet en chaine de caractères
  i:integer; //Variable de boucles
  message : string; //Message d'alerte à afficher
  spaceStr : string; //Espacement pour alignement
begin

  choix := -1;
  message := '';
  while (choix <> 0) do
  begin
       //IHM
       BaseIHM('Lieu  : '+GetNomFerme());
       AffichageMeteo();

       //Description
       EcrireDescriptionAlert('Contenu de votre sac :');

       objetStr := InventaireToString(1);
       i:=1;
       while(objetStr <> '') do
       begin
            spaceStr := ' ';
            if(i<10) then spaceStr += ' ';
            EcrireDescription(spaceStr+IntToStr(i)+' - '+objetStr);
            i+=1;
            objetStr := InventaireToString(i);
       end;

       //Message d'erreur
       for i:=1 to 5 do EcrireDescription();
       if(message <> '') then EcrireDescriptionError('Action impossible : '+message);

       //Menu
       EcrireMenu('    0 - Quitter l''écran');
       EcrireMenu(' 1..n - Planter une graine');

       EcrireMenuAlert('Que voulez-vous faires ?');
       SaisirChoix(choix);

       //Exécution du choix
       case(choix) of
           1..15: message:=Planter(choix);
       end; 

       //Gestion de l'évanouissement
       if(GetStamina() <= 0) or HeureEvanouir() then
       begin
         choix := 0;
       end;
  end;

end;

//Ecran pour arroser les plantes
Procedure EcranArroser();
var
  choix : integer; //Choix fait par le joueur
  objetStr : string; //L'objet en chaine de caractères
  i:integer; //Varibale de boulce
begin

  choix := -1;
  while (choix <> 0) do
  begin
       //IHM
       BaseIHM('Lieu  : '+GetNomFerme());
       AffichageMeteo();


       //Affichage des plantes
       AffichagePlantes();

       //Menu
       EcrireMenu('    0 - Quitter l''écran');
       EcrireMenu(' 1..n - Arroser une plante');

       EcrireMenuAlert('Que voulez-vous faires ?');
       SaisirChoix(choix);

       //Exécution du choix
       case(choix) of
           1..39: Arroser(choix-1);
       end; 

       //Gestion de l'évanouissement
       if(GetStamina() <= 0) or HeureEvanouir() then
       begin
         choix := 0;
       end;
  end;

end;

//Ecran pour arracher les plantes
Procedure EcranArracher();
var
  choix : integer; //Choix fait par le joueur
  objetStr : string; //L'objet en chaine de caractères
  i:integer; //Varibale de boulce
begin

  choix := -1;
  while (choix <> 0) do
  begin
       //IHM
       BaseIHM('Lieu  : '+GetNomFerme());
       AffichageMeteo();


       //Affichage des plantes
       AffichagePlantes();

       //Menu
       EcrireMenu('    0 - Quitter l''écran');
       EcrireMenu(' 1..n - Arracher une plante');

       EcrireMenuAlert('Que voulez-vous faires ?');
       SaisirChoix(choix);

       //Exécution du choix
       case(choix) of
           1..39: Arracher(choix-1);
       end;

       //Gestion de l'évanouissement
       if(GetStamina() <= 0) or HeureEvanouir() then
       begin
         choix := 0;
       end;
  end;

end; 

//Ecran pour récolter les plantes
Procedure EcranRecolter();
var
  choix : integer; //Choix fait par le joueur
  objetStr : string; //L'objet en chaine de caractères
  i:integer; //Varibale de boulce
  message : string; //Message d'alerte à afficher
begin

  choix := -1;
  message := '';
  while (choix <> 0) do
  begin
       //IHM
       BaseIHM('Lieu  : '+GetNomFerme());
       AffichageMeteo();


       //Affichage des plantes
       AffichagePlantes();

       //Message d'erreur
       if(message <> '') then EcrireError(message);

       //Menu
       EcrireMenu('    0 - Quitter l''écran');
       EcrireMenu(' 1..n - Récolter une plante');

       EcrireMenuAlert('Que voulez-vous faires ?');
       SaisirChoix(choix);

       //Exécution du choix
       case(choix) of
           1..39: message := Recolter(choix-1);
           0: choix := 0;
       end;

       //Gestion de l'évanouissement
       if(GetStamina() <= 0) or HeureEvanouir() then
       begin
         choix := 0;
       end;
  end;

end;

//Ecran de gestion des plantes
function GererPlante() : TLieu;
var
  choix : integer; //Choix fait par le joueur
begin

  choix := -1;
  while (choix <> 0) do
  begin
       //IHM
       BaseIHM('Lieu  : '+GetNomFerme());
       AffichageMeteo();

       //Affichage des plantes
       AffichagePlantes();

       //Menu
       EcrireMenu(' 0 - Quitter l''écran');
       EcrireMenu(' 4 - Arracher une plante');
       EcrireMenu(' 3 - Récolter une plante');
       EcrireMenu(' 2 - Arroser une plante');
       EcrireMenu(' 1 - Planter une graine');

       EcrireMenuAlert('Que voulez-vous faires ?');
       SaisirChoix(choix);

       //Exécution du choix
       case(choix) of
           1: PlanterGraine();                //Planter une graine
           2: EcranArroser();                 //Arroser une plante
           3: EcranRecolter();
           4: EcranArracher();                //Arracher une plante
           0: GererPlante := JARDIN;          //Retour au menu précédent
       end; 
       //Gestion de l'évanouissement
       if(GetStamina() <= 0) or HeureEvanouir() then
       begin
         GererPlante:=EVANOUIR;
         choix := 0;
       end;
  end;

end;


//Ecran principal de la ferme
//sortie : le prochain lieu
function EcranFerme() : TLieu;  
var
  choix : integer; //Choix fait par le joueur
begin

  choix := -1;
  while((choix < 1) OR (choix > 3)) do
  begin
       //IHM
       BaseIHM('Lieu  : '+GetNomFerme());
       AffichageMeteo();

       //Description
       EcrireDescription('Juste devant votre humble demeure, s''étend un jardin potager resplendissant de vie. Des rangées soigneusement alignées de plants verts s''épanouissent sous le généreux bai-');
       EcrireDescription('ser du soleil, tandis que des fleurs colorées ajoutent une touche de gaieté à l''ensemble. Les carottes pointent fièrement leurs fanes hors de la terre fertile, les tomates');
       EcrireDescription('mûrissent en grappes juteuses, et les panais déploient leurs feuilles larges avec une promesse de récoltes abondantes. Les abeilles et les papillons dansent entre les dif-');
       EcrireDescription('férents plants, contribuant à l''équilibre naturel du jardin. Des herbes aromatiques embaument l''air, invitant à la cueillette pour agrémenter vos délicieux plats. C''est un');
       EcrireDescription('coin de paradis verdoyant, où l''effervescence de la nature coexiste harmonieusement avec le travail assidu du fermier.');

       //Menu
       EcrireMenu(' 3 - Gérer votre potager');    
       EcrireMenu(' 2 - Se rendre au magasin de Pierre');
       EcrireMenu(' 1 - Rentrer dans votre maison');

       EcrireMenuAlert('Que voulez-vous faires ?');
       SaisirChoix(choix);

       //Exécution du choix
       case(choix) of
           1: EcranFerme := MAISON;          //Si le joueur veut rentrer dans la maison
           2: begin                          //Si le joueur veut se rendre au magasin
                   EcranFerme := MAGASIN;
                   UnitGestionTemps.AddMinuteToDate(60);
              end;
           3: EcranFerme := GererPlante();   //Si le joueur veut gérer ses plantes
       end;
       //Gestion de l'évanouissement
       if(GetStamina() <= 0) or HeureEvanouir() then EcranFerme:=EVANOUIR;
  end;

end;

end.

