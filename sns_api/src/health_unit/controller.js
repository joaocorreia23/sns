const pool = require("../../db");

const Get_Health_Units = (req, res) => {
  pool.query("SELECT * FROM get_health_unit()", (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(200).json(results.rows);
  });
};

const Get_Health_UnitByHashedId = (req, res) => {
  const hashed_id = req.params.hashed_id;
  pool.query("SELECT * FROM get_health_unit(NULL, $1)", [hashed_id], (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(200).json(results.rows[0]);
  });
};

const Add_Health_Unit = (req, res) => {
  const { name, phone_number, email, type, tax_number, door_number, floor, address, zip_code, county, district, id_country } = req.body;
  pool.query("SELECT * FROM create_health_unit($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)", [name, phone_number, email, type, tax_number, door_number, floor, address, zip_code, county, district, id_country], (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(201).send(`Unidade de Saúde adicionada com Sucesso!`);
  });
};

module.exports = {
  Get_Health_Units,
  Get_Health_UnitByHashedId,
  Add_Health_Unit
};