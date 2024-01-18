unit UnitTri;

{$mode ObjFPC}{$H+}

interface
uses
  Classes, SysUtils;

type
  // Type de tableau de chaînes de caractères
  ListeRecettes = array of string;

// Fusion de deux tableaux triés de chaînes de caractères
function fusion(gauche: ListeRecettes; droite: ListeRecettes): ListeRecettes;

// Renvoie du tableau trié de chaînes de caractères
function tri_fusion(t: ListeRecettes): ListeRecettes;

implementation

function fusion(gauche: ListeRecettes; droite: ListeRecettes): ListeRecettes;
var
  // Tableau à renvoyer (concaténation des deux précédents)
  t: ListeRecettes;
  // Variable de travail
  i: integer;
begin
  // Cas tableau de gauche vide
  if Length(gauche) = 0 then
    t := droite
  // Cas tableau de droite vide
  else if Length(droite) = 0 then
    t := gauche
  // Cas si gauche avant droite
  else if CompareStr(gauche[0], droite[0]) <= 0 then
  begin
    t := Copy(gauche, 0, 1);
    // On enlève le premier du tableau de gauche
    gauche := Copy(gauche, 1, High(gauche));
    // On continue de trier le tableau
    t:= Concat (t, fusion(gauche, droite));
  end
  // Cas si droite avant gauche
  else
  begin
    t := Copy(droite, 0, 1);
    // On enlève le premier du tableau de droite
    droite := Copy(droite, 1, High(droite));
    // On continue de trier le tableau
    t:= Concat (t, fusion(gauche, droite));
  end;
  Result := t;
end;

function tri_fusion(t: ListeRecettes): ListeRecettes;
var
  // Tableau à renvoyer à la fin de la fonction
  tempt, gauche, droite: ListeRecettes;  // Variables de travail
  m, i: integer;   // Indique le milieu du tableau
begin
  m := Length(t) div 2;

  SetLength(gauche, m);
  SetLength(droite, Length(t) - m);

  for i := 0 to m - 1 do
    gauche[i] := t[i];

  for i := m to Length(t) - 1 do
    droite[i - m] := t[i];

  // Renvoie le tableau s'il n'est composé que d'un seul élément
  if Length(t) <= 1 then
    Result := t
  else
    Result := fusion(tri_fusion(gauche), tri_fusion(droite));
end;

end.

