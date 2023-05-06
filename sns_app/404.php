<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>

<body id="kt_app_body" data-kt-app-header-fixed-mobile="true" data-kt-app-toolbar-enabled="true" class="app-default">
    <!-- Content Here -->
    <div class="d-flex flex-column flex-root" id="kt_app_root">
        <!--begin::Page bg image-->
        <style>
            body {
                background-color: rgba(0, 0, 0, 0.5);
                background: linear-gradient(90deg, rgba(1, 145, 71, 1) 0%, rgba(234, 189, 0, 1) 43%, rgba(206, 21, 0, 1) 100%);
            }
        </style>
        <!--end::Page bg image-->
        <!--begin::Authentication - Signup Welcome Message -->
        <div class="d-flex flex-column flex-center flex-column-fluid">
            <!--begin::Content-->
            <div class="d-flex flex-column flex-center text-center p-10">
                <!--begin::Wrapper-->
                <div class="card card-flush w-lg-650px py-5">
                    <div class="card-body py-15 py-lg-20">
                        <div class="mb-10">
                            <img src="<?php echo $link_home; ?>assets/media/uploads/logo.svg" class="mw-10 w-350px 0 mh-300px theme-light-show" alt="" />
                        </div>
                        <!--begin::Title-->
                        <h1 class="fw-bolder fs-2hx text-gray-900 mb-4">Erro!</h1>
                        <!--end::Title-->
                        <!--begin::Text-->
                        <div class="fw-semibold fs-6 text-gray-500 mb-7">Ocorreu um erro, tente novamente mais tarde ou contacte o serviços de suporte.</div>
                        <!--end::Text-->
                        <!--begin::Link-->
                        <div class="mb-0">
                            <?php
                            if ($_SESSION["active_role"] === "Admin") {
                                $href = $link_home . "pages/admin/index";
                            } else if ($_SESSION["active_role"] === "Doctor") {
                                $href = $link_home . "pages/doctor/index";
                            } else if ($_SESSION["active_role"] === "Patient") {
                                $href = $link_home . "pages/patient/index";
                            }
                            ?>
                            <a href="<?php echo $href ?>" class="btn btn-sm btn-primary">Voltar Aréa Reservada</a>

                        </div>
                        <!--end::Link-->
                    </div>
                </div>
                <!--end::Wrapper-->
            </div>
            <!--end::Content-->
        </div>
        <!--end::Authentication - Signup Welcome Message-->
    </div>

    <?php require_once($_SERVER["DOCUMENT_ROOT"] . "/foo.php") ?>

</body>

</html>