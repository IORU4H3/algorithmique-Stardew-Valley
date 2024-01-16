//Unit en charge des bases de l'IHM
unit UnitIHM;
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface
//Dessine l'IHM de base (cadre, heures...)
//entrée : nom du lieu
procedure BaseIHM(lieu : string);

//Dessine l'IHM de base sans aucune info
//entrée : nom du lieu
procedure BaseIHMMinimal(lieu : string);

//Affiche le lieu où se trouve le joueur
procedure AfficherLieu(nomDuLieu : string);
             
//Ecrire une ligne du menu (de bas en haut)
//entree le texte à afficher   
//Valeur par défaut : ''
procedure EcrireMenu(texte : string = '');

//Ecrire une ligne du menu (de bas en haut) en couleur
//entree le texte à afficher
//Valeur par défaut : ''
procedure EcrireMenuAlert(texte : string = '');

//Ecrire une ligne de description
//entree le texte à afficher   
//Valeur par défaut : ''
procedure EcrireDescription(texte : string = '');

//Ecrire une ligne de description en couleur
//entree le texte à afficher
//Valeur par défaut : ''
procedure EcrireDescriptionAlert(texte : string = '');

//Ecrire une ligne de description en couleur erreur
//entree le texte à afficher
//Valeur par défaut : ''
procedure EcrireDescriptionError(texte : string = ''); 

//Ecrire une ligne en couleur erreur pour les écrans de plantes
//entree le texte à afficher
//Valeur par défaut : ''
procedure EcrireError(texte : string = '');

//Saisir un choix pour un menu
//Entrée/sortie : le choix
procedure SaisirChoix(var choix : integer);

//Affiche la météo du jour
procedure AffichageMeteo();




implementation
uses SysUtils,GestionEcran,UnitGestionTemps,UnitPersonnage,UnitDeplacement;

CONST
  LIGNEDEBUTMENU = 47; //Numéro de la ligne où débute le menu
  LIGNEDEBUTDESCRIPTION = 18;   //Numéro de la ligne où débute la zone de description

var
  ligneMenu : integer;  //Ligne actuelle du menu
  ligneDescription : integer; //Ligne actuelle de description





//Procédure écrivant le texte à partir de la position (x,y);
procedure EcrireEnXY(x,y : integer; texte : string);
begin
  deplacerCurseurXY(x,y);
  write(texte);
end;


//Saisir un choix pour un menu
//Entrée/sortie : le choix
procedure SaisirChoix(var choix : integer);
begin
  dessinerCadreXY(183,LIGNEDEBUTMENU-2,192,LIGNEDEBUTMENU,simple,white,black);
  deplacerCurseurXY(187,LIGNEDEBUTMENU-1);
  readln(choix);
end;

//Ecrire une ligne du menu (de bas en haut)
//entree le texte à afficher
//Valeur par défaut : ''
procedure EcrireMenu(texte : string = '');
begin
  EcrireEnXY(6,ligneMenu,texte);
  ligneMenu -= 1;
end;
             
//Ecrire une ligne du menu (de bas en haut) en couleur
//entree le texte à afficher
//Valeur par défaut : ''
procedure EcrireMenuAlert(texte : string = '');
begin
  couleurTexte(Cyan);
  EcrireEnXY(6,ligneMenu,texte);
  ligneMenu -= 1;
  couleurTexte(White);
end;


//Ecrire une ligne de description
//entree le texte à afficher   
//Valeur par défaut : ''
procedure EcrireDescription(texte : string = '');
begin
  EcrireEnXY(12,ligneDescription,texte);
  ligneDescription += 1;
end;

//Ecrire une ligne de description en couleur
//entree le texte à afficher
//Valeur par défaut : ''
procedure EcrireDescriptionAlert(texte : string = '');
begin               
  couleurTexte(Cyan);
  EcrireEnXY(12,ligneDescription,texte);
  ligneDescription += 1; 
  couleurTexte(White);
end;

