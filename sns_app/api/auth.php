<?php
require_once($_SERVER["DOCUMENT_ROOT"] . "/_config.php");

if (isset($_SERVER["REQUEST_METHOD"])) {
    switch ($_SERVER["REQUEST_METHOD"]) {
        case "GET":
            echo "O método GET não é suportado neste ficheiro por vias de segurança.";
            break;
        case "POST":
            if (!isset($_POST["action"])) {
                echo "Ação não existe";
                break;
            }

            switch ($_POST["action"]) {
                case "login":
                    $email = $_POST["email"];
                    $password = $_POST["password"];

                    require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php");

                    $api = new Api();
                    $verify_user_login = $api->post("auth/login", ["email" => $email, "password" => $password]);

                    if ($verify_user_login["status"]) {
                        if ($verify_user_login["response"]["status"] === true) {
                            if (session_status() !== PHP_SESSION_ACTIVE) session_start();
                            $hashed_id = $verify_user_login["response"]["hashed_id"];

                            $user_info = $api->fetch("users/", null, $hashed_id);

                            if ($user_info["status"] === true) {
                                $default_avatar = "assets/media/avatar/blank.png";
                                $_SESSION["username"] = $user_info["response"]["username"];
                                $_SESSION["email"] = $user_info["response"]["email"];
                                $_SESSION["hashed_id"] = $user_info["response"]["hashed_id"];
                                $_SESSION["name"] = $user_info["response"]["first_name"] . ' ' . $user_info["response"]["last_name"];
                                $_SESSION["roles"] = $verify_user_login["response"]["user_role"];
                                $_SESSION["active_role"] = $verify_user_login["response"]["user_role"][0];
                                $_SESSION["avatar_path"] = $user_info["response"]["avatar_path"] && !empty(trim($user_info["response"]["avatar_path"])) ? $link_home . $user_info["response"]["avatar_path"] : $default_avatar;;
                            } else {
                                return ["status" => false, "messages" => ["Erro ao verificar a informação do Utilizado!"]];
                            }
                            //ASK FOR USER INFO
                        }
                    }
                    echo json_encode($verify_user_login["response"]);
                    break;

                case "updateActiveRole":
                    if (session_status() !== PHP_SESSION_ACTIVE) session_start();
                    $_SESSION["active_role"] = $_POST["role"];
                    echo json_encode(["status" => true, "messages" => ["Role atualizada com sucesso!"]]);
                    break;
            }

            break;

        default:
            // throw new Exception("Método não suportado . ");
            echo json_encode("Método não suportado . ");
            break;
    }
}
