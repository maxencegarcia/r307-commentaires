// ROUTEUR des commentaires, monte sur /api dans serveur.js.
// Une ligne par route : methode + chemin -> controleur. Aucun traitement ici.
// Le jeton ne protege que PATCH et DELETE : il se met sur UNE route, pas sur tout le routeur
// (sinon le POST public d'un commentaire serait refuse).

const express = require('express');
const verifierJeton = require('../middlewares/jeton');
const controleur = require('../controllers/commentaires.controller');

const router = express.Router();

router.get('/articles/:id/commentaires', controleur.listerParArticle);
router.post('/articles/:id/commentaires', controleur.creer);
router.get('/commentaires', controleur.parVisiteur);
router.get('/commentaires/:id', controleur.trouver);
router.patch('/commentaires/:id', verifierJeton, controleur.modifier);
router.delete('/commentaires/:id', verifierJeton, controleur.supprimer);

module.exports = router;
