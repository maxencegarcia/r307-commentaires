-- =============================================================================
-- PARTIE A · Question 3 · Six requetes
-- Sous chaque question : votre requete, puis le resultat obtenu, en commentaire.
-- =============================================================================

-- R1. Les commentaires de l'article 2, du plus recent au plus ancien : nom, texte.
SELECT nom, texte
FROM commentaires
WHERE article_id = 2
ORDER BY cree_le DESC;
-- Resultat (2 lignes) :
--  nom  | texte
-- ------+-----------------------------------------------------------
--  Inès | Des photos de la pose seraient les bienvenues.
--  Hugo | Le noyer est magnifique. Combien de temps pour le séchage ?


-- R2. Le nombre de commentaires de CHAQUE article, y compris ceux qui n'en ont aucun :
--     id, titre, nb_commentaires.
-- LEFT JOIN : un article sans commentaire reste dans le resultat (count(c.id) vaut alors 0).
SELECT a.id, a.titre, count(c.id) AS nb_commentaires
FROM articles a
LEFT JOIN commentaires c ON c.article_id = a.id
GROUP BY a.id, a.titre
ORDER BY a.id;
-- Resultat (6 lignes) :
--  id | titre                                       | nb_commentaires
-- ----+---------------------------------------------+-----------------
--   1 | Choisir son bois pour une table de jardin   |               3
--   2 | Une bibliothèque sur mesure à Besançon      |               2
--   3 | Huile ou vernis : ce qui protège vraiment   |               0
--   4 | Restaurer une chaise paillée                |               1
--   5 | Une cuisine en chêne massif à Dole          |               2
--   6 | Affûter ses ciseaux à bois                  |               0


-- R3. Les articles qui n'ont aucun commentaire : id, titre.
SELECT a.id, a.titre
FROM articles a
WHERE NOT EXISTS (SELECT 1 FROM commentaires c WHERE c.article_id = a.id)
ORDER BY a.id;
-- Resultat (2 lignes) :
--  id | titre
-- ----+-------------------------------------------
--   3 | Huile ou vernis : ce qui protège vraiment
--   6 | Affûter ses ciseaux à bois


-- R4. Pour chaque auteur, le nombre total de commentaires recus sur ses articles,
--     du plus commente au moins commente.
-- Deux jointures : auteurs -> articles -> commentaires (LEFT JOIN pour garder un auteur
-- dont aucun article n'a de commentaire).
SELECT au.prenom AS auteur, count(c.id) AS nb_commentaires
FROM auteurs au
JOIN articles a ON a.auteur_id = au.id
LEFT JOIN commentaires c ON c.article_id = a.id
GROUP BY au.id, au.prenom
ORDER BY nb_commentaires DESC, au.prenom;
-- Resultat (3 lignes) :
--  auteur | nb_commentaires
-- --------+-----------------
--  Marc   |               5
--  Théo   |               2
--  Sophie |               1


-- R5. Les visiteurs (nom) qui ont commente plus d'un article.
-- count(DISTINCT article_id) : deux commentaires sur le MEME article ne comptent qu'une fois.
SELECT nom
FROM commentaires
GROUP BY nom
HAVING count(DISTINCT article_id) > 1;
-- Resultat (1 ligne) :
--  nom
-- --------
--  Claire


-- R6. Les trois commentaires les plus recents, avec le titre de leur article.
SELECT c.id, c.nom, a.titre, c.texte
FROM commentaires c
JOIN articles a ON a.id = c.article_id
ORDER BY c.cree_le DESC
LIMIT 3;
-- Resultat (3 lignes) :
--  id | nom    | titre                              | texte
-- ----+--------+------------------------------------+---------------------------------------------------------
--   8 | Karim  | Une cuisine en chêne massif à Dole | Superbe travail.
--   7 | Claire | Une cuisine en chêne massif à Dole | Aucune vis visible : comment sont fixés les caissons ?
--   6 | Lucie  | Restaurer une chaise paillée       | J'ai une chaise à faire refaire, vous prenez les commandes ?
