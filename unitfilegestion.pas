unit UnitFileGestion;

{$mode ObjFPC}{$H+}
// L'unité gère les fichiers texts (sauvegarde et recettes) du jeu.
// Lire: la fonction renvoie un tableau contenant tout le texte d'un fichier séparé par des sauts de ligne.
// Écrire: la procedure écrit des informations dans un fichier.

interface

uses
  Classes, SysUtils, UnitPersonnage, UnitGestionTemps;

type
  ListeRecettes = array of string;

function LireFichier(NomFichier: string): ListeRecettes; // fonction lire fichier txt
procedure EcrireFichier(NomFichier, Nom, NomFerme: string; stamina: integer; date: TDate); // procedure écrire dans fichier txt


implementation
// La fonction lit un fichier txt (recettes.txt) dont le chemin est spécifié en paramètre.
// Elle retourne un tableau de string où chaque élément correspond à une ligne du fichier txt.
function LireFichier(NomFichier: string): ListeRecettes;
var
  fichier: TextFile;
  Line: string;
  Str: ListeRecettes;
begin
  Line := '';
  // on associe le fichier txt à la variable "fichier"
  assignfile(fichier, NomFichier);
  // ouvre le fichier txt en lecture
  Reset(fichier);
  // par défaut notre tableau contient 0 élément
  setlength(Str, 0);

  while not EOF(fichier) do // tant qu'on n'a pas atteint la fin du fichier
    begin
      readln(fichier, Line); // cette ligne est necessaire pour ne pas faire tourner la boucle à l'infini
      setlength(Str, length(Str) + 1); // on rajoute une case au tableau (car on ne connais pas son nombre de case max)
      Str[high(Str)] := Line; // on met la valeur dans la nouvelle case créée
    end;

  closefile(fichier); // on ferme le fichier
  result := Str;
end;


// La procédure crée ou ÉCRASE le fichier txt (sauvegarde.txt) et écrit les informations essentielles rentrées en paramètre.

procedure EcrireFichier(NomFichier, Nom, NomFerme: string; stamina: integer; date: TDate);
var
  fichier: TextFile;
begin
  AssignFile(fichier, NomFichier); // on associe le fichier txt à la variable "fichier"

  rewrite(fichier); // on ouvre le fichier en écriture

  writeln(fichier, Nom); // on écrit le nom et on saute une ligne
  writeln(fichier, NomFerme);

  writeln(fichier, inttostr(Stamina));



  writeln(fichier, inttostr(date.minutes));
  writeln(fichier, inttostr(date.heures));
  writeln(fichier, date.jour);
  writeln(fichier, inttostr(date.num));
  writeln(fichier, date.saison);
  writeln(fichier, inttostr(date.annee));

  closefile(fichier); // on ferme le fichier après utilisation
end;

end.

