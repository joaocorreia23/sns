const express = require("express");
const cors = require('cors');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');


const usersRoutes = require('./src/users/routes');
const coutriesRoutes = require('./src/coutries/routes');
const authRoutes = require ('./src/auth/routes');
const healthUnitsRoutes = require('./src/health_unit/routes');
const examRoutes = require('./src/exam/routes');
const vaccineRoutes = require('./src/vaccine/routes');
const appointmentRoutes = require('./src/appointment/routes');
const medicationRoutes = require('./src/medication/routes');
const prescription = require('./src/prescription/routes');

const app = express();
app.use(cors());

const port = 3000;

app.use(express.json());

app.get("/", (req, res) => {
    res.send("Bem-Vindo(a) à API do SNS24!");
})

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.use('/api/auth', authRoutes);

app.use('/api/users', usersRoutes);

app.use('/api/countries', coutriesRoutes);

app.use('/api/health_unit', healthUnitsRoutes);

app.use('/api/exams', examRoutes);

app.use('/api/vaccines', vaccineRoutes);

app.use('/api/appointments', appointmentRoutes);

app.use('/api/medications', medicationRoutes);

app.use('/api/prescriptions', prescription);




app.listen(port, () => console.log(`Servidor ativo na porta: ${port}`));