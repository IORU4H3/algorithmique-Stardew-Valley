//Unité en charge des menus principaux
unit UnitMenuIHM;     
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface
uses
  UnitDeplacement, UnitFileGestion, SysUtils;

//-------------------------- SOUS PROGRAMMES -----------------------------------
//Menu de démarrage
//sortie : le lieu suivant
function EcranMenuDemarrage() : TLieu;
function RestaurerPartie(): Tlieu;   // quand on a une sauvegarde, on restaure notre jeu
function EcranSauver() : TLieu;








implementation
uses
  UnitIHM,GestionEcran,UnitGestionTemps,UnitPersonnage,UnitInventaire,UnitJardin,UnitRecette;


procedure CreationPersonnage();
var
  nom : string;  //Nom du personnage
  nomFerme : string; //Nom de la ferme
begin
   BaseIHMMinimal('Création du personnage');

   EcrireDescription('Bienvenue dans le monde de STAR''BUT Valley. Epuisé par le stress de la vie à Dijon, de l''IUT, des cours à 8h, des QCM de math et des SAE, vous avez décidé de vous réfugier');
   EcrireDescription('loin du bruit de la ville au coeur de la vallée verdoillante de STAR''BUT. Vos ancêtres y possédaient une petite ferme que vous avez décidé de reprendre. Quoi de plus repo');
   EcrireDescription('sant que de faire pousser des légumes, bercé par le chant des oiseaux et de la rivière voisine...');
   EcrireDescription('');
   EcrireDescription('Avant de commencer cette paisible aventure, il me faut vous demander :');
   EcrireDescription('');
   couleurTexte(Cyan);
   EcrireDescription('Comment vous appelez-vous ? ');
   couleurTexte(White);
   readln(nom);
   couleurTexte(Cyan);
   EcrireDescription('Quel est le nom de la ferme de vos ancêtres ? ');
   couleurTexte(White);
   readln(nomFerme);  
   EcrireDescription('');
   EcrireDescription('Merci ! (appuyez sur une touche pour débuter l''aventure)');

   //Traitement des données
   SetNomPersonnage(nom);
   SetNomFerme(nomFerme);
end;

//Initialise une nouvelle partie
function NouvellePartie() : TLieu;
begin                     
  //Initialisation de la partie
  InitDate();                        //La date et la météo
  InitPersonnage();                  //Le personnage
  InitInventaire();                  //L'inventaire du joueur
  InitJardin();                      //Le jardin
  InitRecettes();                    //Les recettes

  //Création du personnage
  CreationPersonnage();

  NouvellePartie := MAISON;
end;

// fonction à part qui gère la sauvegarde après avoir joué
function EcranSauver() : TLieu;
begin
  effacerEcran();

  // on gére la sauvegarde lorsque l'on sort du jeu...
  EcrireFichier('sauvegarde.txt', GetNomPersonnage(), GetNomFerme(), GetStamina(), GetDate());

  deplacerCurseurXY(90,20);writeln('La partie a été sauvegardé :)');
  deplacerCurseurXY(90,21);writeln('    Appuyez sur ENTRER...    ');
  readln;

  EcranSauver := EcranMenuDemarrage;
end;

function RestaurerPartie(): Tlieu;
var
  c : array of string;
  j : TJour;
  s : TSaison;
begin

  c := LireFichier('sauvegarde.txt');

  SetNomPersonnage(c[0]);
  SetNomFerme(c[1]);
  SetStamina(strtoint(c[2]));


  case c[5] of
    'LUNDI': j := LUNDI;
    'MARDI': j := MARDI;
    'MERCREDI': j := MERCREDI;
    'JEUDI': j := JEUDI;
    'VENDREDI': j := VENDREDI;
    'SAMEDI': j := SAMEDI;
    'DIMANCHE': j := DIMANCHE;
  end;

  case c[7] of
    'PRINTEMPS': s := PRINTEMPS;
    'ETE': s := ETE;
    'AUTOMNE': s := AUTOMNE;
    'HIVERS': s := HIVERS;
  end;

  SetDate(strtoint(c[3]), strtoint(c[4]), strtoint(c[6]), strtoint(c[8]), j, s);



  InitJardin();                      //Le jardin
  InitRecettes();                    //Les recettes

  RestaurerPartie := MAISON;
end;


//Affiche le logo
procedure Logo();
var
  x,y:integer; //Position du curseur de début de ligne
begin
  x:=35;
  y:=7;

