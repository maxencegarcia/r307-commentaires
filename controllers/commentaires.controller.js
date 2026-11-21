// CONTROLEUR des commentaires : la traduction entre HTTP et le service.
// Chaque fonction : lire la requete, verifier la forme (400), appeler le service,
// choisir le code. Toute erreur part vers next(err).
// Le controleur ne parle JAMAIS a la base : pas de pool ici, seulement le service.

const service = require('../services/commentaires.service');
const ErreurHttp = require('../utils/erreur-http');

// GET /api/articles/:id/commentaires
function listerParArticle(req, res, next) {
    const id = Number(req.params.id); // req.params est toujours du texte
    service.lister(id)
        .then((commentaires) => res.json(commentaires))
        .catch(next);
}

// POST /api/articles/:id/commentaires  { nom, texte }
function creer(req, res, next) {
    const id = Number(req.params.id);
    const { nom, texte } = req.body || {};
    if (!nom || !texte) {
        return next(new ErreurHttp(400, 'CHAMP_MANQUANT', 'Les champs nom et texte sont obligatoires.'));
    }
    service.creer(id, { nom, texte })
        .then((commentaire) => res.status(201).json(commentaire))
        .catch(next);
}

// GET /api/commentaires?nom=Claire
function parVisiteur(req, res, next) {
    const { nom } = req.query;
    if (!nom) {
        return next(new ErreurHttp(400, 'NOM_MANQUANT', 'Le paramètre nom est obligatoire.'));
    }
    service.parVisiteur(nom)
        .then((commentaires) => res.json(commentaires))
        .catch(next);
}

// GET /api/commentaires/:id
function trouver(req, res, next) {
    const id = Number(req.params.id);
    service.trouver(id)
        .then((commentaire) => res.json(commentaire))
        .catch(next);
}

// PATCH /api/commentaires/:id  { texte }   (le jeton est verifie dans le routeur)
function modifier(req, res, next) {
    const id = Number(req.params.id);
    const { texte } = req.body || {};
    if (!texte) {
        return next(new ErreurHttp(400, 'TEXTE_MANQUANT', 'Le champ texte est obligatoire.'));
    }
    service.modifier(id, { texte })
        .then((commentaire) => res.json(commentaire))
        .catch(next);
}

// DELETE /api/commentaires/:id   (le jeton est verifie dans le routeur)
function supprimer(req, res, next) {
    const id = Number(req.params.id);
    service.supprimer(id)
        .then(() => res.status(204).end())
        .catch(next);
}

module.exports = { listerParArticle, creer, parVisiteur, trouver, modifier, supprimer };
