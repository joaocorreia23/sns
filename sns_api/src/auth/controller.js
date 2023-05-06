const pool = require("../../db");

const Login_Verify = (req, res) => {
  const { email, password } = req.body;
  pool.query("SELECT * FROM verify_user_login_new($1, $2)", [email, password], (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(200).json(results.rows[0]);
  });
};

const Email_Verify = (req, res) => {
  const { email } = req.body;
  pool.query("SELECT email_verify($1)", [email], (error, results) => {
    if (error) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(200).json(results.rows[0].email_verify);
  });
};

module.exports = {
  Login_Verify,
  Email_Verify,
};
