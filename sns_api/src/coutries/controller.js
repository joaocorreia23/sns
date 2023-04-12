const pool = require("../../db");

const Get_Coutries = (req, res) => {
  pool.query("SELECT * FROM get_countries()", (error, results) => {
    if (error) throw error;
    res.status(200).json(results.rows);
  });
};

const Get_CountriesById = (req, res) => {
  const id_country = parseInt(req.params.id_country);
  pool.query(
    "SELECT * FROM get_countries($1)",
    [id_country],
    (error, results) => {
      if (error) {
        res.status(400).json({ error: error.message });
        return;
      }
      res.status(200).json(results.rows);
    }
  );
};

module.exports = {
  Get_Coutries,
  Get_CountriesById,
};
