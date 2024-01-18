//Unité en charge des objets
unit UnitObjet;   
{$codepage utf8}
{$mode ObjFPC}{$H+}

interface
Uses UnitGestionTemps;
//------------------------------- TYPES ----------------------------------------
Type
  //Type des objets
  TObjet = (VIDE,GRAINE_PANAIS,GRAINE_POMMEDETERRE,GRAINE_CHOUXFLEUR,GRAINE_TOMATE,GRAINE_PIMENT,GRAINE_MELON,GRAINE_AUBERGINE,GRAINE_CITROUILLE,GRAINE_IGNAME,GRAINE_CAROTTE,GRAINE_POIREAU,GRAINE_CELERI,
  PANAIS,POMMEDETERRE,CHOUXFLEUR,TOMATE,PIMENT,MELON,AUBERGINE,CITROUILLE,IGNAME,CAROTTE,POIREAU,CELERI,GRAINE_MYSTERE);
  //Qualité des objets
  TQualite = (BASE,SILVER,GOLD,IRIDIUM);
  //Un stack d'objet
  TStack = record
     objet : TObjet;
     num : integer;
     qualite : TQualite;
  end;
  //Inventaire de magasin
  TInventaireMagasin = array of TObjet;
                        
//-------------------------- SOUS PROGRAMMES -----------------------------------
//Créer un stack vide
//sortie : un stack vide
function CreerStackVide() : TStack; 

//Transforme un objet en string
//entrée : l'objet
//sortie : la chaine de caractère
function ObjetToString(objet : TObjet) : string;   

//Transforme une qualité en string
//entrée : la qualité
//sortie : la chaine de caractère
function QualiteToString(qualite : TQualite) : string;
          

//Renvoie l'inventaire du magasin de pierre en fonction de la saison
//sortie : l'inventaire du magasin
function InventaireMagasin() : TInventaireMagasin;
 
//Renvoie le prix d'achat des objets chez Pierre
//entrée : l'objet à acheter
//sortie : Le prix de l'objet
function PrixAchat(objet : TObjet) : integer;      

//Renvoie le prix de vente des objets chez Pierre
//entrée : l'objet à vendre
//sortie : Le prix de l'objet
function PrixVente(objet : TObjet ; qualite : TQualite) : integer;

//L'objet est-il une graine
//entrée : l'objet
//sortie : est-ce une graine
function EstGraineObjet(objet : TObjet) : boolean;

//Transforme un string en TObjet
//entrée : le string
//sortie : le TObjet correspondant
function StrToObjet(s: string) : TObjet;


implementation


//Créer un stack vide
//sortie : un stack vide
function CreerStackVide() : TStack;
begin
   CreerStackVide.objet:=VIDE;
   CreerStackVide.num:=0;
   CreerStackVide.qualite:=BASE;
end;

//Renvoie le prix d'achat des objets chez Pierre
//entrée : l'objet à acheter
//sortie : Le prix de l'objet
function PrixAchat(objet : TObjet) : integer;
begin
    PrixAchat := 0;
    case(objet) of
      GRAINE_PANAIS : PrixAchat := 20;
      GRAINE_POMMEDETERRE : PrixAchat := 50;
      GRAINE_CHOUXFLEUR : PrixAchat := 80;
      GRAINE_TOMATE : PrixAchat := 50;
      GRAINE_PIMENT : PrixAchat := 40;
      GRAINE_MELON : PrixAchat := 80;
      GRAINE_AUBERGINE : PrixAchat := 20;
      GRAINE_CITROUILLE : PrixAchat := 100;
      GRAINE_IGNAME : PrixAchat := 60;
      GRAINE_CAROTTE : PrixAchat := 30;
      GRAINE_POIREAU : PrixAchat := 60;
      GRAINE_CELERI : PrixAchat := 80;
      GRAINE_MYSTERE : PrixAchat := 50;

    End;
end;
      
//Renvoie le prix de vente des objets chez Pierre
//entrée : l'objet à vendre
//sortie : Le prix de l'objet
function PrixVente(objet : TObjet ; qualite:TQualite) : integer;
begin
    //De base le prix de vente = achat/2
    PrixVente := PrixAchat(objet) div 2;
    case(objet) of
      PANAIS: PrixVente:=35;
      POMMEDETERRE: PrixVente:=80;
      CHOUXFLEUR: PrixVente:=175;
      TOMATE: PrixVente:=100;
      PIMENT: PrixVente:=65;
      MELON: PrixVente:=250;
      AUBERGINE: PrixVente:=60;
      CITROUILLE: PrixVente:=320;
      IGNAME: PrixVente:=160;
      CAROTTE: PrixVente:=50;
      POIREAU: PrixVente:=120;
      CELERI: PrixVente:=175;
    end;

    //Gestion de la qualité (facteur multiplicatif)
    case(qualite) of
        SILVER : PrixVente := (125*PrixVente) div 100;
        GOLD: PrixVente := (150*PrixVente) div 100;
        IRIDIUM: PrixVente := (200*PrixVente) div 100;
    end;

end;

