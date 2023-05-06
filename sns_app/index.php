<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>

<body id="kt_app_body" data-kt-app-header-fixed-mobile="true" data-kt-app-toolbar-enabled="true" class="app-default">

    <div class="modal fade show bg-role" id="kt_modal_two_factor_authentication" tabindex="-1" style="display: block;" aria-modal="true" role="dialog">
        <pre><?php print_r($_SESSION) ?></pre>
        <!--begin::Modal header-->
        <div class="modal-dialog modal-dialog-centered mw-650px">
            <!--begin::Modal content-->
            <div class="modal-content">
                <!--begin::Modal header-->
                <div class="modal-header flex-stack">
                    <!--begin::Title-->
                    <h2>Escolha o seu Perfil!</h2>
                    <!--end::Title-->

                </div>
                <!--begin::Modal header-->
                <!--begin::Modal body-->
                <div class="modal-body scroll-y pt-10 pb-15 px-lg-17">
                    <!--begin::Options-->
                    <div data-kt-element="options">
                        <!--begin::Notice-->
                        <p class="text-muted fs-5 fw-semibold mb-10">A sua conta tem vários perfis de utilizador. Escolha qual pretende iniciar sessão!</p>
                        <!--end::Notice-->
                        <!--begin::Wrapper-->
                        <div class="pb-10">

                            <?php foreach ($_SESSION["roles"] as $key => $value) { ?>
                                <?php if ($value === "Admin") { ?>
                                    <input type="radio" class="btn-check" name="Admin" value="Admin" id="Admin">
                                    <label class="btn btn-outline btn-outline-dashed btn-active-light-primary p-7 d-flex align-items-center mb-5" for="Admin">
                                        <i class="ki-outline ki-setting-2 fs-4x me-4"></i>
                                        <span class="d-block fw-semibold text-start">
                                            <span class="text-dark fw-bold d-block fs-3">Administrador</span>
                                            <span class="text-muted fw-semibold fs-6">Faça a gestão de Unidades de Saúde, Parametrizações, etc</span>
                                        </span>
                                    </label>
                                <?php } ?>
                                <?php if ($value === "Doctor") { ?>
                                    <input type="radio" class="btn-check" name="Doctor" value="Doctor" id="Doctor">
                                    <label class="btn btn-outline btn-outline-dashed btn-active-light-primary p-7 d-flex align-items-center mb-5" for="Doctor">
                                        <i class="ki-outline ki-capsule fs-4x me-4"></i>
                                        <span class="d-block fw-semibold text-start">
                                            <span class="text-dark fw-bold d-block fs-3">Médico</span>
                                            <span class="text-muted fw-semibold fs-6">Verifique a sua Agenda, os seus Utentes, etc</span>
                                        </span>
                                    </label>
                                <?php } ?>
                                <?php if ($value === "Patient") { ?>
                                    <input type="radio" class="btn-check" name="Patient" value="Patient" id="Patient">
                                    <label class="btn btn-outline btn-outline-dashed btn-active-light-primary p-7 d-flex align-items-center" for="Patient">
                                        <i class="ki-outline ki-user-tick fs-4x me-4"></i>
                                        <span class="d-block fw-semibold text-start">
                                            <span class="text-dark fw-bold d-block fs-3">Utente</span>
                                            <span class="text-muted fw-semibold fs-6">Veja as suas Consultas, Medicação e Vacinas, etc</span>
                                        </span>
                                    </label>
                                <?php } ?>
                            <?php } ?>

                        </div>
                        <!--end::Options-->
                    </div>
                    <!--end::Options-->
                </div>
                <!--begin::Modal body-->
            </div>
            <!--end::Modal content-->
        </div>
        <!--end::Modal header-->
    </div>

    <?php require_once($_SERVER["DOCUMENT_ROOT"] . "/foo.php") ?>

    <!-- Verificar a opçõa escolhida e fazer um FETCH ao auth.php para atualizar a $_SESSION["active_role] -->
    <script>
        $(document).ready(function() {
            $("input[name$='Admin']").click(function() {
                var role = $(this).val();

                const formData = new FormData();
                formData.append("action", "updateActiveRole");
                formData.append("role", role);

                fetch("api/auth.php", {
                        method: "POST",
                        body: formData
                    })
                    .then((response) => response.json())
                    .then((json) => {
                        console.log(json);
                        if (json.status === true) {
                            toastr.success("Selecionou o perfil de Administrador", "Sucesso!");
                            setTimeout(() => {
                                window.location.href = "<?php echo $link_home ?>pages/admin/index";
                            }, 650);
                        } else {
                            Swal.fire({
                                icon: "error",
                                title: "Oops...",
                                text: json.messages[0]
                            });
                        }
                    });
            });
            $("input[name$='Doctor']").click(function() {
                var role = $(this).val();

                const formData = new FormData();
                formData.append("action", "updateActiveRole");
                formData.append("role", role);

                fetch("api/auth.php", {
                        method: "POST",
                        body: formData
                    })
                    .then((response) => response.json())
                    .then((json) => {
                        console.log(json);
                        if (json.status === true) {
                            toastr.success("Selecionou o perfil de Médico", "Sucesso!");
                            setTimeout(() => {
                                window.location.href = "<?php echo $link_home ?>pages/doctor/index";
                            }, 650);
                        } else {
                            Swal.fire({
                                icon: "error",
                                title: "Oops...",
                                text: json.messages[0]
                            });
                        }
                    });
            });
            $("input[name$='Patient']").click(function() {
                var role = $(this).val();

                const formData = new FormData();
                formData.append("action", "updateActiveRole");
                formData.append("role", role);

                fetch("api/auth.php", {
                        method: "POST",
                        body: formData
                    })
                    .then((response) => response.json())
                    .then((json) => {
                        console.log(json);
                        if (json.status === true) {
                            toastr.success("Selecionou o perfil de Utente", "Sucesso!");
                            setTimeout(() => {
                                window.location.href = "<?php echo $link_home ?>pages/patient/index";
                            }, 650);
                        } else {
                            Swal.fire({
                                icon: "error",
                                title: "Oops...",
                                text: json.messages[0]
                            });
                        }
                    });
            });

        });
    </script>
</body>

</html>