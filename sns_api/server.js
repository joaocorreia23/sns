const express = require("express");

const usersRoutes = require('./src/users/routes');

const app = express();
const port = 3000;

app.use(express.json());

app.get("/", (req, res) => {
    res.send("Hello World!");
})

app.use('/api/users', usersRoutes);

app.listen(port, () => console.log(`Server running port ${port}`));