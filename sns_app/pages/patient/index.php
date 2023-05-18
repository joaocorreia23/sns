<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php $id_patient = $_SESSION["hashed_id"]; ?>
<?php
$api = new Api();
$user_info = $api->fetch("users/", null, $id_patient);
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

                                <div class="row">

                                    <div class="col-xl-8 mb-xl-10">
                                        <!--begin::Lists Widget 19-->
                                        <div class="card card-flush h-xl-100">
                                            <!--begin::Heading-->
                                            <div class="card-header rounded bgi-no-repeat bgi-size-cover bgi-position-y-top bgi-position-x-center align-items-start h-250px" style="background-image:url('<?php echo $link_home ?>assets/media/svg/shapes/abstract-2.svg" data-bs-theme="light">
                                                <!--begin::Title-->
                                                <h3 class="card-title align-items-start flex-column text-green pt-15">
                                                    <span class="fw-bold fs-2x mb-3 text-green">Olá, <?php echo $user_info_data["first_name"] . ' ' . $user_info_data["last_name"] ?></span>
                                                    <div class="fs-4 text-green">
                                                        <span class="opacity-75">You have</span>
                                                        <span class="position-relative d-inline-block">
                                                            <a class="link-white text-green opacity-75-hover fw-bold d-block mb-1">4 tasks</a>
                                                            <!--begin::Separator-->
                                                            <span class="position-absolute opacity-50 bottom-0 start-0 border-2 border-body border-bottom w-100"></span>
                                                            <!--end::Separator-->
                                                        </span>
                                                        <span class="opacity-75">to comlete</span>
                                                    </div>
                                                </h3>
                                                <!--end::Title-->
                                            </div>
                                            <!--end::Heading-->
                                            <!--begin::Body-->
                                            <div class="card-body mt-n20">
                                                <div class="mt-n20 position-relative">
                                                    <div class="row g-3 g-lg-6">
                                                        <div class="col-4">
                                                            <a href="schedule/index">
                                                                <div class="bg-gray-100 bg-opacity-70 rounded-2 px-6 py-5">
                                                                    <div class="symbol symbol-30px me-5 mb-8">
                                                                        <span class="symbol-label">
                                                                            <i class="ki-outline ki-calendar fs-2hx text-primary"></i>
                                                                        </span>
                                                                    </div>
                                                                    <div class="m-0">
                                                                        <span class="text-gray-700 fw-bolder d-block fs-3 lh-1 mb-1">A Minha Agenda</span>
                                                                    </div>
                                                                </div>
                                                            </a>
                                                        </div>

                                                        <div class="col-4">
                                                            <a href="appointments/list">
                                                                <div class="bg-gray-100 bg-opacity-70 rounded-2 px-6 py-5">
                                                                    <div class="symbol symbol-30px me-5 mb-8">
                                                                        <span class="symbol-label">
                                                                            <i class="ki-outline ki-calendar-8 fs-2hx text-primary"></i>
                                                                        </span>
                                                                    </div>
                                                                    <div class="m-0">
                                                                        <span class="text-gray-700 fw-bolder d-block fs-3 lh-1 mb-1">As Minhas Consultas</span>
                                                                    </div>
                                                                </div>
                                                            </a>
                                                        </div>

                                                        <div class="col-4">
                                                            <a href="medications/list">
                                                                <div class="bg-gray-100 bg-opacity-70 rounded-2 px-6 py-5">
                                                                    <div class="symbol symbol-30px me-5 mb-8">
                                                                        <span class="symbol-label">
                                                                            <i class="ki-outline ki-capsule fs-2hx text-primary"></i>
                                                                        </span>
                                                                    </div>
                                                                    <div class="m-0">
                                                                        <span class="text-gray-700 fw-bolder d-block fs-3 lh-1 mb-1">A Minha Medicação</span>
                                                                    </div>
                                                                </div>
                                                            </a>
                                                        </div>

                                                        <div class="col-4">
                                                            <a href="exams/list">
                                                                <div class="bg-gray-100 bg-opacity-70 rounded-2 px-6 py-5">
                                                                    <div class="symbol symbol-30px me-5 mb-8">
                                                                        <span class="symbol-label">
                                                                            <i class="ki-outline ki-document fs-2hx text-primary"></i>
                                                                        </span>
                                                                    </div>
                                                                    <div class="m-0">
                                                                        <span class="text-gray-700 fw-bolder d-block fs-3 lh-1 mb-1">Os Meus Exames</span>
                                                                    </div>
                                                                </div>
                                                            </a>
                                                        </div>

                                                        <div class="col-4">
                                                            <a href="vaccines/list">
                                                                <div class="bg-gray-100 bg-opacity-70 rounded-2 px-6 py-5">
                                                                    <div class="symbol symbol-30px me-5 mb-8">
                                                                        <span class="symbol-label">
                                                                            <i class="ki-outline ki-syringe fs-2hx text-primary"></i>
                                                                        </span>
                                                                    </div>
                                                                    <div class="m-0">
                                                                        <span class="text-gray-700 fw-bolder d-block fs-3 lh-1 mb-1">Boletim Vacinas</span>
                                                                    </div>
                                                                </div>
                                                            </a>
                                                        </div>

                                                        <div class="col-4">
                                                            <a href="<?php echo $link_home ?>profile">
                                                                <div class="bg-gray-100 bg-opacity-70 rounded-2 px-6 py-5">
                                                                    <div class="symbol symbol-30px me-5 mb-8">
                                                                        <span class="symbol-label">
                                                                            <i class="ki-outline ki-user fs-2hx text-primary"></i>
                                                                        </span>
                                                                    </div>
                                                                    <div class="m-0">
                                                                        <span class="text-gray-700 fw-bolder d-block fs-3 lh-1 mb-1">O Meu Perfil</span>
                                                                    </div>
                                                                </div>
                                                            </a>
                                                        </div>

                                                    </div>
                                                    <!--end::Row-->
                                                </div>
                                                <!--end::Stats-->
                                            </div>
                                            <!--end::Body-->
                                        </div>
                                        <!--end::Lists Widget 19-->
                                    </div>

                                    <div class="col-xl-4 mb-xl-10">
                                        <!--begin::Engage widget 3-->
                                        <div class="card background-green h-md-100" data-bs-theme="light">
                                            <!--begin::Body-->
                                            <div class="card-body d-flex flex-column pt-13 pb-14">
                                                <!--begin::Heading-->
                                                <div class="m-0">
                                                    <!--begin::Title-->
                                                    <h1 class="fw-semibold text-white text-center lh-lg mb-9">Nunca foi tão Fácil!
                                                        <br>
                                                        <span class="fw-bolder">Medicação Habitual</span>
                                                    </h1>
                                                    <!--end::Title-->
                                                    <!--begin::Illustration-->
                                                    <div class="flex-grow-1 bgi-no-repeat bgi-size-contain bgi-position-x-center card-rounded-bottom h-200px mh-200px my-5 mb-lg-12" style="background-image:url('<?php echo $link_home ?>assets/media/svg/illustrations/easy/5.svg')"></div>
                                                    <!--end::Illustration-->
                                                </div>
                                                <!--end::Heading-->
                                                <!--begin::Links-->
                                                <div class="text-center">
                                                    <!--begin::Link-->
                                                    <a class="btn btn-sm bg-white btn-color-gray-800 me-2">Pedir Agora!</a>
                                                    <!--end::Link-->
                                                </div>
                                                <!--end::Links-->
                                            </div>
                                            <!--end::Body-->
                                        </div>
                                        <!--end::Engage widget 3-->
                                    </div>

                                </div>

                                <div class="row gy-5 g-xl-10">
                                    <!--begin::Col-->
                                    <div class="col-sm-6 col-xl-2 mb-xl-10">
                                        <!--begin::Card widget 2-->
                                        <div class="card h-lg-100">
                                            <!--begin::Body-->
                                            <div class="card-body d-flex justify-content-between align-items-start flex-column">
                                                <!--begin::Icon-->
                                                <div class="m-0">
                                                    <i class="ki-outline ki-compass fs-2hx text-gray-600"></i>
                                                </div>
                                                <!--end::Icon-->
                                                <!--begin::Section-->
                                                <div class="d-flex flex-column my-7">
                                                    <!--begin::Number-->
                                                    <span class="fw-semibold fs-3x text-gray-800 lh-1 ls-n2">327</span>
                                                    <!--end::Number-->
                                                    <!--begin::Follower-->
                                                    <div class="m-0">
                                                        <span class="fw-semibold fs-6 text-gray-400">Projects</span>
                                                    </div>
                                                    <!--end::Follower-->
                                                </div>
                                                <!--end::Section-->
                                                <!--begin::Badge-->
                                                <span class="badge badge-light-success fs-base">
                                                    <i class="ki-outline ki-arrow-up fs-5 text-success ms-n1"></i>2.1%</span>
                                                <!--end::Badge-->
                                            </div>
                                            <!--end::Body-->
                                        </div>
                                        <!--end::Card widget 2-->
                                    </div>
                                    <!--end::Col-->
                                    <!--begin::Col-->
                                    <div class="col-sm-6 col-xl-2 mb-xl-10">
                                        <!--begin::Card widget 2-->
                                        <div class="card h-lg-100">
                                            <!--begin::Body-->
                                            <div class="card-body d-flex justify-content-between align-items-start flex-column">
                                                <!--begin::Icon-->
                                                <div class="m-0">
                                                    <i class="ki-outline ki-chart-simple fs-2hx text-gray-600"></i>
                                                </div>
                                                <!--end::Icon-->
                                                <!--begin::Section-->
                                                <div class="d-flex flex-column my-7">
                                                    <!--begin::Number-->
                                                    <span class="fw-semibold fs-3x text-gray-800 lh-1 ls-n2">27,5M</span>
                                                    <!--end::Number-->
                                                    <!--begin::Follower-->
                                                    <div class="m-0">
                                                        <span class="fw-semibold fs-6 text-gray-400">Stock Qty</span>
                                                    </div>
                                                    <!--end::Follower-->
                                                </div>
                                                <!--end::Section-->
                                                <!--begin::Badge-->
                                                <span class="badge badge-light-success fs-base">
                                                    <i class="ki-outline ki-arrow-up fs-5 text-success ms-n1"></i>2.1%</span>
                                                <!--end::Badge-->
                                            </div>
                                            <!--end::Body-->
                                        </div>
                                        <!--end::Card widget 2-->
                                    </div>
                                    <!--end::Col-->
                                    <!--begin::Col-->
                                    <div class="col-sm-6 col-xl-2 mb-xl-10">
                                        <!--begin::Card widget 2-->
                                        <div class="card h-lg-100">
                                            <!--begin::Body-->
                                            <div class="card-body d-flex justify-content-between align-items-start flex-column">
                                                <!--begin::Icon-->
                                                <div class="m-0">
                                                    <i class="ki-outline ki-abstract-39 fs-2hx text-gray-600"></i>
                                                </div>
                                                <!--end::Icon-->
                                                <!--begin::Section-->
                                                <div class="d-flex flex-column my-7">
                                                    <!--begin::Number-->
                                                    <span class="fw-semibold fs-3x text-gray-800 lh-1 ls-n2">149M</span>
                                                    <!--end::Number-->
                                                    <!--begin::Follower-->
                                                    <div class="m-0">
                                                        <span class="fw-semibold fs-6 text-gray-400">Stock Value</span>
                                                    </div>
                                                    <!--end::Follower-->
                                                </div>
                                                <!--end::Section-->
                                                <!--begin::Badge-->
                                                <span class="badge badge-light-danger fs-base">
                                                    <i class="ki-outline ki-arrow-down fs-5 text-danger ms-n1"></i>0.47%</span>
                                                <!--end::Badge-->
                                            </div>
                                            <!--end::Body-->
                                        </div>
                                        <!--end::Card widget 2-->
                                    </div>
                                    <!--end::Col-->
                                    <!--begin::Col-->
                                    <div class="col-sm-6 col-xl-2 mb-xl-10">
                                        <!--begin::Card widget 2-->
                                        <div class="card h-lg-100">
                                            <!--begin::Body-->
                                            <div class="card-body d-flex justify-content-between align-items-start flex-column">
                                                <!--begin::Icon-->
                                                <div class="m-0">
                                                    <i class="ki-outline ki-map fs-2hx text-gray-600"></i>
                                                </div>
                                                <!--end::Icon-->
                                                <!--begin::Section-->
                                                <div class="d-flex flex-column my-7">
                                                    <!--begin::Number-->
                                                    <span class="fw-semibold fs-3x text-gray-800 lh-1 ls-n2">89M</span>
                                                    <!--end::Number-->
                                                    <!--begin::Follower-->
                                                    <div class="m-0">
                                                        <span class="fw-semibold fs-6 text-gray-400">C APEX</span>
                                                    </div>
                                                    <!--end::Follower-->
                                                </div>
                                                <!--end::Section-->
                                                <!--begin::Badge-->
                                                <span class="badge badge-light-success fs-base">
                                                    <i class="ki-outline ki-arrow-up fs-5 text-success ms-n1"></i>2.1%</span>
                                                <!--end::Badge-->
                                            </div>
                                            <!--end::Body-->
                                        </div>
                                        <!--end::Card widget 2-->
                                    </div>
                                    <!--end::Col-->
                                    <!--begin::Col-->
                                    <div class="col-sm-6 col-xl-2 mb-5 mb-xl-10">
                                        <!--begin::Card widget 2-->
                                        <div class="card h-lg-100">
                                            <!--begin::Body-->
                                            <div class="card-body d-flex justify-content-between align-items-start flex-column">
                                                <!--begin::Icon-->
                                                <div class="m-0">
                                                    <i class="ki-outline ki-abstract-35 fs-2hx text-gray-600"></i>
                                                </div>
                                                <!--end::Icon-->
                                                <!--begin::Section-->
                                                <div class="d-flex flex-column my-7">
                                                    <!--begin::Number-->
                                                    <span class="fw-semibold fs-3x text-gray-800 lh-1 ls-n2">72.4%</span>
                                                    <!--end::Number-->
                                                    <!--begin::Follower-->
                                                    <div class="m-0">
                                                        <span class="fw-semibold fs-6 text-gray-400">OPEX</span>
                                                    </div>
                                                    <!--end::Follower-->
                                                </div>
                                                <!--end::Section-->
                                                <!--begin::Badge-->
                                                <span class="badge badge-light-danger fs-base">
                                                    <i class="ki-outline ki-arrow-down fs-5 text-danger ms-n1"></i>0.647%</span>
                                                <!--end::Badge-->
                                            </div>
                                            <!--end::Body-->
                                        </div>
                                        <!--end::Card widget 2-->
                                    </div>
                                    <!--end::Col-->
                                    <!--begin::Col-->
                                    <div class="col-sm-6 col-xl-2 mb-5 mb-xl-10">
                                        <!--begin::Card widget 2-->
                                        <div class="card h-lg-100">
                                            <!--begin::Body-->
                                            <div class="card-body d-flex justify-content-between align-items-start flex-column">
                                                <!--begin::Icon-->
                                                <div class="m-0">
                                                    <i class="ki-outline ki-abstract-26 fs-2hx text-gray-600"></i>
                                                </div>
                                                <!--end::Icon-->
                                                <!--begin::Section-->
                                                <div class="d-flex flex-column my-7">
                                                    <!--begin::Number-->
                                                    <span class="fw-semibold fs-3x text-gray-800 lh-1 ls-n2">106M</span>
                                                    <!--end::Number-->
                                                    <!--begin::Follower-->
                                                    <div class="m-0">
                                                        <span class="fw-semibold fs-6 text-gray-400">Saving</span>
                                                    </div>
                                                    <!--end::Follower-->
                                                </div>
                                                <!--end::Section-->
                                                <!--begin::Badge-->
                                                <span class="badge badge-light-success fs-base">
                                                    <i class="ki-outline ki-arrow-up fs-5 text-success ms-n1"></i>2.1%</span>
                                                <!--end::Badge-->
                                            </div>
                                            <!--end::Body-->
                                        </div>
                                        <!--end::Card widget 2-->
                                    </div>
                                    <!--end::Col-->
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