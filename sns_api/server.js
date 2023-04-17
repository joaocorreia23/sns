const express = require("express");
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');


const usersRoutes = require('./src/users/routes');
const coutriesRoutes = require('./src/coutries/routes');

const app = express();
const port = 3000;

app.use(express.json());

app.get("/", (req, res) => {
    res.send("Bem-Vindo(a) à API do SNS24!");
})

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.use('/api/users', usersRoutes);

app.use('/api/countries', coutriesRoutes);

app.listen(port, () => console.log(`Server running port: ${port}`));