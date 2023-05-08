<?php
$link_home = $_SERVER['REQUEST_SCHEME'] . '://' . $_SERVER['SERVER_NAME'] . '/';
$current_location = $_SERVER["REQUEST_URI"];

if (session_status() !== PHP_SESSION_ACTIVE) session_start();
$id_user = isset($_SESSION["hashed_id"]) ? $_SESSION["hashed_id"] : null;

if (str_contains($current_location, "/pages/auth/")) {
    if ($current_location === "/pages/auth/login" && isset($_SESSION["hashed_id"])) {
        header("Location: $link_home");
        exit;
    }
} else {
    if (str_contains($current_location, "/api/auth.php")) {
        return;
    } else if (!isset($_SESSION["hashed_id"])) {
        header("Location: $link_home" . "pages/auth/login");
        exit;
    }
}
