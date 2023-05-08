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

const Link_Doctor = (req, res) => {
  const { hashed_id_health_unit, hashed_id_user } = req.body;
  pool.query("SELECT * FROM add_health_unit_doctor(NULL, $1, NULL, $2)", [hashed_id_health_unit, hashed_id_user], (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(201).send(`Médico adicionado à Unidade de Saúde com Sucesso!`);
  });
};

const Unlink_Doctor = (req, res) => {
  const { hashed_id_health_unit, hashed_id_user } = req.body;
  pool.query("SELECT * FROM remove_health_unit_doctor(NULL, $1, NULL, $2)", [hashed_id_health_unit, hashed_id_user], (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(201).send(`Médico removido da Unidade de Saúde com Sucesso!`);
  });
};

const Get_Health_Unit_Doctors = (req, res) => {
  const hashed_id = req.params.hashed_id;
  pool.query("SELECT * FROM get_health_unit_doctors(NULL, $1)", [hashed_id], (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    /*     if (results.rows.length == 0) {
          res.status(404).send(`Não existem Médicos associados à Unidade de Saúde!`);
          return;
        } */
    res.status(200).json(results.rows);
  });
};

const Link_Patient = (req, res) => {
  const { hashed_id_health_unit, hashed_id_user } = req.body;
  pool.query("SELECT * FROM add_health_unit_patient(NULL, $1, NULL, $2)", [hashed_id_health_unit, hashed_id_user], (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(201).send(`Paciente adicionado à Unidade de Saúde com Sucesso!`);
  });
};

const Unlink_Patient = (req, res) => {
  const { hashed_id_health_unit, hashed_id_user } = req.body;
  pool.query("SELECT * FROM remove_health_unit_patient(NULL, $1, NULL, $2)", [hashed_id_health_unit, hashed_id_user], (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(201).send(`Paciente removido da Unidade de Saúde com Sucesso!`);
  });
};

const Get_Health_Unit_Patients = (req, res) => {
  const hashed_id = req.params.hashed_id;
  pool.query("SELECT * FROM get_health_unit_patients(NULL, $1)", [hashed_id], (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    /*     if (results.rows.length == 0) {
          res.status(404).send(`Não existem Médicos associados à Unidade de Saúde!`);
          return;
        } */
    res.status(200).json(results.rows);
  });
};

module.exports = {
  Get_Health_Units,
  Get_Health_UnitByHashedId,
  Add_Health_Unit,
  Link_Doctor,
  Unlink_Doctor,
  Get_Health_Unit_Doctors,
  Link_Patient,
  Unlink_Patient,
  Get_Health_Unit_Patients
};