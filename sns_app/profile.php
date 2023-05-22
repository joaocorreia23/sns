<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php
$api = new Api();
$user_info = $api->fetch("users/", null, $id_user);
$user_info_data = $user_info["response"];
?>

<body id="kt_app_body" data-kt-app-header-fixed-mobile="true" data-kt-app-toolbar-enabled="true" class="app-default">
    <div class="d-flex flex-column flex-root app-root" id="kt_app_root">
        <div class="app-page flex-column flex-column-fluid" id="kt_app_page">
            <?php require_once($_SERVER["DOCUMENT_ROOT"] . "/header.php") ?>
            <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">
                <?php require_once($_SERVER["DOCUMENT_ROOT"] . "/toolbar.php") ?>
                <div class="app-container container-xxl">
                    <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
                        <div class="d-flex flex-column flex-column-fluid">
                            <div id="kt_app_content" class="app-content">

                                <?php
                                if ($user_info["status"] === false) {
                                    echo '<script>toastr.error("Erro ao obter Dados do Utilizador!", "Erro!");;
                                    setTimeout(() => {
                                        window.location.href = "404";
                                      }, 650);
                                    </script>';
                                    exit;
                                } else if ($user_info["status"] === true) {
                                    echo '<script>toastr.success("Dados do Utilizador Obtidos com Sucesso!", "Sucesso!");</script>';
                                }
                                ?>

                                <!--begin::Navbar-->
                                <div class="card mb-5 mb-xl-10">
                                    <div class="card-body pt-9 pb-0">
                                        <!--begin::Details-->
                                        <div class="d-flex flex-wrap flex-sm-nowrap">
                                            <!--begin: Pic-->
                                            <div class="me-7 mb-4">
                                                <div class="symbol symbol-100px symbol-lg-160px symbol-fixed position-relative">
                                                    <img src="<?php echo $user_info_data["avatar_path"] ?>" alt="image">
                                                </div>
                                            </div>
                                            <!--end::Pic-->

                                            <!--begin::Info-->
                                            <div class="flex-grow-1">
                                                <!--begin::Title-->
                                                <div class="d-flex justify-content-between align-items-start flex-wrap mb-2">
                                                    <!--begin::User-->
                                                    <div class="d-flex flex-column">
                                                        <!--begin::Name-->
                                                        <div class="d-flex align-items-center mb-2">
                                                            <a class="text-gray-900 text-hover-primary fs-2 fw-bold me-1"><?php echo $user_info_data["first_name"] . ' ' . $user_info_data["last_name"] ?></a>
                                                        </div>
                                                        <!--end::Name-->

                                                        <!--begin::Info-->
                                                        <div class="d-flex flex-wrap fw-semibold fs-6 mb-4 pe-2">
                                                            <a href="#" class="d-flex align-items-center text-gray-400 text-hover-primary me-5 mb-2">
                                                                <i class="ki-outline ki-sms fs-4 me-1"></i><?php echo $user_info_data["email"] ?></a>
                                                            <a href="#" class="d-flex align-items-center text-gray-400 text-hover-primary me-5 mb-2">
                                                                <i class="ki-outline ki-phone fs-4 me-1"></i><?php echo $user_info_data["phone_number"] ?></a>
                                                            <a href="#" class="d-flex align-items-center text-gray-400 text-hover-primary mb-2">
                                                                <i class="ki-outline ki-information-2 fs-4 me-1"></i>
                                                                <?php echo (new DateTime($user_info_data["created_at"]))->format("d/m/Y - H:i"); ?>
                                                        </div>
                                                        <span class="badge badge-success me-2">Ativo</span>
                                                        <span class="badge badge-warning me-2"><?php echo $user_info_data["gender"] ?></span>
                                                        <!--end::Info-->
                                                    </div>
                                                    <!--end::User-->

                                                    <!--begin::Actions-->
                                                    <div class="d-flex my-4">

                                                        <a href="" class="btn btn-sm btn-primary me-3" data-bs-toggle="modal" data-bs-target="#kt_modal_offer_a_deal">Ação 1</a>

                                                    </div>
                                                    <!--end::Actions-->
                                                </div>
                                                <!--end::Title-->

                                            </div>
                                            <!--end::Info-->
                                        </div>
                                        <!--end::Details-->

                                        <!--begin::Navs-->
                                        <ul class="nav nav-stretch nav-line-tabs nav-line-tabs-2x border-transparent fs-5 fw-bold">
                                            <!--begin::Nav item-->
                                            <li class="nav-item mt-2">
                                                <a class="nav-link text-active-primary ms-0 me-10 py-5 active">
                                                    Informação Perfil</a>
                                            </li>
                                            <!--end::Nav item-->
                                        </ul>
                                        <!--begin::Navs-->
                                    </div>
                                </div>
                                <!--end::Navbar-->
                                <!--begin::details View-->
                                <div class="card mb-5 mb-xl-10" id="kt_profile_details_view">
                                    <!--begin::Card header-->
                                    <div class="card-header cursor-pointer">
                                        <!--begin::Card title-->
                                        <div class="card-title m-0">
                                            <h3 class="fw-bold m-0">A Minha Informação</h3>
                                        </div>
                                        <!--end::Card title-->

                                        <!--begin::Action-->
                                        <a href="edit-profile" class="btn btn-sm btn-primary align-self-center">Editar Perfil</a>
                                        <!--end::Action-->
                                    </div>
                                    <!--begin::Card header-->

                                    <!--begin::Card body-->
                                    <div class="card-body p-9">
                                        <div class="row">
                                            <div class="col-6">

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Primeiro Nome</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["first_name"] ?></span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Último Nome</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["last_name"] ?></span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Género</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["gender"] ?></span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Data de Nascimento</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo (new DateTime($user_info_data["bith_date"]))->format("d/m/Y"); ?></span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Email</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["email"] ?></span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Email de Contacto</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["contact_email"] ?></span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Número de Contacto</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["phone_number"] ?></span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Número Identificação Fiscal</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["tax_number"] ?></span>
                                                    </div>
                                                </div>

                                            </div>
                                            <div class="col-6">

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Nacionalidade</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["nationality_country_name"] ?></span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">País</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["country_name"] ?></span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Distrito</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["district_name"] ?></span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Concelho</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["county_name"] ?></span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Morada</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800">
                                                            <?php echo $user_info_data["address"] . ' ' . $user_info_data["door_number"] . ' ' . $user_info_data["floor"]
                                                            ?>
                                                        </span>
                                                    </div>
                                                </div>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Código-Postal</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["zipcode"] ?></span>
                                                    </div>
                                                </div>

                                                <?php if($_SESSION['active_role'] === "Patient") { ?>
                                                    <div class="row mb-7">
                                                        <label class="col-lg-4 fw-semibold text-muted">Número de Utente</label>
                                                        <div class="col-lg-8">
                                                            <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["patient_number"] ?></span>
                                                        </div>
                                                    </div>
                                                <?php }else if($_SESSION['active_role'] === "Doctor") { ?>
                                                    <div class="row mb-7">
                                                        <label class="col-lg-4 fw-semibold text-muted">Número de Cédula Profissional</label>
                                                        <div class="col-lg-8">
                                                            <span class="fw-bold fs-6 text-gray-800"><?php echo $user_info_data["doctor_number"] ?></span>
                                                        </div>
                                                    </div>
                                                <?php } ?>

                                                <div class="row mb-7">
                                                    <label class="col-lg-4 fw-semibold text-muted">Utilizador criado em:</label>
                                                    <div class="col-lg-8">
                                                        <span class="fw-bold fs-6 text-gray-800"><?php echo (new DateTime($user_info_data["created_at"]))->format("d/m/Y - H:i"); ?></span>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <!--end::Card body-->
                                </div>
                                <!--end::details View-->

                            </div>
                        </div>
                        <?php require_once($_SERVER["DOCUMENT_ROOT"] . "/footer.php") ?>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <?php require_once($_SERVER["DOCUMENT_ROOT"] . "/foo.php") ?>

</body>

</html>