//Unité IHM en charge de tout ce qui concerne la maison
unit UnitMaisonIHM;
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface
uses
  unitDeplacement;

//-------------------------- SOUS PROGRAMMES -----------------------------------
//Ecran principal de la maion
//sortie : le prochain lieu
function EcranMaison() : TLieu;

              
//Fonction appelée lors de l'évanouissement
//sortie : le lieu suivant (maison)
function EcranEvanouir() : TLieu;




implementation
uses
  UnitPersonnage,UnitGestionTemps,UnitIHM,UnitJardin,UnitCuisineIHM;



//fonction appelée quand le joueur dors 
//sorite : prochain lieu (Maison)
function Dormir() : TLieu;
begin
  //Restore l'endurance du joueur
  unitPersonnage.RestoreStamina();
  //Passe au jour suivant
  UnitGestionTemps.JourSuivant();
  //On fait passer le jour au jardin
  UnitJardin.JourSuivantJardin();
  //On reste à la maison
  Dormir := MAISON;
end;

//fonction appelée quand le joueur regarde la TV
//sorite : prochain lieu (Maison)
function TV() : TLieu;
begin
  //IHM
  BaseIHM('Lieu  : A la maison');
  AffichageMeteo(); //Description
  EcrireDescription('Vous allumez la télévision et la réglez sur la chaine météo en continue. Un homme au cheveux châtains apparaît alors sur l''écran de votre télévision avec derrière lui une'); 
  EcrireDescription('carte de la région. Le présentateur annonce alors : ');
  EcrireDescription();           
  EcrireDescription();
  EcrireDescription();
  EcrireDescription('"Bonjour et bienvenue sur KOZU 5... Votre source d''information numéro un pour la météo, les infos et le divertissement dans toute la vallée. Et maintenant les prévisions');
  EcrireDescription('météos pour demains :');  
  EcrireDescription();
  case(GetMeteoDemain()) of
      ENSOLEILLE: EcrireDescription('Le soleil illuminera toute la vallée demain. Préparez-vous à une journée chaude et ensoleillée !"');
      VENTEUX: EcrireDescription('Le soleil sera timide demain. De fortes bourrasques de vent sont à prévoir."');
      PLUIE: EcrireDescription('Le ciel de demain sera couvert de nuages. De la pluie est à prévoir toute la journée !"');
      TEMPETE: EcrireDescription('Attention, une tempête s''approche de la vallée. Attendez-vous à un vent fort et à de la pluis toute la journée de demain !"');
      NEIGE: EcrireDescription('Sortez les mouffles, les écharpes et les bonnets, des chutes de neige sont à prévoir pour la journée de demain !"');
  end;
  
  EcrireMenu('(Appuyez sur enter pour éteindre la télévision)');
  readln;
  TV := MAISON;

  //Gestion de l'évanouissement
  if(GetStamina() <= 0) or HeureEvanouir() then TV:=EVANOUIR;
end;

//Attend 30min
//sortie : le nouveau lieu (maison)
function Attendre() : TLieu;
begin
   UnitGestionTemps.AddMinuteToDate(30);
   Attendre:=MAISON;
end;

//Fonction appelée lors de l'évanouissement
//sortie : le lieu suivant (maison)
function EcranEvanouir() : TLieu;
begin
  //IHM
  BaseIHM('Lieu : Dans les vapes');
  AffichageMeteo();

  //Description
  EcrireDescription('Alors que la journée avance à grands pas dans la vallée, l''épuisement vous enveloppe comme une brume insidieuse. Vos paupières deviennent lourdes et vos pas se font incer');
  EcrireDescription('tains, le poids des responsabilités agricoles se faisant sentir. Dans un ultime effort, vous tentez de regagner la chaleur de votre maison, mais la fatigue est implacable.');                
  EcrireDescription('Vos genoux fléchissent, la vision se brouille, et finalement, vous succombez à l''épuisement, vous évanouissant sur le sol de votre ferme. Une obscurité bienveillante enve');
  EcrireDescription('loppe votre conscience alors que vous sombrez dans un sommeil réparateur, dans l''attente d''un nouveau jour empreint de promesses agricoles.');
                        
  EcrireDescription('');
  EcrireDescription('');
  EcrireDescription('(appuyez sur une touche pour vous réveiller)');
  readln;

  //Restore l'endurance du joueur à 50%
  unitPersonnage.RestoreStamina();
  unitPersonnage.UseStamina(50);
  //Passe au jour suivant
  UnitGestionTemps.JourSuivant();
  //On fait passer le jour au jardin
  UnitJardin.JourSuivantJardin();

  EcranEvanouir := MAISON;
end;

//Ecran principal de la maion
//sortie : le prochain lieu
function EcranMaison() : TLieu;
var
  choix : integer; //Choix fait par le joueur
begin

  choix := -2;
  while(((choix < -1) OR (choix > 4))) do
  begin
       //IHM
       BaseIHM('Lieu  : A la maison');
       AffichageMeteo();

       //Description
       EcrireDescription('Vous vous trouvez dans votre maison au coeur de la vallée, où des plantes ornementales créent une atmosphère paisible. Un lit confortable occupe le centre de la pièce, in-');
       EcrireDescription('vitant à la détente après une journée bien remplie à cultiver vos terres et à interagir avec les habitants locaux. Une douce lueur émane de la télévision, reposant sur une ');
       EcrireDescription('étagère à proximité, diffusant des informations utiles sur la météo, les événements à venir, et les nouvelles de la communauté. C''est un sanctuaire accueillant, un endroit');
       EcrireDescription('où vous pouvez recharger vos énergies et planifier vos aventures agricoles pour les jours à venir.');

       //Menu
       EcrireMenu('-1- Retour au menu principal');
       EcrireMenu();
       EcrireMenu(' 3- Attendre 30min');
       EcrireMenu(' 2- Regarder la TV');
       EcrireMenu(' 1- Dormir');
       EcrireMenu(' 0- Sortir de la maison');
       EcrireMenu(' 4- Aller à la cuisine');
       EcrireMenuAlert('Que voulez-vous faire ?');
       SaisirChoix(choix);

       //Exécution du choix
       case(choix) of
           -1: EcranMaison := MENU;           //Si le joueur veut revenir au menu principal
           0: EcranMaison := JARDIN;          //Si le joueur veut sortir de la maison
           1: EcranMaison := Dormir();        //Si le joueur veut dormir
           2: EcranMaison := TV();            //Si le joueur regarde la TV
           3: EcranMaison := Attendre();      //Si le joueur veut attendre 30min
           4: EcranMaison := EcranCuisine();      //Si le joueur veut aller dans la cuisine
       end;

       //Gestion de l'évanouissement
       if(GetStamina() <= 0) or HeureEvanouir() then EcranMaison:=EVANOUIR;
  end;
end;

end.

