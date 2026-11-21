-- =============================================================================
-- PARTIE A · Questions 1 et 2 · La table des commentaires
-- A executer dans la base ateliers, APRES db/ateliers.sql.
--   terminal : psql -d ateliers -f sql/commentaires.sql
-- =============================================================================

-- Le script doit pouvoir etre relance : on commence par effacer la table.
DROP TABLE IF EXISTS commentaires;

-- QUESTION 1 · Le CREATE TABLE.
--   id          attribue par la base (IDENTITY), cle primaire
--   article_id  obligatoire, et forcement un article qui existe (REFERENCES) ;
--               ON DELETE CASCADE : supprimer un article supprime ses commentaires
--   nom         obligatoire
--   texte       obligatoire, et jamais une chaine vide (CHECK)
--   cree_le     date et heure avec fuseau ; par defaut, l'instant de l'insertion
CREATE TABLE commentaires (
  id          INT         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  article_id  INT         NOT NULL REFERENCES articles (id) ON DELETE CASCADE,
  nom         TEXT        NOT NULL,
  texte       TEXT        NOT NULL CHECK (texte <> ''),
  cree_le     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- QUESTION 2 · Les huit commentaires de data/commentaires.initial.json, en un seul INSERT.
-- Pas d'id : la base les attribue (1 a 8, dans l'ordre). Les dates sont en UTC (le Z final).
-- Une apostrophe se double en SQL : 'J''ai une chaise'.
INSERT INTO commentaires (article_id, nom, texte, cree_le) VALUES
  (1, 'Claire', 'Et pour le robinier, vous conseillez quoi ?',                    '2026-09-03T08:12:00Z'),
  (1, 'Paul',   'Ma table en pin a tenu deux hivers, pas trois.',                 '2026-09-04T16:40:00Z'),
  (1, 'Nadia',  'Article clair, merci.',                                          '2026-09-10T06:05:00Z'),
  (2, 'Hugo',   'Le noyer est magnifique. Combien de temps pour le séchage ?',    '2026-09-17T10:30:00Z'),
  (2, 'Inès',   'Des photos de la pose seraient les bienvenues.',                 '2026-09-20T19:15:00Z'),
  (4, 'Lucie',  'J''ai une chaise à faire refaire, vous prenez les commandes ?',  '2026-10-09T07:00:00Z'),
  (5, 'Claire', 'Aucune vis visible : comment sont fixés les caissons ?',         '2026-10-16T12:22:00Z'),
  (5, 'Karim',  'Superbe travail.',                                               '2026-10-18T17:47:00Z');

-- Verification : doit donner 8.
SELECT count(*) FROM commentaires;