//Ecrire une ligne de description en couleur erreur
//entree le texte à afficher
//Valeur par défaut : ''
procedure EcrireDescriptionError(texte : string = '');
begin
  couleurTexte(LightRed);
  EcrireEnXY(99-(length(texte) div 2),ligneDescription,texte);
  ligneDescription += 1;
  couleurTexte(White);
end;  

//Ecrire une ligne en couleur erreur pour les écrans de plantes
//entree le texte à afficher
//Valeur par défaut : ''
procedure EcrireError(texte : string = '');
begin
  couleurTexte(LightRed);
  EcrireEnXY(99-(length(texte) div 2),44,texte);
  couleurTexte(White);
end;

//Affiche les cadres extérieur et le titre
procedure AfficherCadres();
begin
  //Dessine le cadre extérieur
  dessinerCadreXY(1,2,197,49,simple,WHITE,BLACK);
  //Dessiner les cadres d'info
  dessinerCadreXY(1,2,99,8,simple,WHITE,BLACK);
  dessinerCadreXY(99,2,197,8,simple,WHITE,BLACK);
  //Dessin des jonctions
  deplacerCurseurXY(1,8);write(char(195));
  deplacerCurseurXY(99,8);write(char(193));
  deplacerCurseurXY(197,8);write(char(180));

  //Titre STARBUT VALLEY et son cadre
  dessinerCadreXY(99-25,0,99+25,4,double,WHITE,BLACK);
  EcrireEnXY(99-7,2,'STAR''BUT VALLEY');
end;

//Affiche le lieu où se trouve le joueur
procedure AfficherLieu(nomDuLieu : string);
begin
  deplacerCurseurXY(9,12);
  couleurTexte(Cyan);
  write(nomDuLieu);
  couleurTexte(White);
end; 


//Affiche la météo du jour
procedure AffichageMeteo();
begin
  deplacerCurseurXY(9,11);
  couleurTexte(Cyan);
  write('Météo : '+GetMeteoJourString());
  couleurTexte(White);
end;

//Affiche la date dans le cadre haut droit
procedure AfficherDate();
begin
  //Affiche l'année
  deplacerCurseurXY(148,4);
  write('Année : '+IntToStr(GetDate().annee));
  //Affiche la date
  deplacerCurseurXY(148,5);
  write('Date  : '+DateToString());
  //Affiche l'heure
  deplacerCurseurXY(148,6);
  write('Heure : '+HeureToString());
end;

//Affiche les info du joueur dans le cadre haut gauche
procedure AfficherInfoJoueur();
var
  strStamina : string;         //Chaine de caractères représentant la stamina
begin
  //Nom
  deplacerCurseurXY(23,4);
  write('Nom      : ' + GetNomPersonnage());

  //Stamina
  strStamina := IntToStr(GetStamina());
  while(Length(strStamina)<3) do strStamina := '0'+strStamina;
  strStamina := strStamina + '/' + IntToStr(GetStaminaMax());
  deplacerCurseurXY(23,5);
  write('Stamina  : ' + strStamina);

  //Argent
  deplacerCurseurXY(23,6);
  write('Argent   : ' + IntToStr(GetArgent()));
end;
  
//Dessine l'IHM de base sans aucune info
//entrée : nom du lieu
procedure BaseIHMMinimal(lieu : string);
begin
  //Efface l'écran
  effacerEcran();

  //Affiche les cadres principaux
  AfficherCadres();

  //Affichage du lieu
  AfficherLieu(lieu); 

  //Réinitialise les positions des textes
  ligneMenu := LIGNEDEBUTMENU;
  ligneDescription := LIGNEDEBUTDESCRIPTION;
end;

//Dessine l'IHM de base (cadre, heures...)
//entrée : nom du lieu
procedure BaseIHM(lieu : string);
begin

  //Affichage de l'IHM minimale
  BaseIHMMinimal(lieu);

  //Affiche la date
  AfficherDate();

  //Affichage des info du joueurs
  AfficherInfoJoueur();
end;

end.

