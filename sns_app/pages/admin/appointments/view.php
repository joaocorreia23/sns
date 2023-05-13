<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php

$get_tab = isset($_GET["tab"]) ? $_GET["tab"] : "appointment_tab_1";

$id_appointment = $_GET["id"];
$api = new Api();
$appointment_info = $api->fetch("appointments", null, $id_appointment);
if (!$appointment_info['status']) {
    header("Location: /pages/admin/appointments/list");
    exit();
} else {
    $appointment_info = $appointment_info["response"]['data'];
}
$page_name = $appointment_info["title"];
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
                                <div class="card h-100">
                                    <div class="card-body pt-9 pb-0 d-flex flex-column justify-content-between">
                                        <div class="d-flex flex-wrap flex-sm-nowrap flex-column flex-sm-row flex-lg-column flex-xxl-row">
                                            <div class="me-7 mb-4">
                                                <div class="symbol symbol-100px symbol-lg-160px symbol-fixed position-relative">
                                                    <img src="http://sns.localhost/assets/media/uploads/ico.png" alt="" style="object-fit: cover;" />
                                                    <div class="position-absolute translate-middle bottom-0 start-100 mb-6 bg-success rounded-circle border border-4 border-body h-20px w-20px"></div>
                                                </div>
                                            </div>

                                            <div class="flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-start flex-wrap gap-4 mb-2">
                                                    <div class="d-flex flex-column mb-4">
                                                        <div class="d-flex align-items-center mb-2">
                                                            <p class="text-gray-900 fs-2 fw-bold m-0 lh-sm"><?php echo $appointment_info['patient_first_name'] . ' ' . $appointment_info['patient_last_name'] ?></p>
                                                        </div>

                                                        <div class="d-flex flex-wrap gap-1 fw-semibold fs-6">
                                                            <?php echo $appointment_info["patient_gender"]; ?>
                                                        </div>
                                                    </div>
                                                    <div class="d-flex">

                                                        <!--begin::Menu-->
                                                        <div class="me-0">
                                                            <button class="btn btn-sm btn-icon btn-bg-light btn-active-color-primary" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end" control-id="ControlID-8">
                                                                <i class="ki-solid ki-dots-horizontal fs-2x me-1"></i> </button>

                                                            <!--begin::Menu 3-->
                                                            <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg-light-primary fw-semibold w-200px py-3" data-kt-menu="true" style="">
                                                                <!--begin::Heading-->
                                                                <div class="menu-item px-3">
                                                                    <div class="menu-content text-muted pb-2 px-3 fs-7 text-uppercase">
                                                                        ESTADO
                                                                    </div>
                                                                </div>
                                                                <!--end::Heading-->

                                                                <!--begin::Menu item-->
                                                                <div class="menu-item px-3">
                                                                    <a href="#" class="menu-link flex-stack px-3">
                                                                        Pendente
                                                                        <span class="ms-2" data-bs-toggle="tooltip" aria-label="Alterar estado da consulta para Pendente" data-bs-original-title="" data-kt-initialized="1">
                                                                            <i class="ki-duotone ki-information fs-6">
                                                                                <span class="path1"></span>
                                                                                <span class="path2"></span>
                                                                                <span class="path3"></span>
                                                                            </i>
                                                                        </span>
                                                                    </a>
                                                                </div>
                                                                <!--end::Menu item-->
                                                                <!--begin::Menu item-->
                                                                <div class="menu-item px-3">
                                                                    <a href="#" class="menu-link flex-stack px-3">
                                                                        Concluida
                                                                        <span class="ms-2" data-bs-toggle="tooltip" aria-label="Alterar estado da consulta para Pendente" data-bs-original-title="" data-kt-initialized="1">
                                                                            <i class="ki-duotone ki-information fs-6">
                                                                                <span class="path1"></span>
                                                                                <span class="path2"></span>
                                                                                <span class="path3"></span>
                                                                            </i>
                                                                        </span>
                                                                    </a>
                                                                </div>
                                                                <!--end::Menu item-->
                                                                <!--begin::Menu item-->
                                                                <div class="menu-item px-3">
                                                                    <a href="#" class="menu-link flex-stack px-3">
                                                                        Não Compareceu
                                                                        <span class="ms-2" data-bs-toggle="tooltip" aria-label="Alterar estado da consulta para Pendente" data-bs-original-title="" data-kt-initialized="1">
                                                                            <i class="ki-duotone ki-information fs-6">
                                                                                <span class="path1"></span>
                                                                                <span class="path2"></span>
                                                                                <span class="path3"></span>
                                                                            </i>
                                                                        </span>
                                                                    </a>
                                                                </div>
                                                                <!--end::Menu item-->
                                                                <!--begin::Menu item-->
                                                                <div class="menu-item px-3">
                                                                    <a href="#" class="menu-link flex-stack px-3">
                                                                        Cancelada
                                                                        <span class="ms-2" data-bs-toggle="tooltip" aria-label="Alterar estado da consulta para Pendente" data-bs-original-title="" data-kt-initialized="1">
                                                                            <i class="ki-duotone ki-information fs-6">
                                                                                <span class="path1"></span>
                                                                                <span class="path2"></span>
                                                                                <span class="path3"></span>
                                                                            </i>
                                                                        </span>
                                                                    </a>
                                                                </div>
                                                                <!--end::Menu item-->
                                                                <!--begin::Menu item-->
                                                                <div class="menu-item px-3">
                                                                    <a href="#" class="menu-link flex-stack px-3">
                                                                        Eliminada
                                                                        <span class="ms-2" data-bs-toggle="tooltip" aria-label="Alterar estado da consulta para Pendente" data-bs-original-title="" data-kt-initialized="1">
                                                                            <i class="ki-duotone ki-information fs-6">
                                                                                <span class="path1"></span>
                                                                                <span class="path2"></span>
                                                                                <span class="path3"></span>
                                                                            </i>
                                                                        </span>
                                                                    </a>
                                                                </div>
                                                                <!--end::Menu item-->

                                                            </div>
                                                            <!--end::Menu 3-->
                                                        </div>
                                                        <!--end::Menu-->
                                                    </div>
                                                </div>

                                                <div class="d-flex flex-wrap flex-stack">
                                                    <div class="d-flex flex-column flex-grow-1 pe-8">
                                                        <div class="d-flex flex-wrap">
                                                            <div class="border border-gray-300 border-dashed rounded min-w-125px py-3 px-4 py-lg-4 px-xxl-5 me-6 mb-3">
                                                                <div class="d-flex align-items-center">
                                                                    <div class="fs-4"><?php echo $appointment_info['patient_phone_number']; ?></div>
                                                                </div>
                                                                <div class="fw-semibold fs-7 text-gray-400">Contacto</div>
                                                            </div>

                                                            <div class="border border-gray-300 border-dashed rounded min-w-125px py-3 px-4 py-lg-4 px-xxl-5 me-6 mb-3">
                                                                <div class="d-flex align-items-center">
                                                                    <div class="fs-4"><?php echo $appointment_info['patient_email']; ?></div>
                                                                </div>
                                                                <div class="fw-semibold fs-7 text-gray-400">E-mail</div>
                                                            </div>

                                                            <div class="border border-gray-300 border-dashed rounded min-w-125px py-3 px-4 py-lg-4 px-xxl-5 me-6 mb-3">
                                                                <div class="d-flex align-items-center">
                                                                    <div class="fs-4"><?php echo $appointment_info['patient_tax_number']; ?></div>
                                                                </div>
                                                                <div class="fw-semibold fs-7 text-gray-400">NIF</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>

                                            </div>
                                        </div>

                                        <ul class="nav nav-stretch nav-line-tabs nav-line-tabs-2x border-transparent fs-5 fw-bold mt-4" id="main-nav">
                                            <li class="nav-item mt-2">
                                                <a class="nav-link text-active-primary ms-0 me-10 py-5 <?php if ($get_tab === "appointment_tab_1") echo "active"; ?>" href="?id=<?php echo $id_appointment; ?>&tab=appointment_tab_1">Informações Gerais</a>
                                            </li>
                                            <li class="nav-item mt-2">
                                                <a class="nav-link text-active-primary ms-0 me-10 py-5 <?php if ($get_tab === "appointment_tab_2") echo "active"; ?>" href="?id=<?php echo $id_appointment; ?>&tab=appointment_tab_2">Medicação</a>
                                            </li>
                                            <li class="nav-item mt-2">
                                                <a class="nav-link text-active-primary ms-0 me-10 py-5 <?php if ($get_tab === "appointment_tab_3") echo "active"; ?>" href="?id=<?php echo $id_appointment; ?>&tab=appointment_tab_3">Exames</a>
                                            </li>
                                            <li class="nav-item mt-2">
                                                <a class="nav-link text-active-primary ms-0 me-10 py-5 <?php if ($get_tab === "appointment_tab_4") echo "active"; ?>" href="?id=<?php echo $id_appointment; ?>&tab=appointment_tab_4">Vacinas</a>
                                            </li>

                                        </ul>
                                    </div>
                                </div>
                                <div class="tab-content" id="tab-content">
                                    <?php if ($get_tab === "appointment_tab_1") require_once($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/details.php"); ?>
                                    <?php if ($get_tab === "appointment_tab_2") require_once($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/medications.php"); ?>
                                    <?php if ($get_tab === "appointment_tab_3") require_once($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/exams.php"); ?>
                                    <?php if ($get_tab === "appointment_tab_4") require_once($_SERVER["DOCUMENT_ROOT"] . "/pages/admin/appointments/components/vaccines.php"); ?>
                                </div>
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