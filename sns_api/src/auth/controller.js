const pool = require("../../db");

const Login_Verify = (req, res) => {
  const { email, password } = req.body;
  pool.query("SELECT verify_user_login($1, $2)", [email, password], (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(200).json(results.rows);
  });
};

module.exports = {
  Login_Verify,
};
