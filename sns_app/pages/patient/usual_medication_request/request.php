<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/head.php") ?>
<?php $page_name = "Novo Pedido de Medicação Habitual" ?>
<?php require_once($_SERVER["DOCUMENT_ROOT"] . "/api/api.php") ?>
<?php
$id_patient = $_SESSION["hashed_id"];
$api = new Api();

$usual_medicantion = $api->post("medications/usual_medication/", ["hashed_id_patient" => $id_patient], null);
$usual_medicantion_list = $usual_medicantion["response"]["data"];
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
                                            <h3 class="fw-bold m-0">Adicionar Novo Pedido de Medicação Habitual</h3>
                                        </div>
                                        <!--end::Card title-->
                                    </div>
                                    <!--begin::Card header-->
                                    <!--begin::Content-->
                                    <div id="kt_account_settings_profile_details" class="collapse show">
                                        <!--begin::Form-->
                                        <form id="form-request-usual-medication" class="form fv-plugins-bootstrap5 fv-plugins-framework" novalidate="novalidate">
                                            <!--begin::Card body-->
                                            <div class="card-body border-top p-9">

                                                <div class="row mb-6">
                                                    <div class="col-12 col-lg-6">
                                                        <label class="col-lg-12 col-form-label required fw-semibold fs-6">Medicação Habitual</label>
                                                        <select class="form-select form-select-solid" name="hashed_id_usual_medication" data-control="select2" data-placeholder="Selecione a Medicação Habitual">
                                                            <option></option>
                                                            <?php foreach ($usual_medicantion_list as $key => $value) { ?>
                                                                <option value="<?php echo $value["hashed_id_medication"] ?>"><?php echo $value["medication_name"] ?></option>
                                                            <?php } ?>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            <!--end::Card body-->
                                            <!--begin::Actions-->
                                            <div class="card-footer d-flex justify-content-end py-6 px-9">
                                                <button type="reset" class="btn btn-light btn-active-light-primary me-2">Cancelar</button>
                                                <button type="submit" class="btn btn-primary" id="kt_account_profile_details_submit">Pedir</button>
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
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("form-request-usual-medication");
            form.addEventListener("submit", requestUsualMedication);

            const api_url = "http://localhost:3000/api/";
            const path = "medications/usual_medication/request";

            function requestUsualMedication() {
                event.preventDefault();

                var form = document.getElementById("form-request-usual-medication");

                const formData = {
                    hashed_id_medication: form.hashed_id_usual_medication.value,
                    hashed_id_patient: "<?php echo $id_patient ?>"
                };


                fetch(api_url + path, {
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
                            Swal.fire({
                                icon: "error",
                                title: "Ocorreu um Erro!",
                                text: data.message,
                                confirmButtonText: "Voltar ao Pedido",
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