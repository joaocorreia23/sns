const pool = require("../../db");

const getUsers = (req, res) => {
  pool.query("SELECT * FROM get_users()", (error, results) => {
    if (error) throw error;
    res.status(200).json(results.rows);
  });
};

const Get_UserByHashedId = (req, res) => {
  const id_user = null;
  const hashed_id = parseInt(req.params.hashed_id);
  pool.query(
    "SELECT * FROM Get_Users($1,$2)",
    [id_user, hashed_id],
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
  getUsers,
  Get_UserByHashedId,
};
