// CONTROLEUR des commentaires.
// A ECRIRE : une fonction (req, res, next) par route de CONTRAT.md, comme dans
// controllers/articles.controller.js :
//   1. lire req.params, req.query, req.body ;
//   2. verifier la forme : 400 si un champ obligatoire manque ;
//   3. appeler le service (services/commentaires.service.js) ;
//   4. choisir le code (200, 201 ou 204). Toute erreur part vers next(err).
// Le controleur ne parle JAMAIS a la base : pas de pool ici, seulement le service.

// const service = require('../services/commentaires.service');
// const ErreurHttp = require('../utils/erreur-http');
const service = require('../services/commentaires.service');
const ErreurHttp = require('../utils/erreur-http');

function listerParArticle(req, res, next){
    const id = Number(req.params.id)
    service.lister()
        .then((commentaires) => res.json(commentaires))
        .catch(next);
}
function creer(req, res, next){
    const id = Number(req.params.id);
    const { nom, texte } = req.body || {};
    if (!nom || !texte) {
        return next(new ErreurHttp(400, 'CHAMP_MANQUANT', 'Les champs nom et texte sont obligatoires.'));
    }
    service.creer(id, { nom, texte })
        .then((commentaire) => res.status(201).json(commentaire))
        .catch(next);
}
function parVisiteur(req, res, next){
    const { nom } = req.query;
    if (!nom) {
        return next(new ErreurHttp(400, 'NOM_MANQUANT', 'Le paramètre nom est obligatoire.'));
    }
    service.parVisiteur(nom)
        .then((commentaires) => res.json(commentaires))
        .catch(next);
}
function trouver(req, res, next){
    const id = Number(req.params.id); // req.params est toujours du texte
    const champs = req.query.champs ? req.query.champs.split(',') : null;
    service.trouver(id, champs)
        .then((commentaires) => res.json(commentaires))
        .catch(next);
}
function modifier(req, res, next){
    const id = Number(req.params.id);
    service.modifier(id, req.body || {})
        .then((commentaires) => res.json(commentaires))
        .catch(next);
}
function supprimer(req, res, next){
    const id = Number(req.params.id);
    service.supprimer(id)
        .then(() => res.status(204).end())
        .catch(next);
}


module.exports = {listerParArticle, creer, parVisiteur, trouver, modifier, supprimer};

