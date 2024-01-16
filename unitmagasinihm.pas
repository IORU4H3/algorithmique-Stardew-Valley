//Unité IHM en charge de tout ce qui concerne le magasin
unit UnitMagasinIHM;
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface
uses
    UnitDeplacement;
//-------------------------- SOUS PROGRAMMES -----------------------------------
//Ecran principal du magasin
//sortie : le prochain lieu
function EcranMagasin() : TLieu;



implementation
uses
    UnitIHM,UnitObjet,UnitInventaire,SysUtils,UnitPersonnage,UnitGestionTemps;


function EcranVente() : TLieu;
var
  choix : integer; //Choix fait par le joueur
  objetStr : string; //L'objet en chaine de caractères
  i:integer; //Varibale de boulce
  spaceStr : string; //Espacement pour alignement
begin
  choix := -1;
  while (choix <> 0) do
  begin
       //IHM
       BaseIHM('Lieu  : Le magasin de Pierre');
       AffichageMeteo();

       //Description
       EcrireDescriptionAlert('Contenu de votre sac :');

       objetStr := InventaireToString(1);
       i:=1;
       while(objetStr <> '') do
       begin
            spaceStr := ' ';
            if(i<10) then spaceStr += ' ';
            EcrireDescription(spaceStr+IntToStr(i)+' - '+objetStr+' (Prix : '+IntToStr(PrixInventaire(i))+')');
            i+=1;
            objetStr := InventaireToString(i);
       end;


       //Menu
       EcrireMenu('    0 - Revenir à l''écran précédent');            
       if(i = 2) then EcrireMenu('    '+IntToStr(i-1)+' - Vendre un produit');
       if(i > 2) then EcrireMenu(' 1..n'+' - Vendre un produit');

       EcrireMenuAlert('Que voulez-vous faires ?');
       SaisirChoix(choix);

       //Exécution du choix
       case(choix) of
           1..15: VendreSlot(choix);
           0: EcranVente := MAGASIN;          //Si le joueur veut rentrer à la ferme
       end;

       //Gestion de l'évanouissement
       if(GetStamina() <= 0) or HeureEvanouir() then
       begin
         choix := 0;
       end;
  end;

end;

//Ecran des achats
//sortie : le prochain lieu
function EcranAchat() : TLieu;
var
  choix : integer; //Choix fait par le joueur
  i:integer; //Varibale de boulce
  message : string; //Message d'alerte à afficher
begin
  message := '';
  choix := -1;
  while (choix <> 0) do
  begin
       //IHM
       BaseIHM('Lieu  : Le magasin de Pierre');
       AffichageMeteo();

       //Description
       EcrireDescriptionAlert('Liste des produits vendus par Pierre :');
       for i:=Low(InventaireMagasin()) to High(InventaireMagasin()) do
       begin
            EcrireDescription('  '+IntToStr(i+1)+' - '+ObjetToString(InventaireMagasin()[i])+' (Prix : '+IntToStr(PrixAchat(InventaireMagasin()[i]))+')');
       end;
       EcrireDescription();
       if(PrixAmeliorationSac() <> 0) then EcrireDescription(' 10 - Améliorer votre sac (Prix : '+IntToStr(PrixAmeliorationSac())+')');


       //Message d'erreur
       for i:=1 to 5 do EcrireDescription();
       if(message <> '') then EcrireDescriptionError('Achat impossible : '+message);


       //Menu
       EcrireMenu('    0 - Revenir à l''écran précédent');  
       if(PrixAmeliorationSac() <> 0) then EcrireMenu('   10 - Acheter une amélioration de sac');
       EcrireMenu(' 1..' + IntToStr(Length(InventaireMagasin())) + ' - Acheter un produit');

       EcrireMenuAlert('Que voulez-vous faires ?');
       SaisirChoix(choix);

       //Exécution du choix
       case(choix) of
           1..9: if(choix <= Length(InventaireMagasin())) then message := AcheterObjet(InventaireMagasin()[choix-1]);
           10: message := AmeliorerSac();
           0: EcranAchat := MAGASIN;          //Si le joueur veut rentrer à la ferme
       end;

       //Gestion de l'évanouissement
       if(GetStamina() <= 0) or HeureEvanouir() then
       begin
         choix := 0;
       end;
  end;

end;

//Ecran principal du magasin
//sortie : le prochain lieu
function EcranMagasin() : TLieu;
var
  choix : integer; //Choix fait par le joueur
begin

  choix := -1;
  while((choix < 1) OR (choix > 3)) do
  begin
       //IHM
       BaseIHM('Lieu  : Le magasin de Pierre');
       AffichageMeteo();

       //Description
       EcrireDescription('En entrant dans le magasin de Pierre, l''air embaume d''un mélange délicieux de graines fraîches et de bois poli. Les étagères, soigneusement organisées, exhibent une varié-');
       EcrireDescription('té de produits essentiels à la vie agricole, des graines aux outils scintillants. Pierre, le propriétaire aimable, vous accueille derrière le comptoir avec un sourire sin-');
       EcrireDescription('cère, prêt à vous guider dans vos choix agricoles. Dans un coin du magasin, Abigail, la fille aventureuse de Pierre, aux cheveux violets dynamiques, s''intéresse aux acces-');
       EcrireDescription('soires de jardinage tout en échangeant quelques mots animés avec les clients. Son énergie contagieuse ajoute une atmosphère conviviale au magasin, faisant de chaque visite');
       EcrireDescription('une expérience agréable dans cette enclave agricole accueillante.');

       //Menu
       EcrireMenu(' 3 - Vendre un produit');
       EcrireMenu(' 2 - Acheter un produit');
       EcrireMenu(' 1 - Rentrer à votre ferme');

       EcrireMenuAlert('Que voulez-vous faires ?');
       SaisirChoix(choix);

       //Exécution du choix
       case(choix) of
           1:begin                          //Si le joueur veut rentrer à la ferme
                   EcranMagasin := JARDIN;
                   UnitGestionTemps.AddMinuteToDate(60);
              end;
           2: EcranMagasin := EcranAchat();    //Si le joueur veut acheter un produit
           3: EcranMagasin := EcranVente();    //Si le joueur veut vendre des produits
       end;

       //Gestion de l'évanouissement
       if(GetStamina() <= 0) or HeureEvanouir() then
       begin
         EcranMagasin := EVANOUIR;
       end;
  end;

end;

end.

