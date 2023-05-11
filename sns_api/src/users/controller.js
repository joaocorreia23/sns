const pool = require("../../db");

const Get_Users = (req, res) => {
    pool.query("SELECT * FROM get_users()", (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(200).json(results.rows);
    });
};

const Get_Users_DataTable = (req, res) => {
    pool.query("SELECT * FROM get_users()", (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(200).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_Users_DataTable_Disabled = (req, res) => {
    pool.query("SELECT * FROM get_users(null, null , null,  0)", (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(200).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_UsersByRole = (req, res) => {
    const role = req.params.role;
    pool.query("SELECT * FROM get_users(NULL, NULL, $1)", [role], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(200).json({ "status": true, "data": results.rows });
    });
};

const Get_UserByHashedId = (req, res) => {
    const hashed_id = req.params.hashed_id;
    pool.query("SELECT * FROM get_users(NULL, $1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(200).json(results.rows[0]);
    });
};

const Add_User = (req, res) => {
    const { username, email, password, role } = req.body;
    pool.query("SELECT * FROM create_user($1, $2, $3, $4)", [username, email, password, role], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "message": "Utilizador adicionado com Sucesso!" });
    });
};

const Update_User = (req, res) => {
    const { hashed_id, username, email, password } = req.body;
    pool.query("SELECT * FROM update_user(NULL, $1, $2, $3, $4)", [hashed_id, username, email, password], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "message": "Utilizador editado com Sucesso!" });
    });
};

const Update_User_Info = (req, res) => {
    const { hashed_id, first_name, last_name, birth_date, gender, tax_number, phone_number, contact_email, nationality, door_number, floor, address, zip_code, county, district, id_country, avatar_path } = req.body;
    pool.query(
        "SELECT * FROM update_user_info(NULL, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10,$11,$12,$13,$14,$15,$16,$17)",
        [hashed_id, first_name, last_name, birth_date, gender, tax_number, phone_number, contact_email, nationality, door_number, floor, address, zip_code, county, district, id_country, avatar_path],
        (error, results) => {
            if (error) {
                res.status(400).json({ error: error.message });
                return;
            }
            res.status(201).json({ "status": true, "message": "Utilizador editado com Sucesso!" });
        }
    );
};

const Delete_User = (req, res) => {
    const { hashed_id } = req.body;
    pool.query("SELECT delete_user(NULL, $1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Utilizador desativado com Sucesso!" });

    });
};

const Activate_User = (req, res) => {
    const { hashed_id } = req.body;
    pool.query("SELECT activate_user(NULL, $1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Utilizador ativado com Sucesso!" });
    });
};

const Create_User_Role = (req, res) => {
    const { hashed_id, role } = req.body;
    pool.query("SELECT * FROM create_user_role(NULL, $1, $2)", [hashed_id, role], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).send(`Role adicionada com Sucesso!`);
    });
};

const Manage_User_Roles = (req, res) => {
    const { hashed_id, roles } = req.body;
    pool.query("SELECT * FROM manage_user_roles(NULL, $1, $2)", [hashed_id, roles], (error, results) => {
        if (error) {
            res.status(400).json({'status': false, 'message': error.message });
            return;
        }
        res.status(201).json({ "status": true, "message": "Roles atualizadas com Sucesso!" });
    });
};

const Get_User_Roles = (req, res) => {
    const hashed_id = req.params.hashed_id;
    pool.query("SELECT * FROM get_user_roles(NULL, $1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        /*     
        if (results.rows.length === 0) {
          res.status(404).send(`Utilizador não encontrado!`);
          return;
        } */
        res.status(200).json(results.rows);
    });
};

module.exports = {
    Get_Users,
    Get_Users_DataTable,
    Get_Users_DataTable_Disabled,
    Get_UsersByRole,
    Get_UserByHashedId,
    Add_User,
    Update_User,
    Update_User_Info,
    Delete_User,
    Activate_User,
    Create_User_Role,
    Manage_User_Roles,
    Get_User_Roles
};
