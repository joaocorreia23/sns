const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.get('/', controller.Get_Coutries);

router.get('/:id_country', controller.Get_CountriesById);

module.exports = router;