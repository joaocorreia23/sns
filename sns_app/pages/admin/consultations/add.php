<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php $page_name = "Adicionar Nova Consulta" ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php
$api = new Api();

$health_unit = $api->fetch("health_unit/", null, null);
$health_unit_list = $health_unit["response"];

$doctors = $api->fetch("users/role", null, "Doctor");
$doctors_list = $doctors["response"]["data"];

$patients = $api->fetch("users/role", null, "Patient");
$patients_list = $patients["response"]["data"];
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

                                <!-- Content Here -->
                                <div class="card mb-5 mb-xl-10">
                                    <!--begin::Card header-->
                                    <div class="card-header border-0 cursor-pointer" role="button" data-bs-toggle="collapse" data-bs-target="#kt_account_profile_details" aria-expanded="true" aria-controls="kt_account_profile_details">
                                        <!--begin::Card title-->
                                        <div class="card-title m-0">
                                            <h3 class="fw-bold m-0">Adicionar Nova Consulta</h3>
                                        </div>
                                        <!--end::Card title-->
                                    </div>
                                    <!--begin::Card header-->
                                    <!--begin::Content-->
                                    <div id="kt_account_settings_profile_details" class="collapse show">
                                        <!--begin::Form-->
                                        <form id="form-add-consultation" class="form fv-plugins-bootstrap5 fv-plugins-framework" novalidate="novalidate">
                                            <!--begin::Card body-->
                                            <div class="card-body border-top p-9">

                                                <div class="row mb-6">
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Unidade de Saúde</label>
                                                        <select class="form-select form-select-solid" name="hashed_id_health_unit" data-control="select2" data-placeholder="Selecione a Unidade de Saúde">
                                                            <option></option>
                                                            <?php foreach ($health_unit_list as $key => $value) { ?>
                                                                <option value="<?php echo $value["hashed_id"] ?>"><?php echo $value["name"] ?></option>
                                                            <?php } ?>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Médico</label>
                                                        <select class="form-select form-select-solid" name="hashed_id_doctor" data-control="select2" data-placeholder="Selecione o Médico">
                                                            <option></option>
                                                            <?php foreach ($doctors_list as $key => $value) { ?>
                                                                <option value="<?php echo $value["hashed_id"] ?>"><?php echo $value["first_name"] . ' ' . $value["last_name"] ?></option>
                                                            <?php } ?>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Utente</label>
                                                        <select class="form-select form-select-solid" name="hashed_id_patient" data-control="select2" data-placeholder="Selecione o Paciente">
                                                            <option></option>
                                                            <?php foreach ($patients_list as $key => $value) { ?>
                                                                <option value="<?php echo $value["hashed_id"] ?>"><?php echo $value["first_name"] . ' ' . $value["last_name"] ?></option>
                                                            <?php } ?>
                                                        </select>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Data da Consulta</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input class="form-control form-control-solid" placeholder="Selecione a Data da Consulta" id="start_date" />
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Hora Inicio da Consulta</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input class="form-control form-control-solid" placeholder="Selecione a Hora de Inicio da Consulta" id="start_time" />
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                    <div class="col-12 col-lg-4">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Hora Fim da Consulta</label>
                                                        <div class="col-lg-12 fv-row fv-plugins-icon-container">
                                                            <input class="form-control form-control-solid" placeholder="Selecione a Hora de Fim da Consulta" id="end_time" />
                                                            <div class="fv-plugins-message-container invalid-feedback"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!--end::Card body-->
                                            <!--begin::Actions-->
                                            <div class="card-footer d-flex justify-content-end py-6 px-9">
                                                <button type="reset" class="btn btn-light btn-active-light-primary me-2">Cancelar</button>
                                                <button type="submit" class="btn btn-primary" id="kt_account_profile_details_submit">Guardar</button>
                                            </div>
                                            <!--end::Actions-->
                                            <input type="hidden">
                                        </form>
                                        <!--end::Form-->
                                    </div>
                                    <!--end::Content-->
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

    <script>
        $("#start_date").flatpickr();
        flatpickr("#start_date", {
            dateFormat: "Y-m-d",
            locale: "pt",
            allowInput: true,
        });
        $("#start_time").flatpickr({
            enableTime: true,
            noCalendar: true,
            time_24hr: true,
            dateFormat: "H:i",
            minuteIncrement: 1,
        });
        $("#end_time").flatpickr({
            enableTime: true,
            noCalendar: true,
            time_24hr: true,
            dateFormat: "H:i",
            minuteIncrement: 1,
        });
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("form-add-consultation");
            form.addEventListener("submit", insertConsultation);

            const api_url = "http://localhost:3000/api/";
            const path = "appointments/";

            function insertConsultation() {
                event.preventDefault();

                var form = document.getElementById("form-add-consultation");

                const formData = {
                    hashed_id_health_unit: form.hashed_id_health_unit.value,
                    hashed_id_doctor: form.hashed_id_doctor.value,
                    hashed_id_patient: form.hashed_id_patient.value,
                    start_date: form.start_date.value,
                    start_time: form.start_time.value,
                    end_time: form.end_time.value,
                };


                fetch(api_url + path + "insert", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify(formData),
                    })
                    .then((response) => response.json())
                    .then((data) => {
                        if (data.status) {
                            Swal.fire({
                                icon: "success",
                                title: "Sucesso!",
                                text: data.message,
                                buttonsStyling: false,
                                allowOutsideClick: false,
                                didOpen: () => {
                                    const confirmButton = Swal.getConfirmButton();
                                    confirmButton.blur();
                                },
                                customClass: {
                                    confirmButton: "btn fw-bold btn-primary",
                                },
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.location.href = "list";
                                }
                            });
                        } else {
                            console.log(JSON.stringify(formData)),
                                Swal.fire({
                                    icon: "error",
                                    title: "Ocorreu um Erro!",
                                    text: data.error,
                                    confirmButtonText: "Voltar a Marcação",
                                    buttonsStyling: false,
                                    customClass: {
                                        confirmButton: "btn btn-danger",
                                    },
                                });
                        }
                    })
                    .catch((error) => {
                        console.error("Error:", error);
                    });
            }
        });
    </script>

</body>

</html>