couleurTexte(Yellow);
deplacerCurseurXY(x,y);writeln('  ██████████████═╗ ████████████████═╗   ██████████═╗   ████████████═╗   ████████████═╗   ████═╗      ████═╗ ████████████████═╗ ');
deplacerCurseurXY(x,y+1);writeln('  ██████████████ ║ ████████████████ ║   ██████████ ║   ████████████ ║   ████████████ ║   ████ ║      ████ ║ ████████████████ ║ ');
deplacerCurseurXY(x,y+2);writeln('  ████ ╔═════════╝ ╚═════████ ╔═════╝ ████╔═════████═╗ ████ ╔════████═╗ ████ ╔════████═╗ ████ ║      ████ ║ ╚═════████ ╔═════╝ ');
deplacerCurseurXY(x,y+3);writeln('  ████ ║                 ████ ║       ████║     ████ ║ ████ ║    ████ ║ ████ ║    ████ ║ ████ ║      ████ ║       ████ ║       ');
deplacerCurseurXY(x,y+4);writeln('  ██████████████═╗       ████ ║       ██████████████ ║ ████████████ ╔═╝ ████████████ ╔═╝ ████ ║      ████ ║       ████ ║       ');
deplacerCurseurXY(x,y+5);writeln('  ██████████████ ║       ████ ║       ██████████████ ║ ████████████ ║   ████████████ ║   ████ ║      ████ ║       ████ ║       ');
deplacerCurseurXY(x,y+6);writeln('  ╚═════════████ ║       ████ ║       ████ ╔════████ ║ ████ ╔════████═╗ ████ ╔════████═╗ ████ ║      ████ ║       ████ ║       ');
deplacerCurseurXY(x,y+7);writeln('            ████ ║       ████ ║       ████ ║    ████ ║ ████ ║    ████ ║ ████ ║    ████ ║ ████ ║      ████ ║       ████ ║       ');
deplacerCurseurXY(x,y+8);writeln('  ██████████████ ║       ████ ║       ████ ║    ████ ║ ████ ║    ████ ║ ████████████ ╔═╝ ║████████████ ╔══╝       ████ ║       ');
deplacerCurseurXY(x,y+9);writeln('  ██████████████ ║       ████ ║       ████ ║    ████ ║ ████ ║    ████ ║ ████████████ ║   ╚████████████ ║          ████ ║       ');
deplacerCurseurXY(x,y+10);writeln('  ╚══════════════╝        ╚═══╝        ╚═══╝     ╚═══╝  ╚═══╝     ╚═══╝ ╚════════════╝     ╚═══════════╝           ╚═══╝       ');
deplacerCurseurXY(x,y+11);writeln();
deplacerCurseurXY(x,y+12);writeln();
deplacerCurseurXY(x,y+13);writeln('        ████═╗      ████═╗   ██████████═╗   ████═╗           ████═╗           ██████████████═╗ ████═╗      ████═╗ ');
deplacerCurseurXY(x,y+14);writeln('        ████ ║      ████ ║   ██████████ ║   ████ ║           ████ ║           ██████████████ ║ ████ ║      ████ ║');
deplacerCurseurXY(x,y+15);writeln('        ████ ║      ████ ║ ████╔═════████═╗ ████ ║           ████ ║           ████ ╔═════════╝ ╚═████═╗  ████ ╔═╝  ');
deplacerCurseurXY(x,y+16);writeln('        ████ ║      ████ ║ ████║     ████ ║ ████ ║           ████ ║           ████ ║             ████ ║  ████ ║    ');
deplacerCurseurXY(x,y+17);writeln('        ████ ║      ████ ║ ██████████████ ║ ████ ║           ████ ║           ██████████═╗       ╚═████████ ╔═╝  ');
deplacerCurseurXY(x,y+18);writeln('        ████ ║      ████ ║ ██████████████ ║ ████ ║           ████ ║           ██████████ ║         ████████ ║   ');
deplacerCurseurXY(x,y+19);writeln('        ╚═████═╗  ████ ╔═╝ ████ ╔════████ ║ ████ ║           ████ ║           ████ ╔═════╝         ╚═████ ╔═╝  ');
deplacerCurseurXY(x,y+20);writeln('          ████ ║  ████ ║   ████ ║    ████ ║ ████ ║           ████ ║           ████ ║                 ████ ║    ');
deplacerCurseurXY(x,y+21);writeln('          ╚═████████ ╔═╝   ████ ║    ████ ║ ██████████████═╗ ██████████████═╗ ██████████████═╗       ████ ║  ');
deplacerCurseurXY(x,y+22);writeln('            ████████ ║     ████ ║    ████ ║ ██████████████ ║ ██████████████ ║ ██████████████ ║       ████ ║  ');
deplacerCurseurXY(x,y+23);writeln('             ╚═══════╝      ╚═══╝     ╚═══╝  ╚═════════════╝  ╚═════════════╝  ╚═════════════╝        ╚═══╝ ');
couleurTexte(White);
end;

//Menu de démarrage
//sortie : le lieu suivant
function EcranMenuDemarrage() : TLieu;
var
  choix : integer; //Choix pour le menu
begin
  choix := -1;
  while (choix <> 0) AND (choix <> 1) AND (choix <> 2) do
  begin
    //Fixe la taille de la fenetre
    GestionEcran.changerTailleConsole(199,50);
    //Efface l'écran
    effacerEcran();

    //Affiche le titre
    Logo();
    //Menu

    // FichierVide('sauvegarde.txt') 

    deplacerCurseurXY(75,38);writeln('1 - Nouvelle partie');
    deplacerCurseurXY(75,39);writeln('2 - Charger partie');
    deplacerCurseurXY(75,40);writeln('0 - Quitter');
    deplacerCurseurXY(75,41);readln(choix);

    case(choix) of
      0 : EcranMenuDemarrage := EXIT;
      1 : EcranMenuDemarrage := NouvellePartie;
      2 : EcranMenuDemarrage := RestaurerPartie;
    end;
  end;
end;

end.