//L'objet est-il une graine
//entrée : l'objet
//sortie : est-ce une graine
function EstGraineObjet(objet : TObjet) : boolean;
begin
     EstGraineObjet := false;
     case(objet) of
         GRAINE_PANAIS,GRAINE_MYSTERE,GRAINE_POMMEDETERRE,GRAINE_CHOUXFLEUR,GRAINE_TOMATE,GRAINE_PIMENT,GRAINE_MELON,GRAINE_AUBERGINE,GRAINE_CITROUILLE,GRAINE_IGNAME,GRAINE_CAROTTE,GRAINE_POIREAU,GRAINE_CELERI: EstGraineObjet := true;
     end;
end;

//Transforme un objet en string
//entrée : l'objet
//sortie : la chaine de caractère
function ObjetToString(objet : TObjet) : string;
begin
   case(objet) of
      VIDE : ObjetToString := '';

      GRAINE_PANAIS : ObjetToString := 'Graines de panais';
      GRAINE_POMMEDETERRE : ObjetToString := 'Graines de pommes de terre';
      GRAINE_CHOUXFLEUR : ObjetToString := 'Graines de choux-fleurs';
      GRAINE_TOMATE : ObjetToString := 'Graines de tomates';
      GRAINE_PIMENT : ObjetToString := 'Graines de piments';
      GRAINE_MELON : ObjetToString := 'Graines de melons';
      GRAINE_AUBERGINE : ObjetToString := 'Graines d''aubergines';
      GRAINE_CITROUILLE : ObjetToString := 'Graines de citrouilles';
      GRAINE_IGNAME : ObjetToString := 'Graines d''ignames';
      GRAINE_CAROTTE : ObjetToString := 'Graines de carottes';
      GRAINE_POIREAU : ObjetToString := 'Graines de poireaux';
      GRAINE_CELERI : ObjetToString := 'Graines de celeri';
      GRAINE_MYSTERE : ObjetToString := 'Graines Mystère';

      PANAIS : ObjetToString := 'Panais';
      POMMEDETERRE : ObjetToString := 'Pommes de terre';
      CHOUXFLEUR : ObjetToString := 'Choux-fleurs';
      TOMATE : ObjetToString := 'Tomates';
      PIMENT : ObjetToString := 'Piments';
      MELON : ObjetToString := 'Melons';
      AUBERGINE : ObjetToString := 'Aubergines';
      CITROUILLE : ObjetToString := 'Citrouilles';
      IGNAME : ObjetToString := 'Ignames';
      CAROTTE : ObjetToString := 'Carottes';
      POIREAU : ObjetToString := 'Poireaux';
      CELERI : ObjetToString := 'Celeri';
   end;
end;

//Renvoie l'inventaire du magasin de pierre en fonction de la saison
//sortie : l'inventaire du magasin
function InventaireMagasin() : TInventaireMagasin;
begin
     case(GetDate().saison) of
         PRINTEMPS:
         begin
            SetLength(InventaireMagasin,3);
            InventaireMagasin[0] := GRAINE_PANAIS;
            InventaireMagasin[1] := GRAINE_POMMEDETERRE;
            InventaireMagasin[2] := GRAINE_CHOUXFLEUR;
            InventaireMagasin[3] := GRAINE_MYSTERE;
         end;
         ETE: 
         begin
            SetLength(InventaireMagasin,3); 
            InventaireMagasin[0] := GRAINE_TOMATE;
            InventaireMagasin[1] := GRAINE_PIMENT;
            InventaireMagasin[2] := GRAINE_MELON;
         end;
         AUTOMNE:
         begin
            SetLength(InventaireMagasin,3); 
            InventaireMagasin[0] := GRAINE_AUBERGINE;
            InventaireMagasin[1] := GRAINE_CITROUILLE;
            InventaireMagasin[2] := GRAINE_IGNAME;
         end;
         HIVERS: 
         begin
            SetLength(InventaireMagasin,3); 
            InventaireMagasin[0] := GRAINE_CAROTTE;
            InventaireMagasin[1] := GRAINE_POIREAU;
            InventaireMagasin[2] := GRAINE_CELERI;
         end;
     end;
end;

//Transforme une qualité en string
//entrée : la qualité
//sortie : la chaine de caractère
function QualiteToString(qualite : TQualite) : string;
begin
   case(qualite) of
      BASE : QualiteToString := '';
      SILVER : QualiteToString := ' (+)';
      GOLD : QualiteToString := ' (++)';
      IRIDIUM : QualiteToString := ' (+++)';
   end;
end;

//Transforme un string en TObjet
//entrée : le string
//sortie : le TObjet correspondant
function StrToObjet(s: string) : TObjet;
begin
   case s of
      'Panais' : StrToObjet := PANAIS;
      'Pomme de terre' : StrToObjet := POMMEDETERRE;
      'Choux-fleur' : StrToObjet := CHOUXFLEUR;
      'Tomate' : StrToObjet := TOMATE;
      'Piment' : StrToObjet := PIMENT;
      'Melon' : StrToObjet := MELON;
      'Aubergine' : StrToObjet := AUBERGINE;
      'Citrouille' : StrToObjet := CITROUILLE;
      'Igname' : StrToObjet := IGNAME;
      'Carotte' : StrToObjet := CAROTTE;
      'Poireau' : StrToObjet := POIREAU;
      'Celeri' : StrToObjet := CELERI;
      else StrToObjet:= VIDE;
   end;
end;

end.

